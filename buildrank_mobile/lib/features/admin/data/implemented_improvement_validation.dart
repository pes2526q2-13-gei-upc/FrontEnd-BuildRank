class ImplementedImprovementValidationItem {
  final int id;
  final int? edificiId;
  final String edificiTitle;
  final String improvementName;
  final String requesterName;
  final String requesterEmail;
  final String status;
  final String? executionDate;
  final double? realCost;
  final String? observations;
  final Map<String, dynamic> raw;

  const ImplementedImprovementValidationItem({
    required this.id,
    required this.edificiId,
    required this.edificiTitle,
    required this.improvementName,
    required this.requesterName,
    required this.requesterEmail,
    required this.status,
    required this.executionDate,
    required this.realCost,
    required this.observations,
    required this.raw,
  });

  bool get canReview {
    final normalized = status.trim().toUpperCase();
    return normalized == 'PENDENT' ||
        normalized == 'PENDING' ||
        normalized == 'EN_REVISIO' ||
        normalized == 'REVIEW';
  }

  factory ImplementedImprovementValidationItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final improvement = _readMap(json['millora'] ?? json['improvement']);
    final building = _readMap(json['edifici'] ?? json['building']);
    final user = _readMap(
      json['usuari'] ??
          json['user'] ??
          json['created_by'] ??
          json['sollicitant'] ??
          json['solicitante'],
    );
    final localitzacio = _readMap(building?['localitzacio']);

    final firstName = _readString(user?['first_name'] ?? user?['nom']);
    final lastName = _readString(user?['last_name'] ?? user?['cognoms']);
    final requesterName = [?firstName, ?lastName].join(' ').trim();

    final street = _readString(
      localitzacio?['carrer'] ?? building?['carrer'] ?? building?['street'],
    );
    final number = _readString(
      localitzacio?['numero'] ?? building?['numero'] ?? building?['number'],
    );
    final postalCode = _readString(
      localitzacio?['codiPostal'] ??
          localitzacio?['codi_postal'] ??
          building?['codiPostal'],
    );

    final addressParts = [?street, ?number];
    final fallbackAddress = addressParts.isEmpty
        ? null
        : '${addressParts.join(', ')}${postalCode == null ? '' : ' ($postalCode)'}';

    return ImplementedImprovementValidationItem(
      id:
          _readInt(
            json['id'] ??
                json['idImplementacio'] ??
                json['id_implementacio'] ??
                json['pk'],
          ) ??
          0,
      edificiId: _readInt(
        building?['idEdifici'] ?? building?['id'] ?? json['edifici'],
      ),
      edificiTitle:
          _readString(
            json['edifici_nom'] ??
                building?['adreca'] ??
                building?['name'] ??
                building?['nom'] ??
                building?['titol'],
          ) ??
          fallbackAddress ??
          'Edifici pendent',
      improvementName:
          _readString(
            json['millora_nom'] ??
                improvement?['nom'] ??
                improvement?['name'] ??
                improvement?['slug'],
          ) ??
          'Millora',
      requesterName: requesterName.isNotEmpty
          ? requesterName
          : _readString(json['requester_name'] ?? json['sollicitant_nom']) ??
                'Usuari',
      requesterEmail:
          _readString(
            json['requester_email'] ??
                json['sollicitant_email'] ??
                user?['email'],
          ) ??
          'Correu no disponible',
      status:
          _readString(
            json['estatValidacio'] ??
                json['estat_validacio'] ??
                json['status'] ??
                json['estat'],
          ) ??
          'PENDENT',
      executionDate: _readString(
        json['dataExecucio'] ??
            json['data_execucio'] ??
            json['execution_date'] ??
            json['date'],
      ),
      realCost: _readDouble(
        json['costReal'] ?? json['cost_real'] ?? json['real_cost'],
      ),
      observations: _readString(
        json['observacionsAdmin'] ??
            json['observacions_admin'] ??
            json['observacions'] ??
            json['notes'],
      ),
      raw: Map<String, dynamic>.from(json),
    );
  }
}

Map<String, dynamic>? _readMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String? _readString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
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

double? _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.replaceAll(',', '.').trim());
  }
  return null;
}
