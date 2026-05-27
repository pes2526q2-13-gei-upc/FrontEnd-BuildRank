import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:buildrank_mobile/features/notifications/data/notifications_service.dart';
import 'package:buildrank_mobile/features/notifications/data/notification_model.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

void main() {
  Widget buildTestable({
    String userRole = 'owner',
    FakeNotificacionsService? service,
    VoidCallback? onBadgeUpdate,
  }) {
    return MaterialApp(
      locale: const Locale('ca'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NotificationsScreen(
        userRole: userRole,
        onBadgeUpdate: onBadgeUpdate,
        notificacionsService: service ?? FakeNotificacionsService(),
      ),
    );
  }

  group('NotificationsScreen', () {
    testWidgets('mostra l\'indicador de càrrega inicialment', (tester) async {
      final fake = FakeNotificacionsService();

      await tester.pumpWidget(buildTestable(service: fake));
      // Sense pump: el Future no s'ha resolt i l'estat inicial és loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('mostra el títol "Notificacions" a l\'AppBar', (tester) async {
      await tester.pumpWidget(buildTestable());
      await tester.pump();
      await tester.pump();

      expect(find.text('Notificacions'), findsOneWidget);
    });

    testWidgets('mostra la llista de notificacions carregades', (tester) async {
      final fake = FakeNotificacionsService()
        ..notificacionsToReturn = [
          _stubNotificacio(id: 1, titol: 'Nova votació disponible'),
          _stubNotificacio(id: 2, titol: 'Votació tancada'),
        ];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Nova votació disponible'), findsOneWidget);
      expect(find.text('Votació tancada'), findsOneWidget);
    });

    testWidgets('mostra l\'estat buit quan no hi ha notificacions', (
      tester,
    ) async {
      final fake = FakeNotificacionsService()..notificacionsToReturn = [];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('No tens notificacions'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
    });

    testWidgets('mostra l\'error quan el servei falla', (tester) async {
      final fake = FakeNotificacionsService()
        ..errorToThrow = const NotificacionsApiException('Error de connexió');

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Error de connexió'), findsOneWidget);
    });

    testWidgets('botó "Marcar totes" visible quan hi ha no llegides', (
      tester,
    ) async {
      final fake = FakeNotificacionsService()
        ..notificacionsToReturn = [
          _stubNotificacio(id: 1, llegida: false),
          _stubNotificacio(id: 2, llegida: true),
        ];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Marcar totes'), findsOneWidget);
    });

    testWidgets('botó "Marcar totes" no visible quan totes estan llegides', (
      tester,
    ) async {
      final fake = FakeNotificacionsService()
        ..notificacionsToReturn = [
          _stubNotificacio(id: 1, llegida: true),
          _stubNotificacio(id: 2, llegida: true),
        ];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Marcar totes'), findsNothing);
    });

    testWidgets('botó "Marcar totes" no visible quan la llista és buida', (
      tester,
    ) async {
      final fake = FakeNotificacionsService()..notificacionsToReturn = [];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Marcar totes'), findsNothing);
    });

    testWidgets('tap en una notificació no llegida crida marcarLlegida', (
      tester,
    ) async {
      final fake = FakeNotificacionsService()
        ..notificacionsToReturn = [
          _stubNotificacio(id: 42, titol: 'Votació pendent', llegida: false),
        ];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Votació pendent'));
      await tester.pump();
      await tester.pump();

      expect(fake.marcarLlegidaCalls, contains(42));
    });

    testWidgets(
      'tap en una notificació ja llegida no torna a cridar marcarLlegida',
      (tester) async {
        final fake = FakeNotificacionsService()
          ..notificacionsToReturn = [
            _stubNotificacio(id: 10, titol: 'Ja llegida', llegida: true),
          ];

        await tester.pumpWidget(buildTestable(service: fake));
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Ja llegida'));
        await tester.pump();

        expect(fake.marcarLlegidaCalls, isEmpty);
      },
    );

    testWidgets('"Marcar totes" crida el servei i amaga el botó', (
      tester,
    ) async {
      final fake = FakeNotificacionsService()
        ..notificacionsToReturn = [
          _stubNotificacio(id: 1, llegida: false),
          _stubNotificacio(id: 2, llegida: false),
        ];

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Marcar totes'), findsOneWidget);

      await tester.tap(find.text('Marcar totes'));
      await tester.pump();
      await tester.pump();

      expect(fake.marcarTotesLlegidesCalls, 1);
      expect(find.text('Marcar totes'), findsNothing);
    });

    testWidgets(
      'onBadgeUpdate es crida quan es marca una notificació llegida',
      (tester) async {
        int badgeUpdates = 0;
        final fake = FakeNotificacionsService()
          ..notificacionsToReturn = [
            _stubNotificacio(id: 1, titol: 'Nova notificació', llegida: false),
          ];

        await tester.pumpWidget(
          buildTestable(service: fake, onBadgeUpdate: () => badgeUpdates++),
        );
        await tester.pump();
        await tester.pump();

        await tester.tap(find.text('Nova notificació'));
        await tester.pump();
        await tester.pump();

        expect(badgeUpdates, 1);
      },
    );

    testWidgets('error en marcarTotesLlegides mostra snackbar', (tester) async {
      final fake = FakeNotificacionsService()
        ..notificacionsToReturn = [_stubNotificacio(id: 1, llegida: false)]
        ..marcarTotesError = const NotificacionsApiException(
          'Error en marcar com a llegides',
        );

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Marcar totes'));
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Error en marcar com a llegides'), findsOneWidget);
      // El botó segueix visible perquè les notificacions no s'han marcat
      expect(find.text('Marcar totes'), findsOneWidget);
    });

    testWidgets('reintenta càrrega en prémer el botó de reintentar', (
      tester,
    ) async {
      int calls = 0;
      final fake = FakeNotificacionsService();
      fake.onGetNotificacions = () {
        calls++;
        if (calls == 1) throw const NotificacionsApiException('Error temporal');
        return [];
      };

      await tester.pumpWidget(buildTestable(service: fake));
      await tester.pump();
      await tester.pump();

      expect(find.text('Error temporal'), findsOneWidget);

      await tester.tap(find.text('Torna-ho a provar'));
      await tester.pump();
      await tester.pump();

      expect(find.text('Error temporal'), findsNothing);
      expect(calls, 2);
    });
  });
}

// ─── Fakes ────────────────────────────────────────────────────────────────────

class FakeNotificacionsService extends NotificacionsService {
  List<NotificacioModel> notificacionsToReturn = [
    _stubNotificacio(id: 1, titol: 'Notificació de prova', llegida: false),
  ];
  NotificacionsApiException? errorToThrow;
  NotificacionsApiException? marcarTotesError;
  Duration delay = Duration.zero;
  List<int> marcarLlegidaCalls = [];
  int marcarTotesLlegidesCalls = 0;
  List<NotificacioModel> Function()? onGetNotificacions;

  @override
  Future<List<NotificacioModel>> getNotificacions() async {
    if (delay != Duration.zero) await Future.delayed(delay);
    if (onGetNotificacions != null) return onGetNotificacions!();
    if (errorToThrow != null) throw errorToThrow!;
    return List.from(notificacionsToReturn);
  }

  @override
  Future<void> marcarLlegida(int id) async {
    marcarLlegidaCalls.add(id);
  }

  @override
  Future<void> marcarTotesLlegides() async {
    marcarTotesLlegidesCalls++;
    if (marcarTotesError != null) throw marcarTotesError!;
    if (errorToThrow != null) throw errorToThrow!;
  }
}

NotificacioModel _stubNotificacio({
  required int id,
  String titol = 'Títol de notificació',
  String cos = 'Cos de la notificació',
  bool llegida = false,
  String tipus = 'nova_votacio',
  int? objecteId,
}) {
  return NotificacioModel(
    id: id,
    tipus: tipus,
    titol: titol,
    cos: cos,
    llegida: llegida,
    dataCreacio: DateTime(2026, 1, 1, 10, 0),
    objecteId: objecteId,
  );
}
