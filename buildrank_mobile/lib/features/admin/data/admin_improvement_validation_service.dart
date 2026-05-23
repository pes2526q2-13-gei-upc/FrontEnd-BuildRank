import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/admin/data/implemented_improvement_validation.dart';

class AdminImprovementValidationService {
  const AdminImprovementValidationService();

  Future<List<ImplementedImprovementValidationItem>>
  listPendingImprovements() async {
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiConfig.pendingImplementedImprovements),
        timeout: const Duration(seconds: 20),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw AdminImprovementValidationApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar les millores pendents.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      final rawList = decoded is List
          ? decoded
          : decoded is Map
          ? decoded['results'] ??
                decoded['data'] ??
                decoded['millores'] ??
                decoded['pending_improvements']
          : null;

      if (rawList is! List) {
        throw const AdminImprovementValidationApiException(
          'La resposta de millores pendents no té el format esperat.',
        );
      }

      return rawList
          .whereType<Map>()
          .map(
            (item) => ImplementedImprovementValidationItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } on TimeoutException {
      throw const AdminImprovementValidationApiException(
        'La càrrega de millores pendents ha trigat massa.',
      );
    } on SocketException {
      throw const AdminImprovementValidationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const AdminImprovementValidationApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on AdminImprovementValidationApiException {
      rethrow;
    } catch (_) {
      throw const AdminImprovementValidationApiException(
        'S’ha produït un error inesperat carregant millores pendents.',
      );
    }
  }

  Future<void> reviewImprovement({
    required int improvementId,
    required bool approve,
    String? reason,
  }) async {
    final observations = reason?.trim();

    final payload = {
      'accio': approve ? 'validar' : 'rebutjar',
      'estatValidacio': approve ? 'Validada' : 'Rebutjada',
      'estat_validacio': approve ? 'Validada' : 'Rebutjada',
      if (observations != null && observations.isNotEmpty)
        'observacionsAdmin': observations,
      if (observations != null && observations.isNotEmpty)
        'observacions_admin': observations,
      if (observations != null && observations.isNotEmpty)
        'motiu': observations,
    };

    try {
      final response = await ApiClient.post(
        Uri.parse(ApiConfig.validateImplementedImprovement(improvementId)),
        body: jsonEncode(payload),
        timeout: const Duration(seconds: 20),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AdminImprovementValidationApiException(
          _extractErrorMessage(
            decoded,
            fallback: approve
                ? 'No s’ha pogut validar la millora.'
                : 'No s’ha pogut rebutjar la millora.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }
    } on TimeoutException {
      throw const AdminImprovementValidationApiException(
        'La revisió de la millora ha trigat massa.',
      );
    } on SocketException {
      throw const AdminImprovementValidationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on AdminImprovementValidationApiException {
      rethrow;
    } catch (_) {
      throw const AdminImprovementValidationApiException(
        'S’ha produït un error inesperat revisant la millora.',
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

class AdminImprovementValidationApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AdminImprovementValidationApiException(
    this.message, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;
}
