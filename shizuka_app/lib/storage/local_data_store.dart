import 'dart:convert';

import 'package:flutter/services.dart';

class LocalDataStore {
  static const _channel = MethodChannel('com.shizuka.app/local_data');
  static final Map<String, String> _fallbackFiles = {};

  static Future<void> ensureStructure() async {
    try {
      await _channel.invokeMethod<void>('ensureStructure');
    } on MissingPluginException {
      return;
    }
  }

  static Future<Map<String, dynamic>?> readMap(String path) async {
    final content = await _readText(path);
    if (content == null || content.trim().isEmpty) {
      return null;
    }

    final decoded = jsonDecode(content);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  static Future<void> writeMap(String path, Map<String, dynamic> value) async {
    await _writeText(path, const JsonEncoder.withIndent('  ').convert(value));
  }

  static Future<List<String>> listFiles(String directory) async {
    try {
      final result = await _channel.invokeListMethod<String>('listFiles', {
        'directory': directory,
      });
      return result ?? const [];
    } on MissingPluginException {
      return _fallbackFiles.keys
          .where((path) => path.startsWith('$directory/'))
          .toList();
    }
  }

  static Future<String?> writeBytes(String path, Uint8List bytes) async {
    try {
      return await _channel.invokeMethod<String>('writeBytes', {
        'path': path,
        'bytes': bytes,
      });
    } on MissingPluginException {
      return null;
    }
  }

  static Future<void> deleteFile(String path) async {
    _fallbackFiles.remove(path);
    try {
      await _channel.invokeMethod<void>('deleteFile', {'path': path});
    } on MissingPluginException {
      return;
    }
  }

  static Future<void> exportMapToDownloads({
    required String fileName,
    required Map<String, dynamic> value,
  }) async {
    await _channel.invokeMethod<void>('exportTextToDownloads', {
      'fileName': fileName,
      'mimeType': 'application/json',
      'content': const JsonEncoder.withIndent('  ').convert(value),
    });
  }

  static Future<String?> _readText(String path) async {
    try {
      return await _channel.invokeMethod<String>('readText', {'path': path});
    } on MissingPluginException {
      return _fallbackFiles[path];
    }
  }

  static Future<void> _writeText(String path, String content) async {
    _fallbackFiles[path] = content;
    try {
      await _channel.invokeMethod<void>('writeText', {
        'path': path,
        'content': content,
      });
    } on MissingPluginException {
      return;
    }
  }
}
