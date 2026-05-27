import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/notifications/data/notification_model.dart';

class NotificacionsService {
  Future<List<NotificacioModel>> getNotificacions() async {
    try {
      final response = await ApiClient.get(Uri.parse(ApiConfig.notifications));
      final decoded = _tryDecode(response.body);

      if (response.statusCode != 200) {
        throw NotificacionsApiException(
          _extractError(decoded) ??
              'No s\'han pogut carregar les notificacions.',
          statusCode: response.statusCode,
        );
      }

      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((e) => NotificacioModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on NotificacionsApiException {
      rethrow;
    } on TimeoutException {
      throw const NotificacionsApiException('La connexió ha trigat massa.');
    } on SocketException {
      throw const NotificacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } catch (_) {
      throw const NotificacionsApiException(
        'S\'ha produït un error inesperat.',
      );
    }
  }

  Future<int> getNoLlegides() async {
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiConfig.notificationsNoLlegides),
      );
      final decoded = _tryDecode(response.body);

      if (response.statusCode != 200) return 0;
      if (decoded is! Map) return 0;

      return (decoded['no_llegides'] as int?) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> marcarLlegida(int id) async {
    try {
      final response = await ApiClient.post(
        Uri.parse(ApiConfig.notificationLlegir(id)),
      );

      if (response.statusCode != 204) {
        final decoded = _tryDecode(response.body);
        throw NotificacionsApiException(
          _extractError(decoded) ?? 'No s\'ha pogut marcar com a llegida.',
          statusCode: response.statusCode,
        );
      }
    } on NotificacionsApiException {
      rethrow;
    } catch (_) {
      throw const NotificacionsApiException(
        'S\'ha produït un error inesperat.',
      );
    }
  }

  Future<void> marcarTotesLlegides() async {
    try {
      final response = await ApiClient.post(
        Uri.parse(ApiConfig.notificationsLlegirTotes),
      );

      if (response.statusCode != 204) {
        final decoded = _tryDecode(response.body);
        throw NotificacionsApiException(
          _extractError(decoded) ??
              'No s\'han pogut marcar totes com a llegides.',
          statusCode: response.statusCode,
        );
      }
    } on NotificacionsApiException {
      rethrow;
    } catch (_) {
      throw const NotificacionsApiException(
        'S\'ha produït un error inesperat.',
      );
    }
  }

  dynamic _tryDecode(String body) {
    if (body.isEmpty) return {};
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String? _extractError(dynamic body) {
    if (body is! Map) return null;
    for (final key in ['detail', 'error', 'message']) {
      final val = body[key];
      if (val is String && val.isNotEmpty) return val;
    }
    return null;
  }
}

class NotificacionsApiException implements Exception {
  final String message;
  final int? statusCode;

  const NotificacionsApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
