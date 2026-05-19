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
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.109 --dart-define=XEMA_API_KEY=9a2ce0d3e095178ca40c3d6ffcd4c74f11e3c6b069b9fbde146fd6ca19f1398c
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
  static const String googleOAuth = '$baseUrl/api/accounts/oauth/google/';
  static const String refresh = '$baseUrl/api/accounts/refresh/';
  static const String logout = '$baseUrl/api/accounts/logout/';
  static const String me = '$baseUrl/api/accounts/me/';
  static const String meEdificis = '$baseUrl/api/accounts/me/edificis/';
  static const String passwordReset = '$baseUrl/api/accounts/password-reset/';
  static const String passwordResetConfirm =
      '$baseUrl/api/accounts/password-reset-confirm/';

  // =========================
  // Buildings endpoints
  // =========================
  static const String carrersAutocomplete =
      '$baseUrl/api/buildings/carrers/autocomplete/';

  static const String localitzacions = '$baseUrl/api/buildings/localitzacions/';

  static const String edificis = '$baseUrl/api/buildings/edificis/';
  static const String edificisMapa = '$baseUrl/api/buildings/edificis/mapa/';

  static Uri searchExistingBuildings(String query) {
    return uri('${edificis}cerca/', queryParameters: {'q': query.trim()});
  }

  static const String adminFincaEdificiAlta =
      '$baseUrl/api/buildings/admin-finca/edificis/alta/';

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

  static const String habitatges = '$baseUrl/api/buildings/habitatges/';

  static String habitatgeSolicitarAcces(String referenciaCadastral) =>
      '$habitatges${Uri.encodeComponent(referenciaCadastral)}/solicitar-acces/';

  // Endpoints per administrador de finques

  static const String habitatgesPendents = '${habitatges}pendents/';

  static String habitatgeValidarAcces(String referenciaCadastral) =>
      '$habitatges${Uri.encodeComponent(referenciaCadastral)}/validar-acces/';

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

  /// Legacy: millor no usar-lo a la pantalla de ranking perquè no retorna
  /// el mateix payload que el ranking per temporada i no suporta search.
  static Uri leagueRanking({
    required int leagueId,
    int? groupId,
    int page = 1,
    int pageSize = 10,
    String? search,
  }) {
    final cleanSearch = search?.trim();

    return uri(
      '$leagues$leagueId/ranking/',
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        ...?groupId != null ? {'group': groupId.toString()} : null,
        ...?cleanSearch != null && cleanSearch.isNotEmpty
            ? {'search': cleanSearch}
            : null,
      },
    );
  }

  /// Endpoint principal per a tots els rankings de la pantalla:
  ///
  /// - La meva lliga:
  ///   /api/seasons/{seasonId}/ranking/?league={leagueId}
  ///
  /// - Similars dins la lliga:
  ///   /api/seasons/{seasonId}/ranking/?league={leagueId}&group={groupId}
  ///
  /// - Similars dins la temporada:
  ///   /api/seasons/{seasonId}/ranking/?group={groupId}
  static Uri seasonRanking({
    required int seasonId,
    int? groupId,
    int? leagueId,
    int page = 1,
    int pageSize = 10,
    String? search,
  }) {
    final cleanSearch = search?.trim();

    return uri(
      '$seasons$seasonId/ranking/',
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        ...?groupId != null ? {'group': groupId.toString()} : null,
        ...?leagueId != null ? {'league': leagueId.toString()} : null,
        ...?cleanSearch != null && cleanSearch.isNotEmpty
            ? {'search': cleanSearch}
            : null,
      },
    );
  }

  /// Legacy: millor no usar-lo a la pantalla de ranking.
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

  /// Endpoint principal per calcular la posició/resum de l'edifici segons scope.
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
  // Votacions de simulacions
  // =========================
  static String votacionsSimulacions(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/votacions-simulacions/';

  static String votarSimulacio({
    required int idEdifici,
    required int votacioId,
  }) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/votacions-simulacions/$votacioId/votar/';

  static String sotmetreSimulacioVotacio({
    required int idEdifici,
    required int simulacioId,
  }) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/simulacions/$simulacioId/sotmetre-votacio/';

  static String acreditarSimulacioImplementacio({
    required int idEdifici,
    required int simulacioId,
  }) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/simulacions/$simulacioId/acreditar-implementacio/';

  // =========================
  // Chat / Twin Building endpoints
  // =========================
  static const String chatToken = '$baseUrl/api/chat/token/';
  static const String chatChannels = '$baseUrl/api/chat/channels/';
  static const String chatChannelsProvision =
      '$baseUrl/api/chat/channels/provision/';

  static String twinBuildingAdmins(int idEdifici) =>
      '$baseUrl/api/chat/twin-buildings/$idEdifici/admins/';

  static String twinBuildingChannel(int idEdifici) =>
      '$baseUrl/api/chat/twin-buildings/$idEdifici/channels/';

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
