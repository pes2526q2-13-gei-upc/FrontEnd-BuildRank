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
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.134 --dart-define=XEMA_API_KEY=9a2ce0d3e095178ca40c3d6ffcd4c74f11e3c6b069b9fbde146fd6ca19f1398c
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

  // Admin user management (requires is_superuser)
  static const String adminUsers = '$baseUrl/api/accounts/users/';
  static String adminUser(int id) => '$adminUsers$id/';
  static String adminBlockUser(int id) => '$adminUsers$id/block/';
  static String adminUnblockUser(int id) => '$adminUsers$id/unblock/';
  static String adminSuspendUser(int id) => '$adminUsers$id/suspend/';
  static String adminUnsuspendUser(int id) => '$adminUsers$id/unsuspend/';

  static const String adminDashboardSummary =
      '$baseUrl/api/accounts/admin/dashboard-summary/';

  // Audit logs (requires is_superuser)
  static Uri auditLogs({
    int? userId,
    String? method,
    String? resourceType,
    int? statusCode,
    String? fromDate,
    String? toDate,
    int page = 1,
  }) {
    final params = <String, dynamic>{'page': page};
    if (userId != null) params['user_id'] = userId;
    if (method?.isNotEmpty ?? false) params['method'] = method;
    if (resourceType?.isNotEmpty ?? false) {
      params['resource_type'] = resourceType;
    }
    if (statusCode != null) params['status_code'] = statusCode;
    if (fromDate?.isNotEmpty ?? false) params['from_date'] = fromDate;
    if (toDate?.isNotEmpty ?? false) params['to_date'] = toDate;
    return uri('$baseUrl/api/audit/logs/', queryParameters: params);
  }

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
  // Admin verification endpoints
  // =========================
  static const String verifications = '$baseUrl/api/verification/';
  static const String verificationCreate = '$baseUrl/api/verification/create/';

  static String verificationDetail(int verificationId) =>
      '$verifications$verificationId/';

  static String verificationReview(int verificationId) =>
      '$verifications$verificationId/revisar/';

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

  static String edificiBadges(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/badges/';

  static String edificiBadgesRecalcular(int idEdifici) =>
      '$baseUrl/api/buildings/edificis/$idEdifici/badges/recalcular/';

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

  static const String pendingImplementedImprovements =
      '$baseUrl/api/buildings/millores-implementades/pendents/';

  static String validateImplementedImprovement(int id) =>
      '$baseUrl/api/buildings/millores-implementades/$id/validar/';

  // =========================
  // Ranking / leagues / seasons endpoints
  // =========================
  static const String seasons = '$baseUrl/api/seasons/';
  static const String seasonsCreateAndStart =
      '$baseUrl/api/seasons/crear-i-iniciar/';
  static const String previousSeasons = '$baseUrl/api/seasons/anteriors/';
  static const String leagues = '$baseUrl/api/leagues/';
  static const String participations = '$baseUrl/api/participations/';

  static Uri currentParticipation({required int buildingId}) {
    return uri(
      '${participations}current/',
      queryParameters: {'edifici': buildingId},
    );
  }

  static Uri rankingEvolution({
    required int buildingId,
    String categoria = 'PROGRES',
    int? limit,
  }) {
    return uri(
      '${leagues}evolucio/',
      queryParameters: {
        'edifici': buildingId,
        'categoria': categoria,
        'limit': ?limit,
      },
    );
  }

  static Uri progressRanking({required int seasonId, int window = 3}) {
    return uri(
      '$seasons$seasonId/ranking/progres/',
      queryParameters: {'window': window},
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
  // Community / Votacions endpoints
  // =========================
  static const String votacions = '$baseUrl/api/community/votacions/';

  static Uri votacionsEdifici({required int idEdifici}) =>
      uri(votacions, queryParameters: {'edifici': idEdifici});

  static String votacioDetall(int id) => '$votacions$id/';
  static String votacioVotar(int id) => '${votacioDetall(id)}votar/';
  static String votacioResultats(int id) => '${votacioDetall(id)}resultats/';

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
  // Notifications endpoints
  // =========================
  static const String notifications = '$baseUrl/api/notifications/';
  static const String notificationsNoLlegides = '${notifications}no-llegides/';
  static const String notificationsLlegirTotes =
      '${notifications}llegir-totes/';
  static String notificationLlegir(int id) => '$notifications$id/llegir/';

  // =========================
  // Chat core & Twin Building endpoints
  // =========================
  static const String chatToken = '$baseUrl/api/chat/token/';
  static const String chatProvision = '$baseUrl/api/chat/channels/provision/';
  static const String chatChannels = '$baseUrl/api/chat/channels/';
  static const String chatChannelsProvision =
      '$baseUrl/api/chat/channels/provision/';

  static String twinBuildingAdmins(int idEdifici) =>
      '$baseUrl/api/chat/twin-buildings/$idEdifici/admins/';

  static String twinBuildingChannel(int idEdifici) =>
      '$baseUrl/api/chat/twin-buildings/$idEdifici/channels/';

  // =========================
  // Chat moderation endpoints
  // =========================
  static String moderationFlagMessage(String messageId) =>
      '$baseUrl/api/chat/moderation/messages/$messageId/flag/';
  static String moderationHideMessage(String messageId) =>
      '$baseUrl/api/chat/moderation/messages/$messageId/hide/';
  static String moderationDeleteMessage(String messageId) =>
      '$baseUrl/api/chat/moderation/messages/$messageId/';
  static String moderationRestoreMessage(String messageId) =>
      '$baseUrl/api/chat/moderation/messages/$messageId/restore/';
  static String moderationDismissFlag(String messageId) =>
      '$baseUrl/api/chat/moderation/messages/$messageId/dismiss-flag/';

  static String moderationWarnUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/warn/';
  static String moderationMuteUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/mute/';
  static String moderationUnmuteUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/unmute/';
  static String moderationBanUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/ban/';
  static String moderationUnbanUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/unban/';
  static String moderationGlobalBanUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/global-ban/';
  static String moderationGlobalUnbanUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/global-unban/';
  static String moderationShadowBanUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/shadow-ban/';
  static String moderationShadowUnbanUser(int userId) =>
      '$baseUrl/api/chat/moderation/users/$userId/shadow-unban/';

  // =========================
  // XEMA Weather API
  // =========================
  static const String xemaWeatherBaseUrl =
      'https://third-party-service-92ob.onrender.com';

  static const String xemaApiKey = String.fromEnvironment('XEMA_API_KEY');

  // =========================
  // Google OAuth
  // =========================
  /// Web client ID d'OAuth 2.0 (de Google Cloud Console / Firebase).
  ///
  /// Requerit per `GoogleSignIn.instance.initialize(serverClientId: ...)` en
  /// Android amb `google_sign_in` >=7.0: sense aquest valor, l'`idToken` no
  /// es genera i el plugin natiu pot llançar "Null check operator used on a
  /// null value".
  ///
  /// El backend ha d'usar exactament aquest mateix valor com a
  /// `GOOGLE_OAUTH_CLIENT_ID` per verificar el token (l'audience ha de
  /// coincidir).
  ///
  /// Per defecte agafa el web client del `google-services.json` del repo.
  /// Es pot sobreescriure amb:
  ///   flutter build apk --dart-define=GOOGLE_OAUTH_SERVER_CLIENT_ID=...
  static const String googleOAuthServerClientId = String.fromEnvironment(
    'GOOGLE_OAUTH_SERVER_CLIENT_ID',
    defaultValue:
        '151978577358-rlroa7mvj0n64anlvvip4slngldv87ch.apps.googleusercontent.com',
  );

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

  /// Reconstrueix una URL de media (avatar, etc.) perquè apunti a [baseUrl].
  ///
  /// El backend genera URLs absolutes amb `request.build_absolute_uri()`, que
  /// depèn del header `Host` que veu Django. Si entre el client i el backend
  /// hi ha un NAT/proxy que reescriu o stripeja el `Host` (per exemple,
  /// nattech a la UPC), la URL retornada apunta a un host/port inaccessible
  /// des de fora. Aquest helper extreu el path i el torna a compondre amb el
  /// [baseUrl] que el front ja està utilitzant amb èxit per parlar amb el
  /// backend — així la URL és sempre accessible.
  static String absoluteMediaUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      final parsed = Uri.parse(trimmed);
      final query = parsed.hasQuery ? '?${parsed.query}' : '';
      return '$baseUrl${parsed.path}$query';
    }
    return '$baseUrl$trimmed';
  }
}
