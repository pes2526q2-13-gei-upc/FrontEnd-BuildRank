import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/features/simulation/data/saved_simulation_model.dart';
import 'package:buildrank_mobile/features/simulation/data/implemented_improvement_model.dart';
import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/simulation/data/improvement_model.dart';
import 'package:buildrank_mobile/features/simulation/data/simulation_result_model.dart';

class SimulationService {
  Future<List<ImprovementModel>> getImprovements() async {
    try {
      final response = await ApiClient.get(ApiConfig.uri(ApiConfig.millores));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw SimulationApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’ha pogut carregar el catàleg de millores.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const SimulationApiException(
          'El catàleg de millores no té el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) =>
                ImprovementModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on SimulationApiException {
      rethrow;
    } on TimeoutException {
      throw const SimulationApiException(
        'La càrrega de millores ha trigat massa.',
      );
    } on SocketException {
      throw const SimulationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const SimulationApiException(
        'La resposta del servidor no té format JSON vàlid.',
      );
    } catch (_) {
      throw const SimulationApiException(
        'S’ha produït un error inesperat carregant les millores.',
      );
    }
  }

  Future<SimulationResultModel> previewSimulation({
    required int idEdifici,
    required String descripcio,
    required List<Map<String, dynamic>> millores,
  }) async {
    return _sendSimulation(
      endpoint: ApiConfig.simulacionsPreview(idEdifici),
      descripcio: descripcio,
      millores: millores,
      expectedStatus: 200,
      fallbackError: 'No s’ha pogut calcular la simulació.',
    );
  }

  Future<SimulationResultModel> saveSimulation({
    required int idEdifici,
    required String descripcio,
    required List<Map<String, dynamic>> millores,
  }) async {
    return _sendSimulation(
      endpoint: ApiConfig.simulacions(idEdifici),
      descripcio: descripcio,
      millores: millores,
      expectedStatus: 201,
      fallbackError: 'No s’ha pogut guardar la simulació.',
    );
  }

  Future<SimulationResultModel> _sendSimulation({
    required String endpoint,
    required String descripcio,
    required List<Map<String, dynamic>> millores,
    required int expectedStatus,
    required String fallbackError,
  }) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.uri(endpoint),
        body: jsonEncode({'descripcio': descripcio, 'millores': millores}),
        timeout: const Duration(seconds: 15),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != expectedStatus) {
        throw SimulationApiException(
          _extractErrorMessage(decoded, fallback: fallbackError),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! Map) {
        throw const SimulationApiException(
          'La resposta de simulació no té el format esperat.',
        );
      }

      final map = Map<String, dynamic>.from(decoded);

      // El POST de guardar pot retornar l’objecte SimulacioMillora, que conté
      // el resultat complet dins el camp "resultat".
      final resultPayload = map['resultat'] is Map
          ? Map<String, dynamic>.from(map['resultat'])
          : map;

      return SimulationResultModel.fromJson(resultPayload);
    } on SimulationApiException {
      rethrow;
    } on TimeoutException {
      throw const SimulationApiException(
        'La simulació ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const SimulationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const SimulationApiException(
        'La resposta del servidor no té format JSON vàlid.',
      );
    } catch (_) {
      throw const SimulationApiException(
        'S’ha produït un error inesperat processant la simulació.',
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

  String _extractErrorMessage(dynamic data, {required String fallback}) {
    if (data == null) return fallback;

    if (data is Map<String, dynamic>) {
      if (data.isEmpty) return fallback;

      if (data['detail'] != null) {
        return data['detail'].toString();
      }

      final firstEntry = data.entries.first;

      if (firstEntry.value is List && (firstEntry.value as List).isNotEmpty) {
        return (firstEntry.value as List).first.toString();
      }

      return firstEntry.value.toString();
    }

    return data.toString();
  }

  Future<List<SavedSimulationModel>> getSavedSimulations(int idEdifici) async {
    try {
      final response = await ApiClient.get(
        ApiConfig.uri(ApiConfig.simulacions(idEdifici)),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw SimulationApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar les simulacions guardades.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const SimulationApiException(
          'Les simulacions guardades no tenen el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) =>
                SavedSimulationModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on SimulationApiException {
      rethrow;
    } catch (_) {
      throw const SimulationApiException(
        'S’ha produït un error carregant les simulacions guardades.',
      );
    }
  }

  Future<List<ImplementedImprovementModel>> getImplementedImprovements(
    int idEdifici,
  ) async {
    try {
      final response = await ApiClient.get(
        ApiConfig.uri(ApiConfig.milloresImplementades(idEdifici)),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw SimulationApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar les millores aplicades.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const SimulationApiException(
          'Les millores aplicades no tenen el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => ImplementedImprovementModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } on SimulationApiException {
      rethrow;
    } catch (_) {
      throw const SimulationApiException(
        'S’ha produït un error carregant les millores aplicades.',
      );
    }
  }
}

class SimulationApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const SimulationApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}
