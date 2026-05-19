import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Re-crea l'usuari a GetStream i l'afegeix als seus canals.
  ///
  /// [userName] és el nom de visualització. Si s'omet, s'usa l'últim conegut
  /// o el propi user_id com a fallback.
  static Future<void> provisionAndReconnect({String? userName}) async {
    final headers = await _headers();

    // 1. Token fresc + sync_user_to_stream (re-crea l'usuari si fou eliminat)
    final tokenResponse = await http.post(
      Uri.parse(ApiConfig.chatToken),
      headers: headers,
    );
    if (tokenResponse.statusCode != 200) {
      final data = tokenResponse.body.isNotEmpty
          ? jsonDecode(tokenResponse.body) as Map<String, dynamic>
          : <String, dynamic>{};
      throw Exception(
        data['detail'] ??
            'Error obtenint token de xat (${tokenResponse.statusCode})',
      );
    }
    final tokenData = jsonDecode(tokenResponse.body) as Map<String, dynamic>;
    final streamUserId = tokenData['user_id'] as String;
    final streamToken = tokenData['token'] as String;

    // 2. Provision: afegeix l'usuari a tots els seus canals
    // Errors no bloquegen la connexió (canals poden ja existir)
    await http.post(Uri.parse(ApiConfig.chatProvision), headers: headers);

    // 3. Connecta a GetStream amb el token nou
    await StreamService.connectUser(
      userId: streamUserId,
      userName: userName ?? StreamService.lastUserName ?? streamUserId,
      token: streamToken,
    );
  }
}
