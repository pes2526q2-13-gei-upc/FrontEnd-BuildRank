class SavedSimulationModel {
  final int id;
  final String descripcio;
  final String proposalTitle;
  final double reduccioConsumPrevista;
  final double reduccioEmissionsPrevista;
  final double costEstimat;
  final double estalviAnual;
  final String dataSimulacio;
  final String versioMotor;
  final String estatAplicacio;

  const SavedSimulationModel({
    required this.id,
    required this.descripcio,
    required this.proposalTitle,
    required this.reduccioConsumPrevista,
    required this.reduccioEmissionsPrevista,
    required this.costEstimat,
    required this.estalviAnual,
    required this.dataSimulacio,
    required this.versioMotor,
    required this.estatAplicacio,
  });

  factory SavedSimulationModel.fromJson(Map<String, dynamic> json) {
    final description = json['descripcio']?.toString() ?? 'Simulació guardada';

    return SavedSimulationModel(
      id: _readInt(json['id'] ?? json['idSimulacio'] ?? json['simulacio_id']),
      descripcio: description,
      proposalTitle: _proposalTitle(json, description),
      reduccioConsumPrevista: _readDouble(json['reduccioConsumPrevista']),
      reduccioEmissionsPrevista: _readDouble(json['reduccioEmissionsPrevista']),
      costEstimat: _readDouble(json['costEstimat']),
      estalviAnual: _readDouble(json['estalviAnual']),
      dataSimulacio: json['dataSimulacio']?.toString() ?? '-',
      versioMotor: json['versioMotor']?.toString() ?? '-',
      estatAplicacio:
          (json['estatAplicacio'] ?? json['estat_aplicacio'] ?? 'esborrany')
              .toString(),
    );
  }

  String get votationTitle => 'Votació: $proposalTitle';

  String get votationDescription {
    if (proposalTitle == descripcio) {
      return descripcio;
    }
    return '$proposalTitle · $descripcio';
  }

  bool get canBeSubmittedToVote {
    final value = _normalizeStatus(estatAplicacio);
    return value == 'esborrany' || value == 'rebutjada';
  }

  bool get isInVoting => _normalizeStatus(estatAplicacio) == 'en_votacio';

  bool get isApproved => _normalizeStatus(estatAplicacio) == 'aprovada';

  bool get isImplemented => _normalizeStatus(estatAplicacio) == 'implementada';

  String get estatAplicacioLabel {
    final value = _normalizeStatus(estatAplicacio);

    switch (value) {
      case 'esborrany':
        return 'Esborrany';
      case 'en_votacio':
        return 'En votació';
      case 'aprovada':
        return 'Aprovada';
      case 'rebutjada':
        return 'Rebutjada';
      case 'implementada':
        return 'Implementada';
      default:
        return estatAplicacio.isEmpty ? 'Esborrany' : estatAplicacio;
    }
  }

  static String _proposalTitle(Map<String, dynamic> json, String fallback) {
    final directItems = _extractItemNames(json['items']);
    if (directItems.isNotEmpty) {
      return _formatItemNames(directItems);
    }

    final result = json['resultat'];
    if (result is Map) {
      final resultItems = _extractItemNames(result['items']);
      if (resultItems.isNotEmpty) {
        return _formatItemNames(resultItems);
      }
    }

    return fallback;
  }

  static List<String> _extractItemNames(dynamic rawItems) {
    if (rawItems is! List) {
      return [];
    }

    final names = <String>[];

    for (final item in rawItems) {
      if (item is! Map) continue;

      final millora = item['millora'];
      final fromMillora = millora is Map ? millora['nom']?.toString() : null;
      final fromItem = item['nom']?.toString();

      final name = (fromMillora ?? fromItem ?? '').trim();
      if (name.isNotEmpty && !names.contains(name)) {
        names.add(name);
      }
    }

    return names;
  }

  static String _formatItemNames(List<String> names) {
    if (names.isEmpty) {
      return 'Simulació de millora';
    }
    if (names.length == 1) {
      return names.first;
    }
    return '${names.first} + ${names.length - 1} millores';
  }

  static String _normalizeStatus(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('à', 'a')
        .replaceAll('è', 'e')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _readDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.')) ?? 0;
    }
    return 0;
  }
}
