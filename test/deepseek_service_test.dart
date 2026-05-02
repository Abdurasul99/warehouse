import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sales_system_warehouse_mobile/shared/services/deepseek_service.dart';

void main() {
  group('ChatMessage', () {
    test('serializes role and content to JSON', () {
      const m = ChatMessage(role: 'user', content: 'hi');
      expect(m.toJson(), {'role': 'user', 'content': 'hi'});
    });
  });

  group('DeepSeekService.chat (with mocked http client)', () {
    test('sends correct request body and returns assistant content', () async {
      Map<String, dynamic>? capturedBody;
      Map<String, String>? capturedHeaders;

      final mockClient = MockClient((request) async {
        capturedHeaders = request.headers;
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'choices': [
              {
                'message': {'role': 'assistant', 'content': 'Hello back'}
              }
            ]
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = DeepSeekService(client: mockClient);
      final reply = await service.chat(
        messages: const [ChatMessage(role: 'user', content: 'Hello')],
        systemPrompt: 'You are helpful',
      );

      expect(reply, 'Hello back');
      expect(capturedHeaders?['Content-Type'], contains('json'));
      expect(capturedHeaders?['Authorization'], startsWith('Bearer '));
      expect(capturedBody?['model'], 'deepseek-chat');
      final messages =
          (capturedBody?['messages'] as List).cast<Map<String, dynamic>>();
      expect(messages.first['role'], 'system');
      expect(messages.first['content'], 'You are helpful');
      expect(messages[1]['role'], 'user');
      expect(messages[1]['content'], 'Hello');
    });

    test('throws on non-200 status', () async {
      final mockClient = MockClient((_) async {
        return http.Response('upstream error', 500);
      });

      final service = DeepSeekService(client: mockClient);
      expect(
        () => service.chat(
          messages: const [ChatMessage(role: 'user', content: 'x')],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws on empty choices array', () async {
      final mockClient = MockClient((_) async {
        return http.Response(jsonEncode({'choices': []}), 200);
      });

      final service = DeepSeekService(client: mockClient);
      expect(
        () => service.chat(
          messages: const [ChatMessage(role: 'user', content: 'x')],
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('omits system prompt when null', () async {
      Map<String, dynamic>? capturedBody;
      final mockClient = MockClient((request) async {
        capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            'choices': [
              {
                'message': {'content': 'ok'}
              }
            ]
          }),
          200,
        );
      });

      final service = DeepSeekService(client: mockClient);
      await service.chat(
        messages: const [ChatMessage(role: 'user', content: 'q')],
      );

      final messages =
          (capturedBody?['messages'] as List).cast<Map<String, dynamic>>();
      expect(messages.length, 1);
      expect(messages.first['role'], 'user');
    });
  });
}
