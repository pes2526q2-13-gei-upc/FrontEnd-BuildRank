import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/weather/data/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherCurrentModel> getCurrentWeather({
    String city = 'Barcelona',
  }) async {
    final apiKey = ApiConfig.xemaApiKey;

    if (apiKey.isEmpty) {
      throw const WeatherApiException(
        'No s’ha configurat la clau de l’API meteorològica.',
      );
    }

    final uri = ApiConfig.xemaCurrentWeather(city: city);

    try {
      final response = await http
          .get(
            uri,
            headers: {'accept': 'application/json', 'X-API-Key': apiKey},
          )
          .timeout(const Duration(seconds: 20));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw WeatherApiException(
          'No s’han pogut carregar les dades meteorològiques.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! Map) {
        throw const WeatherApiException(
          'La resposta meteorològica no té el format esperat.',
        );
      }

      return WeatherCurrentModel.fromJson(Map<String, dynamic>.from(decoded));
    } on TimeoutException {
      throw const WeatherApiException(
        'La consulta meteorològica ha trigat massa.',
      );
    } on SocketException {
      throw const WeatherApiException(
        'No s’ha pogut connectar amb el servei meteorològic.',
      );
    } on FormatException {
      throw const WeatherApiException(
        'La resposta del servei meteorològic no té el format esperat.',
      );
    } on WeatherApiException {
      rethrow;
    } catch (_) {
      throw const WeatherApiException(
        'S’ha produït un error inesperat carregant la meteorologia.',
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

class WeatherApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const WeatherApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    if (details == null) return message;
    return '$message Detall: $details';
  }
}
