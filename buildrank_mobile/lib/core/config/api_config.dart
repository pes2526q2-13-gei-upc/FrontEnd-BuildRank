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
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.105 --dart-define=XEMA_API_KEY=9a2ce0d3e095178ca40c3d6ffcd4c74f11e3c6b069b9fbde146fd6ca19f1398c
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

  // =========================
  // Habitatges endpoints
  // =========================

  static String edificiHabitatges(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/habitatges/';

  static String edificiHabitatgeDetail({
    required int idEdifici,
    required String referenciaCadastral,
  }) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/habitatges/$referenciaCadastral/';

  static String meHabitatgeUpdate({
    required int idEdifici,
    required String referenciaCadastral,
  }) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/me/habitatge/$referenciaCadastral/';

  static String habitatgeDetail(String referenciaCadastral) =>
      '$baseUrl/api/buildings/habitatges/$referenciaCadastral/';

  static String dadesEnergetiquesDetail(int id) =>
      '$baseUrl/api/buildings/dades_energetiques/$id/';

  static const String searchExistingBuildings =
      '$baseUrl/api/buildings/search/'; //Falta implementar endpoint real al backend, però el frontend ja el té preparat.

  // Assignacions via accounts
  static String assignarResident(String refCadastral) =>
      '$baseUrl/api/accounts/habitatges/$refCadastral/assignar-resident/';

  static String assignarAdminEdifici(int idEdifici) =>
      '$baseUrl/api/accounts/edificis/$idEdifici/assignar-admin/';

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

  // =========================
  // Ranking / leagues / seasons endpoints
  // =========================
  static const String seasons = '$baseUrl/api/seasons/';
  static const String leagues = '$baseUrl/api/leagues/';
  static const String participations = '$baseUrl/api/participations/';
  static Uri currentParticipation({required int buildingId}) {
    return uri(
      '${participations}current/',
      queryParameters: {'edifici': buildingId},
    );
  }

  static Uri leagueRanking({
    required int leagueId,
    int? groupId,
    int page = 1,
    int pageSize = 10,
    String? search,
  }) {
    return uri(
      '$leagues$leagueId/ranking/',
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        ...?groupId != null ? {'group': groupId.toString()} : null,
        ...?search != null && search.trim().isNotEmpty
            ? {'search': search.trim()}
            : null,
      },
    );
  }

  static Uri seasonRanking({
    required int seasonId,
    int? groupId,
    int? leagueId,
    int page = 1,
    int pageSize = 10,
    String? search,
  }) {
    return uri(
      '$seasons$seasonId/ranking/',
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        ...?groupId != null ? {'group': groupId.toString()} : null,
        ...?leagueId != null ? {'league': leagueId.toString()} : null,
        ...?search != null && search.trim().isNotEmpty
            ? {'search': search.trim()}
            : null,
      },
    );
  }

  static Uri buildingPosition({
    required int leagueId,
    required int buildingId,
    int top = 3,
    required bool segment,
  }) {
    return uri(
      '$leagues$leagueId/posicio_edifici/',
      queryParameters: {'edifici': buildingId, 'top': top, 'segment': segment},
    );
  }

  static Uri seasonBuildingPosition({
    required int seasonId,
    required int buildingId,
    int top = 3,
    required bool compareByGroup,
    required bool seasonScope,
  }) {
    return uri(
      '$seasons$seasonId/posicio_edifici/',
      queryParameters: {
        'edifici': buildingId,
        'top': top,
        'scope': seasonScope ? 'temporada' : 'lliga',
        'group': compareByGroup,
      },
    );
  }

  // =========================
  // XEMA Weather API
  // =========================
  static const String xemaWeatherBaseUrl =
      'https://third-party-service-92ob.onrender.com';

  static const String xemaApiKey = String.fromEnvironment('XEMA_API_KEY');

  static Uri xemaCurrentWeather({String city = 'Barcelona'}) {
    return Uri.parse(
      '$xemaWeatherBaseUrl/api/weather/current/',
    ).replace(queryParameters: {'city': city});
  }

  static Uri xemaDailyWeather({required String city, required String date}) {
    return Uri.parse(
      '$xemaWeatherBaseUrl/api/weather/daily/',
    ).replace(queryParameters: {'city': city, 'date': date});
  }

  /// Helper comú per construir Uri amb query params.
  static Uri uri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    return Uri.parse(endpoint).replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value?.toString()),
      ),
    );
  }
}
