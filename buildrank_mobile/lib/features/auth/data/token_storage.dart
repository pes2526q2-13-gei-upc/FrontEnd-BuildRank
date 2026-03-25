import 'package:shared_preferences/shared_preferences.dart';

/// Clase utilitaria para gestionar el almacenamiento local de tokens JWT.
///
/// Aquí guardamos
/// - access token
/// - refresh token

class TokenStorage {
  /// Clave con la que guardaremos el access token en almacenamiento local.
  static const String accessTokenKey = 'access_token';

  /// Clave con la que guardaremos el refresh token en almacenamiento local.
  static const String refreshTokenKey = 'refresh_token';

  /// Guarda ambos tokens en el dispositivo.
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(accessTokenKey, accessToken);
    await prefs.setString(refreshTokenKey, refreshToken);
  }

  /// Devuelve el access token guardado, o null si no existe.
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  /// Devuelve el refresh token guardado, o null si no existe.

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  /// Borra los tokens guardados localmente.
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
  }

  /// Devuelve true si parece que hay sesión guardada.
  static Future<bool> hasAccessToken() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}
