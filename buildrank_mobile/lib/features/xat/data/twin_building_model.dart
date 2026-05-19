class TwinBuildingAdminCandidate {
  final int edificiId;
  final String adreca;
  final String barri;
  final String codiPostal;
  final String zonaClimatica;
  final String tipologia;
  final double superficieTotal;
  final double puntuacioBase;
  final int? grupComparable;
  final TwinBuildingAdmin admin;

  const TwinBuildingAdminCandidate({
    required this.edificiId,
    required this.adreca,
    required this.barri,
    required this.codiPostal,
    required this.zonaClimatica,
    required this.tipologia,
    required this.superficieTotal,
    required this.puntuacioBase,
    required this.grupComparable,
    required this.admin,
  });

  factory TwinBuildingAdminCandidate.fromJson(Map<String, dynamic> json) {
    final adminRaw = json['admin'];
    return TwinBuildingAdminCandidate(
      edificiId: _readInt(json['edifici_id']),
      adreca: json['adreca']?.toString() ?? 'Edifici',
      barri: json['barri']?.toString() ?? '',
      codiPostal: json['codiPostal']?.toString() ?? '',
      zonaClimatica: json['zonaClimatica']?.toString() ?? '',
      tipologia: json['tipologia']?.toString() ?? '',
      superficieTotal: _readDouble(json['superficieTotal']),
      puntuacioBase: _readDouble(json['puntuacioBase']),
      grupComparable: json['grupComparable'] == null
          ? null
          : _readInt(json['grupComparable']),
      admin: adminRaw is Map
          ? TwinBuildingAdmin.fromJson(Map<String, dynamic>.from(adminRaw))
          : const TwinBuildingAdmin(
              id: 0,
              streamUserId: '',
              email: '',
              name: 'Administrador',
            ),
    );
  }
}

class TwinBuildingAdmin {
  final int id;
  final String streamUserId;
  final String email;
  final String name;

  const TwinBuildingAdmin({
    required this.id,
    required this.streamUserId,
    required this.email,
    required this.name,
  });

  factory TwinBuildingAdmin.fromJson(Map<String, dynamic> json) {
    return TwinBuildingAdmin(
      id: _readInt(json['id']),
      streamUserId: json['stream_user_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name:
          json['name']?.toString() ??
          json['email']?.toString() ??
          'Administrador',
    );
  }
}

class TwinBuildingChannelResult {
  final String id;
  final String type;
  final String kind;
  final String name;
  final String streamChannelId;
  final TwinBuildingAdminCandidate? sourceEdifici;
  final TwinBuildingAdminCandidate? targetEdifici;

  const TwinBuildingChannelResult({
    required this.id,
    required this.type,
    required this.kind,
    required this.name,
    required this.streamChannelId,
    required this.sourceEdifici,
    required this.targetEdifici,
  });

  factory TwinBuildingChannelResult.fromJson(Map<String, dynamic> json) {
    final source = json['source_edifici'];
    final target = json['target_edifici'];

    return TwinBuildingChannelResult(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'messaging',
      kind: json['kind']?.toString() ?? 'twin_building_direct',
      name: json['name']?.toString() ?? 'Twin Building',
      streamChannelId:
          json['stream_channel_id']?.toString() ?? json['id']?.toString() ?? '',
      sourceEdifici: source is Map
          ? TwinBuildingAdminCandidate.fromJson(
              Map<String, dynamic>.from(source),
            )
          : null,
      targetEdifici: target is Map
          ? TwinBuildingAdminCandidate.fromJson(
              Map<String, dynamic>.from(target),
            )
          : null,
    );
  }
}

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _readDouble(dynamic value) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
