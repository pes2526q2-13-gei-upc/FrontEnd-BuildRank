import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/vots/presentation/screens/votacio_detall_screen.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_service.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_model.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

void main() {
  Widget buildTestable({
    required String userRole,
    FakeVotacionsDetallService? service,
  }) {
    return MaterialApp(
      locale: const Locale('ca'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: VotacioDetallScreen(
        idVotacio: 1,
        service: service ?? FakeVotacionsDetallService(),
        userRole: userRole,
      ),
    );
  }

  group('VotacioDetallScreen', () {
    testWidgets('mostra l\'indicador de càrrega inicialment', (tester) async {
      final fake = FakeVotacionsDetallService();

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      // Sense pump: el Future no s'ha resolt i l'estat inicial és loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('mostra el títol i les opcions de la votació', (tester) async {
      final fake = FakeVotacionsDetallService()
        ..votacioToReturn = _stubVotacio(
          titol: 'Renovem l\'ascensor?',
          opcions: ['Sí', 'No', 'Abstinència'],
        );

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Renovem l\'ascensor?'), findsWidgets);
      expect(find.text('Sí'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
      expect(find.text('Abstinència'), findsOneWidget);
    });

    testWidgets('mostra el badge d\'estat oberta', (tester) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Oberta'), findsOneWidget);
    });

    testWidgets('admin veu el menú contextual (editar/eliminar)', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'admin'));
      await tester.pump();

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('admin_finca veu el menú contextual', (tester) async {
      await tester.pumpWidget(buildTestable(userRole: 'admin_finca'));
      await tester.pump();

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('propietari no veu el menú contextual', (tester) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));
      await tester.pump();

      expect(find.byType(PopupMenuButton<String>), findsNothing);
    });

    testWidgets('propietari pot votar: veu el botó Votar', (tester) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));
      await tester.pump();
      await tester.pump();

      expect(find.widgetWithText(ElevatedButton, 'Votar'), findsOneWidget);
    });

    testWidgets('llogater no pot votar: veu el missatge de permís', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'tenant'));
      await tester.pump();
      await tester.pump();

      expect(
        find.text(
          'Només els propietaris i administradors de finca vinculats a aquest edifici poden emetre vot.',
        ),
        findsOneWidget,
      );
      expect(find.widgetWithText(ElevatedButton, 'Votar'), findsNothing);
    });

    testWidgets('usuari que ja ha votat veu els resultats directament', (
      tester,
    ) async {
      final fake = FakeVotacionsDetallService()
        ..votacioToReturn = _stubVotacio(haVotat: true)
        ..resultatsToReturn = _stubResultats();

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Resultats'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Votar'), findsNothing);
    });

    testWidgets('votació tancada mostra resultats directament', (tester) async {
      final fake = FakeVotacionsDetallService()
        ..votacioToReturn = _stubVotacio(estat: 'tancada')
        ..resultatsToReturn = _stubResultats();

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Resultats'), findsOneWidget);
      expect(find.text('Tancada'), findsOneWidget);
    });

    testWidgets(
      'error de càrrega mostra missatge d\'error i botó de reintentar',
      (tester) async {
        final fake = FakeVotacionsDetallService()
          ..errorToThrow = const VotacionsApiException(
            'No s\'ha pogut carregar la votació.',
          );

        await tester.pumpWidget(
          buildTestable(userRole: 'owner', service: fake),
        );
        await tester.pump();
        await tester.pump();

        expect(
          find.text('No s\'ha pogut carregar la votació.'),
          findsOneWidget,
        );
        expect(find.text('Torna-ho a provar'), findsOneWidget);
      },
    );

    testWidgets('votar sense selecció mostra snackbar d\'advertència', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Votar'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Selecciona una opció per votar.'), findsOneWidget);
    });

    testWidgets('seleccionar opció i votar crida al servei', (tester) async {
      final fake = FakeVotacionsDetallService()
        ..resultatsToReturn = _stubResultats();

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      // Seleccionem la primera opció
      await tester.tap(find.text('Sí'));
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Votar'));
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(fake.votarOpcioIds, [1]); // opcioId 1 correspon a 'Sí'
      expect(find.text('Vot registrat correctament.'), findsOneWidget);
    });

    testWidgets('eliminar votació mostra diàleg de confirmació', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'admin'));
      await tester.pump();
      await tester.pump();

      // Obrim el menú contextual
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar votació'), findsOneWidget);
      expect(find.text('Cancel·lar'), findsOneWidget);
    });

    testWidgets('error durant el vot mostra snackbar d\'error', (tester) async {
      final fake = FakeVotacionsDetallService()
        ..votarError = const VotacionsApiException(
          'No s\'ha pogut registrar el vot.',
        );

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Sí'));
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Votar'));
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('No s\'ha pogut registrar el vot.'), findsOneWidget);
      expect(fake.votarOpcioIds, isNotEmpty);
    });

    testWidgets('confirmar eliminació al diàleg crida el servei', (
      tester,
    ) async {
      final fake = FakeVotacionsDetallService();

      await tester.pumpWidget(buildTestable(userRole: 'admin', service: fake));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Tap "Eliminar" al popup
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      // Confirmem al diàleg (el segon "Eliminar" és el botó del diàleg)
      await tester.tap(find.text('Eliminar'));
      await tester.pump();
      await tester.pump();

      expect(fake.eliminarCalls, [1]);
    });

    testWidgets('resultats mostren els percentatges correctament', (
      tester,
    ) async {
      final fake = FakeVotacionsDetallService()
        ..votacioToReturn = _stubVotacio(haVotat: true)
        ..resultatsToReturn = ResultatsVotacioModel(
          id: 1,
          titol: 'Títol',
          estat: 'oberta',
          numVotsTotal: 10,
          opcions: [
            const OpcioResultatModel(
              id: 1,
              text: 'Sí',
              numVots: 7,
              percentatge: 70.0,
            ),
            const OpcioResultatModel(
              id: 2,
              text: 'No',
              numVots: 3,
              percentatge: 30.0,
            ),
          ],
        );

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('70.0%'), findsOneWidget);
      expect(find.text('30.0%'), findsOneWidget);
    });

    testWidgets('descripció visible si la votació en té', (tester) async {
      final fake = FakeVotacionsDetallService()
        ..votacioToReturn = _stubVotacio(
          descripcio: 'Context detallat de la votació.',
        );

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Context detallat de la votació.'), findsOneWidget);
    });

    testWidgets('retorna a intentar carregar quan es prem reintentar', (
      tester,
    ) async {
      int calls = 0;
      final fake = FakeVotacionsDetallService();
      fake.onGetVotacio = () {
        calls++;
        if (calls == 1) {
          throw const VotacionsApiException('Error temporal');
        }
        return _stubVotacio();
      };

      await tester.pumpWidget(buildTestable(userRole: 'owner', service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Error temporal'), findsOneWidget);

      await tester.tap(find.text('Torna-ho a provar'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Error temporal'), findsNothing);
      expect(find.text('Sí'), findsOneWidget);
      expect(calls, 2);
    });
  });
}

// ─── Fakes ────────────────────────────────────────────────────────────────────

class FakeVotacionsDetallService extends VotacionsService {
  VotacioDetallModel? votacioToReturn;
  ResultatsVotacioModel? resultatsToReturn;
  VotacionsApiException? errorToThrow;
  VotacionsApiException? votarError;
  Duration delay = Duration.zero;
  List<int> votarOpcioIds = [];
  List<int> eliminarCalls = [];
  VotacioDetallModel Function()? onGetVotacio;

  @override
  Future<VotacioDetallModel> getVotacioDetall({required int id}) async {
    if (delay != Duration.zero) await Future.delayed(delay);
    if (onGetVotacio != null) return onGetVotacio!();
    if (errorToThrow != null) throw errorToThrow!;
    return votacioToReturn ?? _stubVotacio();
  }

  @override
  Future<ResultatsVotacioModel> getResultats({required int id}) async {
    if (errorToThrow != null) throw errorToThrow!;
    return resultatsToReturn ?? _stubResultats();
  }

  @override
  Future<void> votar({required int idVotacio, required int opcioId}) async {
    votarOpcioIds.add(opcioId);
    if (votarError != null) throw votarError!;
  }

  @override
  Future<void> eliminarVotacio({required int id}) async {
    eliminarCalls.add(id);
    if (errorToThrow != null) throw errorToThrow!;
  }
}

VotacioDetallModel _stubVotacio({
  int id = 1,
  String titol = 'Títol de la votació',
  String estat = 'oberta',
  bool haVotat = false,
  String? descripcio,
  List<String> opcions = const ['Sí', 'No'],
}) {
  return VotacioDetallModel(
    id: id,
    edifici: 1,
    titol: titol,
    descripcio: descripcio,
    estat: estat,
    dataCreacio: DateTime(2026, 1, 1),
    numVotsTotal: 0,
    haVotat: haVotat,
    opcions: opcions
        .asMap()
        .entries
        .map(
          (e) => OpcioVotModel(
            id: e.key + 1,
            text: e.value,
            ordre: e.key,
            numVots: 0,
          ),
        )
        .toList(),
  );
}

ResultatsVotacioModel _stubResultats({
  int id = 1,
  List<OpcioResultatModel>? opcions,
}) {
  return ResultatsVotacioModel(
    id: id,
    titol: 'Títol de la votació',
    estat: 'oberta',
    numVotsTotal: 5,
    opcions:
        opcions ??
        [
          const OpcioResultatModel(
            id: 1,
            text: 'Sí',
            numVots: 3,
            percentatge: 60.0,
          ),
          const OpcioResultatModel(
            id: 2,
            text: 'No',
            numVots: 2,
            percentatge: 40.0,
          ),
        ],
  );
}
