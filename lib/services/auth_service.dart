import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthService {
  static const _kToken = 'auth_token';
  static const _kEmail = 'auth_email';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  Future<bool> hasToken() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);
  }

  Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmail);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kEmail);
  }

  /// Tries to authenticate against the backend.
  /// Expected response examples:
  /// - {"token": "..."}
  /// - {"accessToken": "..."}
  /// - {"data": {"token": "..."}}
  Future<String> login(ApiClient client, {required String email, required String password}) async {
    final res = await client.postJson('/auth/login', {
      'email': email,
      'password': password,
    });

    final token = _extractToken(res);
    if (token == null) {
      throw ApiException('Login muvaffaqiyatsiz: token qaytmadi');
    }
    await setToken(token);
    await setEmail(email);
    return token;
  }

  Future<String> register(ApiClient client, {required String email, required String password}) async {
    final res = await client.postJson('/auth/register', {
      'email': email,
      'password': password,
    });

    final token = _extractToken(res);
    if (token == null) {
      // Ba'zi backendlar registerdan keyin token bermaydi.
      // Bunday holatda login qilishni taklif qilamiz.
      return '';
    }
    await setToken(token);
    await setEmail(email);
    return token;
  }

  String? _extractToken(dynamic res) {
    if (res is Map) {
      if (res['token'] != null) return res['token'].toString();
      if (res['accessToken'] != null) return res['accessToken'].toString();
      if (res['data'] is Map) {
        final d = res['data'] as Map;
        if (d['token'] != null) return d['token'].toString();
        if (d['accessToken'] != null) return d['accessToken'].toString();
      }
    }
    return null;
  }
}
