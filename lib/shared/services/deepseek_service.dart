import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_keys.dart';

class ChatMessage {
  final String role;
  final String content;
  const ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}

class DeepSeekService {
  static const _endpoint = 'https://api.deepseek.com/v1/chat/completions';
  static const _model = 'deepseek-chat';

  Future<String> chat({
    required List<ChatMessage> messages,
    String? systemPrompt,
  }) async {
    final body = {
      'model': _model,
      'messages': [
        if (systemPrompt != null)
          {'role': 'system', 'content': systemPrompt},
        ...messages.map((m) => m.toJson()),
      ],
      'temperature': 0.7,
      'max_tokens': 1500,
    };

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiKeys.deepseek}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'DeepSeek API error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
    final choices = decoded['choices'] as List;
    if (choices.isEmpty) {
      throw Exception('DeepSeek returned no choices');
    }
    final message = choices.first['message'] as Map<String, dynamic>;
    return message['content'] as String;
  }
}
