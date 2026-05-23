class AdminDashboardSummary {
  final int totalUsers;
  final int activeUsers;
  final int pendingVerifications;
  final int pendingImprovements;
  final int validatedImprovements;
  final int integrityAlerts;
  final int managedBuildings;
  final int totalBuildings;
  final int pendingHousingRequests;
  final int openSeasons;
  final String? generatedAt;
  final Map<String, dynamic> raw;

  const AdminDashboardSummary({
    required this.totalUsers,
    required this.activeUsers,
    required this.pendingVerifications,
    required this.pendingImprovements,
    required this.validatedImprovements,
    required this.integrityAlerts,
    required this.managedBuildings,
    required this.totalBuildings,
    required this.pendingHousingRequests,
    required this.openSeasons,
    required this.generatedAt,
    required this.raw,
  });

  factory AdminDashboardSummary.empty() {
    return const AdminDashboardSummary(
      totalUsers: 0,
      activeUsers: 0,
      pendingVerifications: 0,
      pendingImprovements: 0,
      validatedImprovements: 0,
      integrityAlerts: 0,
      managedBuildings: 0,
      totalBuildings: 0,
      pendingHousingRequests: 0,
      openSeasons: 0,
      generatedAt: null,
      raw: {},
    );
  }

  factory AdminDashboardSummary.fromJson(Map<String, dynamic> json) {
    final activeSeason = _readMap(json['active_season']);

    return AdminDashboardSummary(
      totalUsers: _firstInt(json, const [
        'users_total',
        'total_users',
        'num_usuaris',
        'users',
        'usuarios',
        'totalUsuaris',
        'totalUsers',
      ]),
      activeUsers: _firstInt(json, const [
        'active_users',
        'usuaris_actius',
        'usuarios_activos',
        'activeUsers',
        'users_total',
      ]),
      pendingVerifications: _firstInt(json, const [
        'pending_admin_verifications',
        'pending_verifications',
        'verificacions_pendents',
        'verificaciones_pendientes',
        'pendingVerifications',
      ]),
      pendingImprovements: _firstInt(json, const [
        'pending_improvements',
        'millores_pendents',
        'mejoras_pendientes',
        'pendingImprovements',
      ]),
      validatedImprovements: _firstInt(json, const [
        'validated_improvements',
        'millores_validades',
        'mejoras_validadas',
        'validatedImprovements',
      ]),
      integrityAlerts: _firstInt(json, const [
        'integrity_alerts',
        'alertes_integritat',
        'alertas_integridad',
        'integrityAlerts',
      ]),
      managedBuildings: _firstInt(json, const [
        'buildings_managed',
        'managed_buildings',
        'edificis_gestionats',
        'edificios_gestionados',
        'managedBuildings',
      ]),
      totalBuildings: _firstInt(json, const [
        'buildings_total',
        'total_buildings',
        'edificis_total',
        'edificios_total',
        'buildings',
        'edificis',
        'totalBuildings',
      ]),
      pendingHousingRequests: _firstInt(json, const [
        'pending_housing_requests',
        'habitatges_pendents',
        'sollicituds_habitatge_pendents',
        'pendingHousingRequests',
      ]),
      openSeasons: activeSeason == null
          ? _firstInt(json, const [
              'open_seasons',
              'temporades_obertes',
              'temporadas_abiertas',
              'active_seasons',
              'openSeasons',
            ])
          : 1,
      generatedAt: _readString(
        json['generated_at'] ?? json['generatedAt'] ?? json['updated_at'],
      ),
      raw: Map<String, dynamic>.from(json),
    );
  }

  bool get hasRealData => raw.isNotEmpty;
}

int _firstInt(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _readInt(json[key]);
    if (value != null) return value;
  }
  return 0;
}

int? _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) {
    final normalized = value.replaceAll(',', '').trim();
    return int.tryParse(normalized) ?? double.tryParse(normalized)?.round();
  }
  return null;
}

String? _readString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

Map<String, dynamic>? _readMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}
