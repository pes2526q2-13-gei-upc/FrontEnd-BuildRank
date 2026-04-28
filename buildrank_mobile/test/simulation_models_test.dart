import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/simulation/data/improvement_model.dart';
import 'package:buildrank_mobile/features/simulation/data/simulation_result_model.dart';

void main() {
  group('ImprovementModel', () {
    test('parseja correctament una millora del catàleg', () {
      final improvement = ImprovementModel.fromJson({
        'idMillora': 1,
        'slug': 'aillament-sate',
        'nom': 'Aïllament exterior SATE',
        'descripcio': 'Millora de façana',
        'categoria': 'envolupant',
        'unitatBase': 'm2',
        'costEstimatBase': 95.5,
        'estalviEnergeticEstimat': 12,
        'impactePunts': 8,
        'nivellConfianca': 'Mig',
        'activa': true,
        'requereixAcordComunitat': true,
        'requereixLlicenciaMunicipal': false,
        'requereixTecnicCompetent': true,
      });

      expect(improvement.idMillora, 1);
      expect(improvement.nom, 'Aïllament exterior SATE');
      expect(improvement.categoriaLabel, isNotEmpty);
      expect(improvement.impactePunts, 8);
      expect(improvement.activa, true);
    });

    test('tolera camps opcionals absents sense trencar', () {
      final improvement = ImprovementModel.fromJson({
        'idMillora': '2',
        'nom': 'Millora parcial',
      });

      expect(improvement.idMillora, 2);
      expect(improvement.nom, 'Millora parcial');
      expect(improvement.activa, true);
    });
  });

  group('SimulationResultModel', () {
    test('parseja resultat de simulació preview', () {
      final result = SimulationResultModel.fromJson({
        'versioMotor': '1.0',
        'edificiId': 1,
        'abans': {
          'consumFinalKwhAny': 10000,
          'emissionsKgCO2Any': 2500,
          'costAnualEnergia': 1800,
          'score': 42,
          'origenDades': 'estimacio',
        },
        'despres': {
          'consumFinalKwhAny': 8500,
          'emissionsKgCO2Any': 2100,
          'costAnualEnergia': 1500,
          'score': 55,
          'origenDades': 'simulacio',
        },
        'delta': {
          'reduccioConsumKwhAny': 1500,
          'reduccioConsumPercent': 15,
          'reduccioEmissionsKgCO2Any': 400,
          'reduccioEmissionsPercent': 16,
          'estalviAnualEstimatiu': 300,
          'costTotalEstimat': 5000,
          'incrementScore': 13,
        },
        'items': [
          {
            'milloraId': 1,
            'slug': 'aillament-sate',
            'nom': 'Aïllament exterior SATE',
            'costEstimat': 5000,
            'reduccioConsumKwhAny': 1500,
            'reduccioEmissionsKgCO2Any': 400,
            'impactePunts': 13,
            'coberturaPercent': 100,
            'quantitatAplicada': 1,
          },
        ],
      });

      expect(result.edificiId, 1);
      expect(result.abans.score, 42);
      expect(result.despres.score, 55);
      expect(result.delta.incrementScore, 13);
      expect(result.items, hasLength(1));
      expect(result.items.first.nom, 'Aïllament exterior SATE');
    });
  });
}
