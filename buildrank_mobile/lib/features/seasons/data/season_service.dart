import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/seasons/data/season_models.dart';

class SeasonService {
  const SeasonService();

  Future<List<Season>> getSeasons() async {
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiConfig.seasons),
        timeout: const Duration(seconds: 15),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw SeasonApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar les temporades.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      return _extractList(decoded).map(Season.fromJson).toList();
    } on TimeoutException {
      throw const SeasonApiException(
        'La càrrega de temporades ha trigat massa.',
      );
    } on SocketException {
      throw const SeasonApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const SeasonApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on SeasonApiException {
      rethrow;
    } catch (_) {
      throw const SeasonApiException(
        'S’ha produït un error inesperat carregant temporades.',
      );
    }
  }

  Future<List<Season>> getPreviousSeasons() => getSeasons();

  Future<SeasonActivationResult> createAndStartSeason({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await ApiClient.post(
        Uri.parse(ApiConfig.seasonsCreateAndStart),
        body: jsonEncode({
          'nom': name,
          'dataInici': _formatDateForApi(startDate),
          'dataFi': _formatDateForApi(endDate),
        }),
        timeout: const Duration(seconds: 45),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw SeasonApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’ha pogut crear i iniciar la temporada.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is Map<String, dynamic>) {
        return SeasonActivationResult.fromJson(decoded);
      }

      if (decoded is Map) {
        return SeasonActivationResult.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }

      return SeasonActivationResult.fromJson({'data': decoded});
    } on TimeoutException {
      throw const SeasonApiException(
        'La creació de temporada ha trigat massa.',
      );
    } on SocketException {
      throw const SeasonApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const SeasonApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on SeasonApiException {
      rethrow;
    } catch (_) {
      throw const SeasonApiException(
        'S’ha produït un error inesperat creant la temporada.',
      );
    }
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  dynamic _tryDecodeBody(String body) {
    if (body.isEmpty) return {};

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  List<Map<String, dynamic>> _extractList(dynamic decoded) {
    final rawList = decoded is List
        ? decoded
        : decoded is Map
        ? decoded['results'] ?? decoded['data'] ?? decoded['temporades']
        : null;

    if (rawList is! List) {
      throw const SeasonApiException(
        'La resposta de temporades no té el format esperat.',
      );
    }

    return rawList
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
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

class SeasonApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const SeasonApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}
