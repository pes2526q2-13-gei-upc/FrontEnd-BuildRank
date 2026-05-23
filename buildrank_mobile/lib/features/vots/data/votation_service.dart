import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/vots/data/votation_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class VotationService {
  Future<Map<String, String>> _headers() async {
    final accessToken = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }

  Future<List<VotationModel>> getVotacions(int idEdifici) async {
    try {
      final response = await http
          .get(
            ApiConfig.uri(ApiConfig.votacionsSimulacions(idEdifici)),
            headers: await _headers(),
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _decode(response.body);

      if (response.statusCode != 200) {
        throw VotationApiException(
          _extractError(decoded, 'No s’han pogut carregar les votacions.'),
          statusCode: response.statusCode,
        );
      }

      final items = _extractVotationItems(decoded);

      return items
          .whereType<Map>()
          .map(
            (item) => VotationModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on VotationApiException {
      rethrow;
    } on TimeoutException {
      throw const VotationApiException(
        'La càrrega de votacions ha trigat massa.',
      );
    } on SocketException {
      throw const VotationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } catch (e) {
      throw VotationApiException('Error carregant votacions: $e');
    }
  }

  Future<VotationModel> votar({
    required int idEdifici,
    required int votacioId,
    required String sentit,
  }) async {
    try {
      final response = await http
          .post(
            ApiConfig.uri(
              ApiConfig.votarSimulacio(
                idEdifici: idEdifici,
                votacioId: votacioId,
              ),
            ),
            headers: await _headers(),
            body: jsonEncode({'sentit': sentit}),
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _decode(response.body);

      if (response.statusCode != 200) {
        throw VotationApiException(
          _extractError(decoded, 'No s’ha pogut registrar el vot.'),
          statusCode: response.statusCode,
        );
      }

      if (decoded is! Map) {
        throw const VotationApiException(
          'La resposta del vot no té el format esperat.',
        );
      }

      return VotationModel.fromJson(Map<String, dynamic>.from(decoded));
    } on VotationApiException {
      rethrow;
    } on TimeoutException {
      throw const VotationApiException('La votació ha trigat massa.');
    } on SocketException {
      throw const VotationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    }
  }

  Future<VotationModel> sotmetreSimulacioAVotacio({
    required int idEdifici,
    required int simulacioId,
    String? titol,
    String? descripcio,
    int diesDurada = 14,
  }) async {
    try {
      final response = await http
          .post(
            ApiConfig.uri(
              ApiConfig.sotmetreSimulacioVotacio(
                idEdifici: idEdifici,
                simulacioId: simulacioId,
              ),
            ),
            headers: await _headers(),
            body: jsonEncode({
              if (titol != null && titol.trim().isNotEmpty)
                'titol': titol.trim(),
              if (descripcio != null && descripcio.trim().isNotEmpty)
                'descripcio': descripcio.trim(),
              'diesDurada': diesDurada,
              'quorumPercent': 75,
              'majoriaPercent': 50,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _decode(response.body);

      if (response.statusCode != 201) {
        throw VotationApiException(
          _extractError(decoded, 'No s’ha pogut crear la votació.'),
          statusCode: response.statusCode,
        );
      }

      if (decoded is! Map) {
        throw const VotationApiException(
          'La resposta de creació de votació no té el format esperat.',
        );
      }

      return VotationModel.fromJson(Map<String, dynamic>.from(decoded));
    } on VotationApiException {
      rethrow;
    } on TimeoutException {
      throw const VotationApiException(
        'La creació de votació ha trigat massa.',
      );
    } on SocketException {
      throw const VotationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    }
  }

  Future<void> acreditarImplementacio({
    required int idEdifici,
    required int simulacioId,
    required String dataExecucio,
    required double costReal,
    required List<int> documentBytes,
    required String documentName,
  }) async {
    try {
      final headers = await _headers();
      headers.remove('Content-Type');

      final request = http.MultipartRequest(
        'POST',
        ApiConfig.uri(
          ApiConfig.acreditarSimulacioImplementacio(
            idEdifici: idEdifici,
            simulacioId: simulacioId,
          ),
        ),
      );

      request.headers.addAll(headers);
      request.fields['dataExecucio'] = dataExecucio;
      request.fields['costReal'] = costReal.toString();

      request.files.add(
        http.MultipartFile.fromBytes(
          'documentacioAdjunta',
          documentBytes,
          filename: documentName,
          contentType: _mediaTypeForFile(documentName),
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 20),
      );

      final response = await http.Response.fromStream(streamedResponse);
      final decoded = _decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw VotationApiException(
          _extractError(decoded, 'No s’ha pogut acreditar la implementació.'),
          statusCode: response.statusCode,
        );
      }
    } on VotationApiException {
      rethrow;
    } on TimeoutException {
      throw const VotationApiException(
        'L’acreditació de la implementació ha trigat massa.',
      );
    } catch (_) {
      throw const VotationApiException(
        'No s’ha pogut acreditar la implementació.',
      );
    }
  }

  MediaType _mediaTypeForFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();

    switch (ext) {
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  dynamic _decode(String body) {
    if (body.isEmpty) return {};
    return jsonDecode(body);
  }

  List<dynamic> _extractVotationItems(dynamic decoded) {
    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);

      for (final key in ['results', 'data', 'items', 'votacions', 'value']) {
        final value = map[key];
        if (value is List) {
          return value;
        }
      }

      final looksLikeSingleVotation =
          map.containsKey('id') ||
          map.containsKey('titol') ||
          map.containsKey('simulacio') ||
          map.containsKey('edifici');

      if (looksLikeSingleVotation) {
        return [map];
      }

      return <dynamic>[];
    }

    throw const VotationApiException(
      'La resposta de votacions no té el format esperat.',
    );
  }

  String _extractError(dynamic decoded, String fallback) {
    if (decoded is Map<String, dynamic>) {
      if (decoded['detail'] != null) return decoded['detail'].toString();
      if (decoded.entries.isNotEmpty) {
        final value = decoded.entries.first.value;
        if (value is List && value.isNotEmpty) return value.first.toString();
        return value.toString();
      }
    }
    if (decoded is String && decoded.trim().isNotEmpty) return decoded;
    return fallback;
  }
}

class VotationApiException implements Exception {
  final String message;
  final int? statusCode;

  const VotationApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
