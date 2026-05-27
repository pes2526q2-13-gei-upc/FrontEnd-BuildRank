import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/vots/presentation/screens/crear_votacio_screen.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_service.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_model.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

void main() {
  Widget buildTestable({VotacionsService? service}) {
    return MaterialApp(
      locale: const Locale('ca'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CrearVotacioScreen(
        idEdifici: 1,
        service: service ?? FakeVotacionsService(),
      ),
    );
  }

  group('CrearVotacioScreen', () {
    testWidgets('renderitza el formulari amb camps bàsics', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      expect(find.text('Nova votació'), findsWidgets);
      expect(find.text('Crear'), findsOneWidget);
      expect(find.text('Opcions'), findsOneWidget);
      expect(find.text('Mínim 2 · Màxim 8'), findsOneWidget);
      expect(find.text('Afegir opció'), findsOneWidget);
    });

    testWidgets('comença amb 4 camps de formulari (títol, desc, 2 opcions)', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      expect(find.byType(TextFormField), findsNWidgets(4));
    });

    testWidgets('no mostra botó d\'eliminar opció quan n\'hi ha 2', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });

    testWidgets('afegir opció augmenta el nombre de camps', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      await tester.tap(find.text('Afegir opció'));
      await tester.pump();

      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.byIcon(Icons.remove_circle_outline), findsWidgets);
    });

    testWidgets('no pot afegir més de 8 opcions', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      for (int i = 0; i < 6; i++) {
        await tester.ensureVisible(find.text('Afegir opció'));
        await tester.tap(find.text('Afegir opció'));
        await tester.pump();
      }

      // Amb 8 opcions el botó desapareix
      expect(find.text('Afegir opció'), findsNothing);
    });

    testWidgets('eliminar opció redueix el nombre de camps', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      await tester.tap(find.text('Afegir opció'));
      await tester.pump();

      expect(find.byType(TextFormField), findsNWidgets(5));

      await tester.tap(find.byIcon(Icons.remove_circle_outline).first);
      await tester.pump();

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });

    testWidgets('no pot eliminar per sota de 2 opcions', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      // Amb 2 opcions no hi ha botó d'eliminar
      expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    });

    testWidgets('validació: títol buit mostra error', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      await tester.tap(find.text('Crear'));
      await tester.pump();

      expect(find.text('El títol és obligatori.'), findsOneWidget);
    });

    testWidgets('validació: títol massa curt mostra error', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'ABC');
      await tester.tap(find.text('Crear'));
      await tester.pump();

      expect(
        find.text('El títol ha de tenir almenys 4 caràcters.'),
        findsOneWidget,
      );
    });

    testWidgets('validació: opció buida mostra error', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      // Títol vàlid però opcions buides
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol vàlid per provar',
      );
      await tester.tap(find.text('Crear'));
      await tester.pump();

      expect(find.text('Aquesta opció no pot estar buida.'), findsWidgets);
    });

    testWidgets('opcions duplicades mostren snackbar', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol vàlid per provar',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Opció igual');
      await tester.enterText(find.byType(TextFormField).at(3), 'Opció igual');

      await tester.tap(find.text('Crear'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.text('Hi ha opcions duplicades. Revisa-les.'),
        findsOneWidget,
      );
    });

    testWidgets('creació exitosa tanca la pantalla i crida al servei', (
      tester,
    ) async {
      final fake = FakeVotacionsService();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ca'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CrearVotacioScreen(idEdifici: 1, service: fake),
                  ),
                ),
                child: const Text('Obrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Obrir'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol de la votació',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Sí');
      await tester.enterText(find.byType(TextFormField).at(3), 'No');

      await tester.tap(find.text('Crear'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Nova votació'), findsNothing);
      expect(fake.crearVotacioCalls, 1);
      expect(fake.lastTitol, 'Títol de la votació');
      expect(fake.lastOpcions, ['Sí', 'No']);
    });

    testWidgets('submit amb descripció passa la descripció al servei', (
      tester,
    ) async {
      final fake = FakeVotacionsService();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ca'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CrearVotacioScreen(idEdifici: 1, service: fake),
                  ),
                ),
                child: const Text('Obrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Obrir'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol de la votació',
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Descripció de prova',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Sí');
      await tester.enterText(find.byType(TextFormField).at(3), 'No');

      await tester.tap(find.text('Crear'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(fake.lastDescripcio, 'Descripció de prova');
    });

    testWidgets('descripció buida s\'envia com a null al servei', (
      tester,
    ) async {
      final fake = FakeVotacionsService();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ca'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        CrearVotacioScreen(idEdifici: 1, service: fake),
                  ),
                ),
                child: const Text('Obrir'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Obrir'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol de la votació',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Sí');
      await tester.enterText(find.byType(TextFormField).at(3), 'No');
      // camp descripció buit — no fem enterText

      await tester.tap(find.text('Crear'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(fake.lastDescripcio, isNull);
    });

    testWidgets('error de l\'API mostra snackbar amb el missatge', (
      tester,
    ) async {
      final fake = FakeVotacionsService()
        ..crearVotacioError = const VotacionsApiException(
          'Error intern del servidor',
        );

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol de la votació',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Sí');
      await tester.enterText(find.byType(TextFormField).at(3), 'No');

      await tester.tap(find.text('Crear'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Error intern del servidor'), findsOneWidget);
      expect(
        find.text('Nova votació'),
        findsWidgets,
      ); // pantalla no s'ha tancat
    });

    testWidgets('botó desactivat mentre s\'envia el formulari', (tester) async {
      final fake = FakeVotacionsService()..blockSubmission();

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Títol de la votació',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'Sí');
      await tester.enterText(find.byType(TextFormField).at(3), 'No');

      await tester.tap(find.text('Crear'));
      await tester.pump();

      // Durant l'enviament, el botó superior ha d'estar desactivat
      final textButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Crear'),
      );
      expect(textButton.onPressed, isNull);

      // Deixem completar per evitar futures pendents
      fake.completeSubmission();
      await tester.pump();
    });
  });
}

// ─── Fake ─────────────────────────────────────────────────────────────────────

class FakeVotacionsService extends VotacionsService {
  int crearVotacioCalls = 0;
  String? lastTitol;
  String? lastDescripcio;
  List<String>? lastOpcions;
  VotacionsApiException? crearVotacioError;
  Completer<VotacioDetallModel>? _blocker;

  void blockSubmission() => _blocker = Completer<VotacioDetallModel>();
  void completeSubmission() =>
      _blocker?.complete(_stubVotacioDetall(titol: 'Test'));

  @override
  Future<VotacioDetallModel> crearVotacio({
    required int idEdifici,
    required String titol,
    String? descripcio,
    DateTime? dataLimit,
    required List<String> opcions,
  }) async {
    crearVotacioCalls++;
    lastTitol = titol;
    lastDescripcio = descripcio;
    lastOpcions = opcions;
    if (_blocker != null) return _blocker!.future;
    if (crearVotacioError != null) throw crearVotacioError!;
    return _stubVotacioDetall(titol: titol, opcions: opcions);
  }
}

VotacioDetallModel _stubVotacioDetall({
  int id = 1,
  String titol = 'Títol',
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
