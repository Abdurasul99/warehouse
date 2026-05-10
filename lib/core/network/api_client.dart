import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? token;

  Map<String, String> _headers({bool jsonBody = false}) {
    final h = <String, String>{'Accept': 'application/json'};
    if (jsonBody) h['Content-Type'] = 'application/json';
    final t = token;
    if (t != null && t.isNotEmpty) {
      h['Authorization'] = 'Bearer $t';
    }
    return h;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final base = Uri.parse('${ApiConfig.baseUrl}$path');
    if (query == null || query.isEmpty) return base;
    final params = <String, String>{};
    query.forEach((k, v) {
      if (v != null) params[k] = v.toString();
    });
    return base.replace(queryParameters: params);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await http
        .get(_uri(path, query), headers: _headers())
        .timeout(ApiConfig.receiveTimeout);
    return _decode(res);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final res = await http
        .post(
          _uri(path),
          headers: _headers(jsonBody: true),
          body: body == null ? null : jsonEncode(body),
        )
        .timeout(ApiConfig.receiveTimeout);
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    dynamic raw;
    try {
      raw = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    } catch (_) {
      raw = res.body;
    }

    // Sales System backend wraps every response in an envelope:
    //   { code, message, additionalMessage, responseTime, body }
    // Code "0000" means success — return body. Anything else => throw.
    if (raw is Map && raw['code'] is String && raw.containsKey('body')) {
      final code = raw['code'] as String;
      if (code == '0000') return raw['body'];
      final message = (raw['message'] as String?) ?? 'API error';
      throw ApiException(res.statusCode, message);
    }

    // Legacy flat response (e.g. /health) — return as-is on 2xx.
    final ok = res.statusCode >= 200 && res.statusCode < 300;
    if (ok) return raw;
    final message = (raw is Map && raw['error'] is String)
        ? raw['error'] as String
        : 'HTTP ${res.statusCode}';
    throw ApiException(res.statusCode, message);
  }
}
