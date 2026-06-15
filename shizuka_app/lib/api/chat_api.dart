import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

enum ChatRole {
  system('system'),
  user('user'),
  assistant('assistant');

  const ChatRole(this.value);

  final String value;

  static ChatRole parse(String value) {
    return ChatRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => ChatRole.assistant,
    );
  }
}

class ChatMessage {
  const ChatMessage({required this.role, required this.content});

  final ChatRole role;
  final String content;

  Map<String, dynamic> toJson() => {'role': role.value, 'content': content};

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: ChatRole.parse(json['role'] as String? ?? 'assistant'),
      content: json['content'] as String? ?? '',
    );
  }
}

class ChatRequest {
  const ChatRequest({
    required this.model,
    required this.messages,
    this.temperature,
    this.maxTokens,
  });

  final String model;
  final List<ChatMessage> messages;
  final double? temperature;
  final int? maxTokens;

  Map<String, dynamic> toJson({bool stream = false}) {
    return {
      'model': model,
      'messages': [for (final message in messages) message.toJson()],
      if (temperature != null) 'temperature': temperature,
      if (maxTokens != null) 'max_tokens': maxTokens,
      'stream': stream,
    };
  }
}

class ChatChoice {
  const ChatChoice({
    required this.index,
    required this.message,
    this.finishReason,
  });

  final int index;
  final ChatMessage message;
  final String? finishReason;
}

class ChatUsage {
  const ChatUsage({this.promptTokens, this.completionTokens, this.totalTokens});

  final int? promptTokens;
  final int? completionTokens;
  final int? totalTokens;
}

class ChatResponse {
  const ChatResponse({
    required this.id,
    required this.model,
    required this.choices,
    this.created,
    this.usage,
    this.raw,
  });

  final String id;
  final String model;
  final List<ChatChoice> choices;
  final int? created;
  final ChatUsage? usage;
  final Map<String, dynamic>? raw;

  String get text {
    if (choices.isEmpty) {
      return '';
    }
    return choices.first.message.content;
  }
}

class ChatResponseChunk {
  const ChatResponseChunk({
    required this.id,
    required this.model,
    required this.delta,
    this.finishReason,
  });

  final String id;
  final String model;
  final String delta;
  final String? finishReason;
}

abstract class ChatBackend {
  Future<List<String>> listModels();

  Future<ChatResponse> createChatCompletion(ChatRequest request);

  Stream<ChatResponseChunk> streamChatCompletion(ChatRequest request);
}

class ChatBackendFactory {
  const ChatBackendFactory._();

  static ChatBackend create({
    required String baseUrl,
    required String apiKey,
    http.Client? httpClient,
  }) {
    return OpenAICompatibleChatBackend(
      baseUrl: baseUrl,
      apiKey: apiKey,
      httpClient: httpClient,
    );
  }
}

class OpenAICompatibleChatBackend implements ChatBackend {
  OpenAICompatibleChatBackend({
    required String baseUrl,
    required String apiKey,
    http.Client? httpClient,
  }) : _baseUrl = _normalizeBaseUrl(baseUrl),
       _apiKey = apiKey.trim(),
       _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final String _apiKey;
  final http.Client _httpClient;

  @override
  Future<List<String>> listModels() async {
    final response = await _httpClient
        .get(Uri.parse('$_baseUrl/models'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body);
    final data = decoded is Map<String, dynamic> ? decoded['data'] : null;
    final models = <String>[];
    if (data is List) {
      for (final item in data) {
        if (item is Map && item['id'] is String) {
          models.add(item['id'] as String);
        }
      }
    }
    models.sort();
    return models;
  }

  @override
  Future<ChatResponse> createChatCompletion(ChatRequest request) async {
    final response = await _httpClient
        .post(
          Uri.parse('$_baseUrl/chat/completions'),
          headers: _headers,
          body: jsonEncode(request.toJson()),
        )
        .timeout(const Duration(seconds: 60));

    _ensureSuccess(response);
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ChatApiException('响应格式无效');
    }
    return _toChatResponse(decoded);
  }

  @override
  Stream<ChatResponseChunk> streamChatCompletion(ChatRequest request) {
    // Reserved for SSE streaming. UI should depend on this interface, not on
    // any provider-specific implementation details.
    return const Stream.empty();
  }

  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_apiKey.isNotEmpty) 'Authorization': 'Bearer $_apiKey',
    };
  }

  static String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  static void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ChatApiException('请求失败：${response.statusCode}');
    }
  }

  static ChatResponse _toChatResponse(Map<String, dynamic> json) {
    final choicesJson = json['choices'];
    final choices = <ChatChoice>[];
    if (choicesJson is List) {
      for (final choice in choicesJson) {
        if (choice is! Map<String, dynamic>) {
          continue;
        }
        final message = choice['message'];
        choices.add(
          ChatChoice(
            index: choice['index'] as int? ?? choices.length,
            message: message is Map<String, dynamic>
                ? ChatMessage.fromJson(message)
                : const ChatMessage(role: ChatRole.assistant, content: ''),
            finishReason: choice['finish_reason'] as String?,
          ),
        );
      }
    }

    final usageJson = json['usage'];
    final usage = usageJson is Map<String, dynamic>
        ? ChatUsage(
            promptTokens: usageJson['prompt_tokens'] as int?,
            completionTokens: usageJson['completion_tokens'] as int?,
            totalTokens: usageJson['total_tokens'] as int?,
          )
        : null;

    return ChatResponse(
      id: json['id'] as String? ?? '',
      model: json['model'] as String? ?? '',
      created: json['created'] as int?,
      choices: choices,
      usage: usage,
      raw: json,
    );
  }
}

class ChatApiException implements Exception {
  const ChatApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
