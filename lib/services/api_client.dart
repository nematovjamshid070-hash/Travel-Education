import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import 'auth_service.dart';

class ApiClient {
  ApiClient({required this.authService});

  final AuthService authService;

  Uri _uri(String path) {
    final base = AppConfig.baseUrl;
    final cleaned = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$cleaned');
  }

  Future<Map<String, String>> _headers({bool json = true}) async {
    final token = await authService.getToken();
    final headers = <String, String>{
      if (json) 'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    return headers;
  }

  Future<dynamic> getJson(String path) async {
    final res = await http
        .get(_uri(path), headers: await _headers())
        .timeout(const Duration(seconds: 12));
    return _decode(res);
  }

  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    final res = await http
        .post(_uri(path), headers: await _headers(), body: jsonEncode(body))
        .timeout(const Duration(seconds: 12));
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    final contentType = res.headers['content-type'] ?? '';
    final isJson = contentType.contains('application/json');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (!isJson) return res.body;
      if (res.body.trim().isEmpty) return null;
      return jsonDecode(res.body);
    }

    // Try to parse JSON error body
    String message = 'HTTP ${res.statusCode}';
    if (isJson && res.body.trim().isNotEmpty) {
      try {
        final obj = jsonDecode(res.body);
        if (obj is Map && obj['message'] != null) {
          message = obj['message'].toString();
        } else {
          message = obj.toString();
        }
      } catch (_) {
        message = res.body;
      }
    } else if (res.body.trim().isNotEmpty) {
      message = res.body;
    }

    throw ApiException(message, statusCode: res.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => statusCode == null ? message : '($statusCode) $message';
}
