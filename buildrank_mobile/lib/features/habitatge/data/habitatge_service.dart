import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/habitatge/data/habitatge_form_data.dart';
import 'package:http/http.dart' as http;

class HabitatgeService {
  Future<Map<String, String>> _buildHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Map<String, dynamic>>> getMyHabitatgesForBuilding(
    int idEdifici,
  ) async {
    final uri = Uri.parse(ApiConfig.edificiHabitatges(idEdifici));

    try {
      final response = await http
          .get(uri, headers: await _buildHeaders())
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw HabitatgeApiException(
          'No s’han pogut carregar els habitatges vinculats.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const HabitatgeApiException(
          'La resposta d’habitatges no té el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on TimeoutException {
      throw const HabitatgeApiException(
        'La consulta d’habitatges ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const HabitatgeApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const HabitatgeApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on HabitatgeApiException {
      rethrow;
    } catch (_) {
      throw const HabitatgeApiException(
        'S’ha produït un error inesperat carregant els habitatges.',
      );
    }
  }

  Future<Map<String, dynamic>?> getMyHabitatgeForBuilding(int idEdifici) async {
    final habitatges = await getMyHabitatgesForBuilding(idEdifici);

    if (habitatges.isEmpty) {
      return null;
    }

    final referencia = habitatges.first['referenciaCadastral']?.toString();

    if (referencia == null || referencia.isEmpty) {
      throw const HabitatgeApiException(
        'L’habitatge vinculat no conté cap referència cadastral.',
      );
    }

    return getHabitatgeDetail(
      idEdifici: idEdifici,
      referenciaCadastral: referencia,
    );
  }

  Future<Map<String, dynamic>> getHabitatgeDetail({
    required int idEdifici,
    required String referenciaCadastral,
  }) async {
    final uri = Uri.parse(
      ApiConfig.edificiHabitatgeDetail(
        idEdifici: idEdifici,
        referenciaCadastral: referenciaCadastral,
      ),
    );

    try {
      final response = await http
          .get(uri, headers: await _buildHeaders())
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw HabitatgeApiException(
          'No s’ha pogut carregar el detall de l’habitatge.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! Map) {
        throw const HabitatgeApiException(
          'La resposta del detall d’habitatge no té el format esperat.',
        );
      }

      return Map<String, dynamic>.from(decoded);
    } on TimeoutException {
      throw const HabitatgeApiException(
        'La consulta del detall de l’habitatge ha trigat massa.',
      );
    } on SocketException {
      throw const HabitatgeApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const HabitatgeApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on HabitatgeApiException {
      rethrow;
    } catch (_) {
      throw const HabitatgeApiException(
        'S’ha produït un error inesperat carregant l’habitatge.',
      );
    }
  }

  Future<Map<String, dynamic>> updateMyHabitatge({
    required HabitatgeFormData formData,
  }) async {
    final referencia = formData.referenciaCadastral.trim();

    if (referencia.isEmpty) {
      throw const HabitatgeApiException(
        'No es pot actualitzar un habitatge sense referència cadastral.',
      );
    }

    final payload = {
      'planta': formData.planta,
      'porta': formData.porta,
      'superficie': formData.superficie,
      'anyReforma': formData.anyReforma,
      if (formData.dadesEnergetiques != null)
        'dadesEnergetiques': formData.dadesEnergetiques!.toJson(),
    };

    final uri = Uri.parse(
      ApiConfig.meHabitatgeUpdate(
        idEdifici: formData.idEdifici,
        referenciaCadastral: referencia,
      ),
    );

    try {
      final response = await http
          .patch(uri, headers: await _buildHeaders(), body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw HabitatgeApiException(
          'No s’han pogut actualitzar les dades de l’habitatge.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! Map) {
        throw const HabitatgeApiException(
          'La resposta d’actualització de l’habitatge no té el format esperat.',
        );
      }

      return Map<String, dynamic>.from(decoded);
    } on TimeoutException {
      throw const HabitatgeApiException(
        'L’actualització de l’habitatge ha trigat massa.',
      );
    } on SocketException {
      throw const HabitatgeApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const HabitatgeApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on HabitatgeApiException {
      rethrow;
    } catch (_) {
      throw const HabitatgeApiException(
        'S’ha produït un error inesperat actualitzant l’habitatge.',
      );
    }
  }

  dynamic _tryDecodeBody(String body) {
    if (body.isEmpty) return {};

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }
}

class HabitatgeApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const HabitatgeApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    if (details == null) return message;
    return '$message Detall: $details';
  }
}
