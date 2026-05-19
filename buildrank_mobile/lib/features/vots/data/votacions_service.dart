import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_model.dart';

class VotacionsService {
  Future<List<VotacioResumModel>> getVotacions({required int idEdifici}) async {
    try {
      final response = await ApiClient.get(
        ApiConfig.votacionsEdifici(idEdifici: idEdifici),
      );
      final body = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'han pogut carregar les votacions.',
          statusCode: response.statusCode,
        );
      }

      final list = body is List ? body : (body is Map ? body['results'] : null);
      if (list is! List) return [];

      return list
          .whereType<Map>()
          .map((e) => VotacioResumModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
    }
  }

  Future<VotacioDetallModel> getVotacioDetall({required int id}) async {
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiConfig.votacioDetall(id)),
      );
      final body = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'ha pogut carregar la votació.',
          statusCode: response.statusCode,
        );
      }

      if (body is! Map) {
        throw const VotacionsApiException(
          'La resposta del servidor no té el format esperat.',
        );
      }

      return VotacioDetallModel.fromJson(Map<String, dynamic>.from(body));
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
    }
  }

  Future<VotacioDetallModel> crearVotacio({
    required int idEdifici,
    required String titol,
    String? descripcio,
    DateTime? dataLimit,
    required List<String> opcions,
  }) async {
    try {
      final bodyMap = <String, dynamic>{
        'edifici': idEdifici,
        'titol': titol,
        'opcions': opcions,
        if (descripcio != null && descripcio.isNotEmpty)
          'descripcio': descripcio,
        if (dataLimit != null) 'dataLimit': dataLimit.toUtc().toIso8601String(),
      };

      final response = await ApiClient.post(
        Uri.parse(ApiConfig.votacions),
        body: jsonEncode(bodyMap),
      );
      final body = _tryDecodeBody(response.body);

      if (response.statusCode != 201) {
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'ha pogut crear la votació.',
          statusCode: response.statusCode,
        );
      }

      if (body is! Map) {
        throw const VotacionsApiException(
          'La resposta del servidor no té el format esperat.',
        );
      }

      return VotacioDetallModel.fromJson(Map<String, dynamic>.from(body));
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
    }
  }

  Future<void> votar({required int idVotacio, required int opcioId}) async {
    try {
      final response = await ApiClient.post(
        Uri.parse(ApiConfig.votacioVotar(idVotacio)),
        body: jsonEncode({'opcio_id': opcioId}),
      );
      final body = _tryDecodeBody(response.body);

      if (response.statusCode != 201) {
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'ha pogut registrar el vot.',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
    }
  }

  Future<VotacioDetallModel> editarVotacio({
    required int id,
    String? titol,
    String? descripcio,
    DateTime? dataLimit,
    bool clearDataLimit = false,
    String? estat,
    List<String>? opcions,
  }) async {
    try {
      final bodyMap = <String, dynamic>{
        'titol': ?titol,
        'descripcio': ?descripcio,
        if (clearDataLimit) 'dataLimit': null,
        if (!clearDataLimit && dataLimit != null)
          'dataLimit': dataLimit.toUtc().toIso8601String(),
        'estat': ?estat,
        'opcions': ?opcions,
      };

      final response = await ApiClient.patch(
        Uri.parse(ApiConfig.votacioDetall(id)),
        body: jsonEncode(bodyMap),
      );
      final body = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'ha pogut editar la votació.',
          statusCode: response.statusCode,
        );
      }

      if (body is! Map) {
        throw const VotacionsApiException(
          'La resposta del servidor no té el format esperat.',
        );
      }

      return VotacioDetallModel.fromJson(Map<String, dynamic>.from(body));
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
    }
  }

  Future<void> eliminarVotacio({required int id}) async {
    try {
      final response = await ApiClient.delete(
        Uri.parse(ApiConfig.votacioDetall(id)),
      );

      if (response.statusCode != 204) {
        final body = _tryDecodeBody(response.body);
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'ha pogut eliminar la votació.',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
    }
  }

  Future<ResultatsVotacioModel> getResultats({required int id}) async {
    try {
      final response = await ApiClient.get(
        Uri.parse(ApiConfig.votacioResultats(id)),
      );
      final body = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw VotacionsApiException(
          _extractError(body) ?? 'No s\'han pogut carregar els resultats.',
          statusCode: response.statusCode,
        );
      }

      if (body is! Map) {
        throw const VotacionsApiException(
          'La resposta del servidor no té el format esperat.',
        );
      }

      return ResultatsVotacioModel.fromJson(Map<String, dynamic>.from(body));
    } on TimeoutException {
      throw const VotacionsApiException(
        'La connexió ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const VotacionsApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on VotacionsApiException {
      rethrow;
    } catch (_) {
      throw const VotacionsApiException('S\'ha produït un error inesperat.');
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

  String? _extractError(dynamic body) {
    if (body is! Map) return null;
    for (final key in ['detail', 'error', 'message', 'non_field_errors']) {
      final val = body[key];
      if (val is String && val.isNotEmpty) return val;
      if (val is List && val.isNotEmpty) return val.first.toString();
    }
    return null;
  }
}

class VotacionsApiException implements Exception {
  final String message;
  final int? statusCode;

  const VotacionsApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
