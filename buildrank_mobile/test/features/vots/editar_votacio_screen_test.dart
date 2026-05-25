import 'package:buildrank_mobile/features/vots/data/votacions_model.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_service.dart';
import 'package:buildrank_mobile/features/vots/presentation/screens/editar_votacio_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('EditarVotacioScreen renderitza formulari amb dades inicials', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      EditarVotacioScreen(
        votacio: _stubVotacio(),
        service: FakeVotacionsService(),
      ),
    );

    expect(find.text('Editar votació'), findsOneWidget);
    expect(find.text('Desar'), findsOneWidget);
    expect(find.text('Millora de façana'), findsOneWidget);
    expect(find.text('Sí'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
  });
}

class FakeVotacionsService extends VotacionsService {
  @override
  Future<VotacioDetallModel> editarVotacio({
    required int id,
    String? titol,
    String? descripcio,
    DateTime? dataLimit,
    bool clearDataLimit = false,
    String? estat,
    List<String>? opcions,
  }) async {
    return _stubVotacio(titol: titol ?? 'Millora de façana');
  }
}

VotacioDetallModel _stubVotacio({String titol = 'Millora de façana'}) {
  return VotacioDetallModel(
    id: 1,
    edifici: 1,
    titol: titol,
    descripcio: 'Descripció de prova',
    estat: 'oberta',
    dataCreacio: DateTime(2026, 1, 1),
    numVotsTotal: 0,
    haVotat: false,
    opcions: const [
      OpcioVotModel(id: 1, text: 'Sí', ordre: 0, numVots: 0),
      OpcioVotModel(id: 2, text: 'No', ordre: 1, numVots: 0),
    ],
  );
}
