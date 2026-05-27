import 'dart:async';
import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:http/http.dart' as http;

/// Central HTTP client that automatically refreshes the JWT access token on 401
/// and forces logout if the refresh token is also expired.
///
/// Usage: replace `http.get(uri, headers: await _buildHeaders())` with
/// `ApiClient.get(uri)` in any service. The client handles auth headers,
/// token refresh and session expiry internally.
class ApiClient {
  ApiClient._();

  /// Set once from app.dart. Called after tokens are cleared when the session
  /// cannot be recovered (refresh token also expired).
  static void Function()? onSessionExpired;

  /// Set once from app.dart. Called when the backend returns 401 with
  /// code: "account_blocked". Tokens are cleared before this fires.
  static void Function()? onAccountBlocked;

  /// Set once from app.dart. Called when the backend returns 401 with
  /// code: "account_suspended". Tokens are cleared before this fires.
  static void Function()? onAccountSuspended;

  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;

  static Future<Map<String, String>> _buildHeaders() async {
    final token = await TokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Tries to get a new access token using the stored refresh token.
  /// Returns true if successful, false otherwise.
  /// Concurrent calls wait for the single in-flight refresh to complete.
  static Future<bool> _tryRefresh() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    bool success = false;
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final response = await http
          .post(
            Uri.parse(ApiConfig.refresh),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refreshToken}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess = data['access'] as String?;
        if (newAccess != null && newAccess.isNotEmpty) {
          await TokenStorage.saveTokens(
            accessToken: newAccess,
            refreshToken: (data['refresh'] as String?) ?? refreshToken,
          );
          success = true;
        }
      }
    } catch (_) {
      success = false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter!.complete(success);
      _refreshCompleter = null;
    }

    return success;
  }

  static Future<void> _forceLogout() async {
    await TokenStorage.clearTokens();
    onSessionExpired?.call();
  }

  static Future<http.Response> _execute(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    final headers = await _buildHeaders();
    final response = await request(headers);

    if (response.statusCode != 401) return response;

    // Distinguish account blocked/suspended from expired token — don't refresh.
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final code = body['code'] as String?;
      if (code == 'account_blocked') {
        await TokenStorage.clearTokens();
        onAccountBlocked?.call();
        return response;
      }
      if (code == 'account_suspended') {
        await TokenStorage.clearTokens();
        onAccountSuspended?.call();
        return response;
      }
    } catch (_) {}

    final refreshed = await _tryRefresh();
    if (!refreshed) {
      await _forceLogout();
      return response;
    }

    final newHeaders = await _buildHeaders();
    return request(newHeaders);
  }

  static Future<http.Response> get(
    Uri uri, {
    Duration timeout = const Duration(seconds: 10),
  }) {
    return _execute((h) => http.get(uri, headers: h).timeout(timeout));
  }

  static Future<http.Response> post(
    Uri uri, {
    Object? body,
    Duration timeout = const Duration(seconds: 10),
  }) {
    return _execute(
      (h) => http.post(uri, headers: h, body: body).timeout(timeout),
    );
  }

  static Future<http.Response> patch(
    Uri uri, {
    Object? body,
    Duration timeout = const Duration(seconds: 10),
  }) {
    return _execute(
      (h) => http.patch(uri, headers: h, body: body).timeout(timeout),
    );
  }

  static Future<http.Response> multipartPatch(
    Uri uri, {
    Map<String, String> fields = const {},
    List<http.MultipartFile> Function()? filesBuilder,
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _execute((h) async {
      final request = http.MultipartRequest('PATCH', uri);

      final headers = Map<String, String>.from(h);
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      request.fields.addAll(fields);

      if (filesBuilder != null) {
        request.files.addAll(filesBuilder());
      }

      final streamedResponse = await request.send().timeout(timeout);
      return http.Response.fromStream(streamedResponse);
    });
  }

  static Future<http.Response> delete(
    Uri uri, {
    Duration timeout = const Duration(seconds: 10),
  }) {
    return _execute((h) => http.delete(uri, headers: h).timeout(timeout));
  }
}
