/// Configuració centralitzada de la API de BuildRank.
///
/// El frontend no hauria de tenir URLs repartides per pantalles o serveis.
/// Si canvia l'entorn backend, només s'ha d'ajustar aquest fitxer o passar
/// una variable amb `--dart-define`.
class ApiConfig {
  /// URL per defecte en emulador Android quan el backend corre amb Docker + Nginx.
  ///
  /// 10.0.2.2 és una adreça especial que, des de l'emulador Android,
  /// apunta al localhost de l'ordinador host.
  static const String _defaultBaseUrl = 'http://10.0.2.2';

  /// URL base activa.
  ///
  /// Per defecte usa l'emulador. Si vols provar amb mòbil físic:
  ///
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.13
  ///
  /// Important:
  /// - Amb Docker + Nginx no fem servir :8000.
  /// - El frontend parla amb Nginx, no directament amb Gunicorn ni PostgreSQL.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  // =========================
  // Accounts / Auth endpoints
  // =========================
  static const String register = '$baseUrl/api/accounts/register/';
  static const String login = '$baseUrl/api/accounts/login/';
  static const String refresh = '$baseUrl/api/accounts/refresh/';
  static const String logout = '$baseUrl/api/accounts/logout/';
  static const String me = '$baseUrl/api/accounts/me/';
  static const String meEdificis = '$baseUrl/api/accounts/me/edificis/';

  // =========================
  // Buildings endpoints
  // =========================
  static const String carrersAutocomplete =
      '$baseUrl/api/buildings/carrers/autocomplete/';

  static const String localitzacions = '$baseUrl/api/buildings/localitzacions/';

  static const String edificis = '$baseUrl/api/buildings/edificis/';

  /// Es manté aquest alias perquè el formulari actual encara usa `crearEdifici`.
  /// Internament apunta al mateix endpoint REST real del ViewSet d'edificis.
  static const String crearEdifici = edificis;

  static String edificiDetail(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/';

  // =========================
  // Improvements / simulation endpoints
  // =========================
  static const String millores = '$baseUrl/api/buildings/millores/';

  static String simulacionsPreview(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/simulacions/preview/';

  static String simulacions(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/simulacions/';

  static String milloresImplementades(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/millores-implementades/';

  /// Helper comú per construir Uri amb query params.
  static Uri uri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    return Uri.parse(endpoint).replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value?.toString()),
      ),
    );
  }
}
