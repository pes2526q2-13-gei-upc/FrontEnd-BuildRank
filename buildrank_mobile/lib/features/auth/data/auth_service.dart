import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:buildrank_mobile/core/config/api_config.dart';
import 'token_storage.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final access = data['access'];
      final refresh = data['refresh'];

      await TokenStorage.saveTokens(
        accessToken: access,
        refreshToken: refresh,
      );

      return data;
    } else {
      throw Exception(_extractErrorMessage(data));
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String passwordConfirm,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'password_confirm': passwordConfirm,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(_extractErrorMessage(data));
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final accessToken = await TokenStorage.getAccessToken();

    if (accessToken == null) {
      throw Exception('No hi ha cap token guardat.');
    }

    final response = await http.get(
      Uri.parse(ApiConfig.me),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(_extractErrorMessage(data));
    }
  }

  Future<void> logout() async {
    final accessToken = await TokenStorage.getAccessToken();
    final refreshToken = await TokenStorage.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      throw Exception('Falten tokens per tancar la sessió.');
    }

    final response = await http.post(
      Uri.parse(ApiConfig.logout),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'refresh': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      await TokenStorage.clearTokens();
    } else {
      final data = jsonDecode(response.body);
      throw Exception(_extractErrorMessage(data));
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        return data['detail'].toString();
      }

      if (data.containsKey('non_field_errors')) {
        final value = data['non_field_errors'];
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
      }

      for (final entry in data.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
        if (value is String) {
          return value;
        }
      }
    }

    return 'S’ha produït un error inesperat.';
  }
}