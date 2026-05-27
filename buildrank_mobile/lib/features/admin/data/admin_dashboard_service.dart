import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/admin/data/admin_dashboard_summary.dart';

class AdminDashboardService {
  const AdminDashboardService();

  Future<AdminDashboardSummary> getSummary() async {
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiConfig.adminDashboardSummary),
        timeout: const Duration(seconds: 15),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw AdminDashboardApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar les mètriques del panell.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      final payload = decoded is Map
          ? decoded['data'] is Map
                ? Map<String, dynamic>.from(decoded['data'] as Map)
                : Map<String, dynamic>.from(decoded)
          : null;

      if (payload == null) {
        throw const AdminDashboardApiException(
          'La resposta de mètriques del panell no té el format esperat.',
        );
      }

      return AdminDashboardSummary.fromJson(payload);
    } on TimeoutException {
      throw const AdminDashboardApiException(
        'La càrrega de mètriques ha trigat massa.',
      );
    } on SocketException {
      throw const AdminDashboardApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const AdminDashboardApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on AdminDashboardApiException {
      rethrow;
    } catch (_) {
      throw const AdminDashboardApiException(
        'S’ha produït un error inesperat carregant les mètriques.',
      );
    }
  }

  dynamic _tryDecodeBody(String body) {
    if (body.isEmpty) return {};
    return jsonDecode(body);
  }

  String _extractErrorMessage(dynamic data, {required String fallback}) {
    if (data == null) return fallback;

    if (data is Map) {
      if (data['detail'] != null) return data['detail'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['message'] != null) return data['message'].toString();
      if (data['missatge'] != null) return data['missatge'].toString();

      if (data.isNotEmpty) {
        final firstValue = data.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }

        return firstValue.toString();
      }
    }

    return data.toString();
  }
}

class AdminDashboardApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AdminDashboardApiException(
    this.message, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;
}
