import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

// Servicio central para hablar con el backend de auth.
class AuthService {
  bool _isGoogleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_isGoogleSignInInitialized) return;

    await GoogleSignIn.instance.initialize();

    _isGoogleSignInInitialized = true;
  }

  Future<Map<String, dynamic>> loginWithGoogle({
    String mode = 'login',
    String? role,
  }) async {
    try {
      await _ensureGoogleSignInInitialized();

      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw Exception(
          'Google Sign-In no està suportat en aquesta plataforma.',
        );
      }

      final googleAccount = await GoogleSignIn.instance.authenticate();
      final googleAuth = googleAccount.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google no ha retornat cap id_token.');
      }

      final response = await http.post(
        Uri.parse(ApiConfig.googleOAuth),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': idToken,
          'mode': mode,
          if (mode == 'register' && role != null && role.isNotEmpty)
            'role': role,
        }),
      );

      final data = _decodeBody(response);

      if (response.statusCode == 200) {
        final access = data['access'];
        final refresh = data['refresh'];

        if (access != null && refresh != null) {
          await TokenStorage.saveTokens(
            accessToken: access,
            refreshToken: refresh,
          );
        }

        return data;
      }

      throw Exception(_extractErrorMessage(data));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Inici de sessió amb Google cancel·lat.');
      }

      throw Exception(
        e.description ?? 'No s’ha pogut iniciar sessió amb Google.',
      );
    }
  }

  // Login: guarda access y refresh si todo va bien.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = _decodeBody(response);

    if (response.statusCode == 200) {
      final access = data['access'];
      final refresh = data['refresh'];

      if (access != null && refresh != null) {
        await TokenStorage.saveTokens(
          accessToken: access,
          refreshToken: refresh,
        );
      }

      return data;
    }

    throw Exception(_extractErrorMessage(data));
  }

  // Register: crea usuario nuevo en backend.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String passwordConfirm,
    required String role,
    required String firstName,
    required String lastName,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'password_confirm': passwordConfirm,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    final data = _decodeBody(response);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    }

    throw Exception(_extractErrorMessage(data));
  }

  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.passwordReset),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.trim().toLowerCase()}),
    );

    final data = _decodeBody(response);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(_extractErrorMessage(data));
  }

  Future<Map<String, dynamic>> confirmPasswordReset({
    required String uid,
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.passwordResetConfirm),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': uid,
        'token': token,
        'password': password,
        'password_confirm': passwordConfirm,
      }),
    );

    final data = _decodeBody(response);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(_extractErrorMessage(data));
  }

  // Me: devuelve datos del usuario autenticado.
  Future<Map<String, dynamic>> getMe() async {
    final response = await ApiClient.get(Uri.parse(ApiConfig.me));

    final data = _decodeBody(response);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(_extractErrorMessage(data));
  }

  // Logout: invalida refresh en backend y limpia tokens locales.
  // Sempre neteja la sessió local independentment de la resposta del backend.
  Future<void> logout() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    final accessToken = await TokenStorage.getAccessToken();

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await http
            .post(
              Uri.parse(ApiConfig.logout),
              headers: {
                'Content-Type': 'application/json',
                if (accessToken != null && accessToken.isNotEmpty)
                  'Authorization': 'Bearer $accessToken',
              },
              body: jsonEncode({'refresh': refreshToken}),
            )
            .timeout(const Duration(seconds: 10));
      } catch (_) {
        // Error de xarxa: continua per netejar la sessió local igualment.
      }
    }

    await TokenStorage.clearTokens();
  }

  // Comprueba si hay token guardado.
  Future<bool> hasSession() async {
    return TokenStorage.hasAccessToken();
  }

  // Decodifica JSON sin romper si el body viene vacío.
  Map<String, dynamic> _decodeBody(http.Response response) {
    if (response.body.isEmpty) return {};

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {'data': decoded};
  }

  // Intenta sacar un mensaje útil de error.
  String _extractErrorMessage(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return 'S’ha produït un error inesperat.';
    }

    if (data['detail'] != null) {
      return data['detail'].toString();
    }

    final firstEntry = data.entries.first;

    if (firstEntry.value is List && (firstEntry.value as List).isNotEmpty) {
      return (firstEntry.value as List).first.toString();
    }

    return firstEntry.value.toString();
  }

  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final response = await ApiClient.patch(
      Uri.parse(ApiConfig.me),
      body: jsonEncode({
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'email': email.trim().toLowerCase(),
      }),
    );

    final decoded = response.body.isEmpty ? {} : jsonDecode(response.body);

    if (response.statusCode == 200 && decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    if (decoded is Map<String, dynamic>) {
      if (decoded['detail'] != null) {
        throw Exception(decoded['detail'].toString());
      }

      final firstEntry = decoded.entries.isNotEmpty
          ? decoded.entries.first
          : null;
      if (firstEntry != null) {
        final value = firstEntry.value;
        if (value is List && value.isNotEmpty) {
          throw Exception(value.first.toString());
        }
        throw Exception(value.toString());
      }
    }

    throw Exception('No s’ha pogut actualitzar el perfil.');
  }
}
