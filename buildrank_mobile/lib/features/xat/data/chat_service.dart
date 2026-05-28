import 'dart:async';
import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      userName: userName ?? streamUserId,
      token: streamToken,
    );
  }

  /// Future compartida de la connexió en curs. Permet que múltiples crides
  /// concurrents (login + obertura de pantalla de xat) reaprofitin la mateixa
  /// connexió en lloc d'engegar-ne una de nova.
  static Future<void>? _activeConnect;

  /// Garantia idempotent de connexió a GetStream.
  ///
  /// - Si ja estem connectats, retorna immediatament.
  /// - Si hi ha una connexió en curs (per exemple, llançada al login),
  ///   s'uneix a la mateixa future en lloc de duplicar-la.
  /// - Altrament, inicia una nova connexió.
  ///
  /// Les pantalles de xat haurien d'usar aquest mètode (no
  /// `provisionAndReconnect` directament) per evitar dobles handshakes.
  static Future<void> ensureConnected({String? userName}) {
    if (StreamService.isUserConnected) {
      return Future.value();
    }
    final pending = _activeConnect;
    if (pending != null) {
      return pending;
    }
    final future = provisionAndReconnect(userName: userName).whenComplete(() {
      _activeConnect = null;
    });
    _activeConnect = future;
    return future;
  }

  /// Inicia la sessió de xat en segon pla (provision + connect a GetStream +
  /// registre del token FCM). NO bloqueja el caller: la connexió WebSocket
  /// amb GetStream pot trigar 20-30s, però l'usuari ja pot navegar lliurement
  /// i el xat es connectarà quan estigui disponible.
  ///
  /// Els errors es silencien — es reintentarà al pròxim login o reobertura.
  static void startSessionInBackground({
    String? userName,
    bool requestNotificationPermission = false,
  }) {
    unawaited(
      _runSessionInBackground(
        userName: userName,
        requestNotificationPermission: requestNotificationPermission,
      ),
    );
  }

  static Future<void> _runSessionInBackground({
    required String? userName,
    required bool requestNotificationPermission,
  }) async {
    if (requestNotificationPermission) {
      try {
        await FirebaseMessaging.instance.requestPermission().timeout(
          const Duration(seconds: 5),
        );
      } catch (_) {}
    }

    try {
      await ensureConnected(userName: userName);
    } catch (_) {
      return;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 5),
      );
      if (token != null) await StreamService.registerFcmToken(token);
    } catch (_) {}
  }
}
