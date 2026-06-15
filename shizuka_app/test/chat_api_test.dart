import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shizuka_app/api/chat_api.dart';

void main() {
  test('sends standard chat completions request body', () async {
    final backend = ChatBackendFactory.create(
      baseUrl: 'http://localhost:11434/v1',
      apiKey: 'local-key',
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(
          request.url.toString(),
          'http://localhost:11434/v1/chat/completions',
        );
        expect(request.headers['authorization'], 'Bearer local-key');

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['model'], 'gemma4-custom:latest');
        expect(body['stream'], false);
        expect(body['messages'], [
          {'role': 'system', 'content': '你是安静温柔的助手'},
          {'role': 'user', 'content': '你好'},
          {'role': 'assistant', 'content': '你好呀'},
        ]);

        return http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'id': 'chatcmpl-test',
              'model': 'gemma4-custom:latest',
              'choices': [
                {
                  'index': 0,
                  'message': {'role': 'assistant', 'content': '测试回复'},
                  'finish_reason': 'stop',
                },
              ],
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    final response = await backend.createChatCompletion(
      const ChatRequest(
        model: 'gemma4-custom:latest',
        messages: [
          ChatMessage(role: ChatRole.system, content: '你是安静温柔的助手'),
          ChatMessage(role: ChatRole.user, content: '你好'),
          ChatMessage(role: ChatRole.assistant, content: '你好呀'),
        ],
      ),
    );

    expect(response.text, '测试回复');
    expect(response.model, 'gemma4-custom:latest');
  });

  test('normalizes model list from openai-compatible backends', () async {
    final backend = ChatBackendFactory.create(
      baseUrl: 'https://api.openai.com/v1/',
      apiKey: 'sk-test',
      httpClient: MockClient((request) async {
        expect(request.url.toString(), 'https://api.openai.com/v1/models');
        return http.Response(
          jsonEncode({
            'object': 'list',
            'data': [
              {'id': 'gpt-4o-mini'},
              {'id': 'gpt-4.1'},
            ],
          }),
          200,
        );
      }),
    );

    expect(await backend.listModels(), ['gpt-4.1', 'gpt-4o-mini']);
  });
}
