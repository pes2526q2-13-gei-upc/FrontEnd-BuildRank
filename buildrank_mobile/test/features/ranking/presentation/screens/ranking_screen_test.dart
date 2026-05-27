import 'dart:typed_data';

import 'package:buildrank_mobile/features/ranking/data/ranking_model.dart';
import 'package:buildrank_mobile/features/ranking/data/ranking_service.dart';
import 'package:buildrank_mobile/features/ranking/presentation/screens/ranking_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject(FakeRankingService service) {
    return MaterialApp(
      locale: const Locale('ca'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: const MediaQueryData(
          size: Size(430, 900),
          textScaler: TextScaler.linear(1),
        ),
        child: RankingScreen(
          idEdifici: 2,
          buildingName: 'Edifici2 - Carrer de Montjuïc del Bisbe, 6',
          currentPoints: 780,
          rankingService: service,
          avatarImage: MemoryImage(_transparentImage),
        ),
      ),
    );
  }

  Future<void> pumpSubject(
    WidgetTester tester,
    FakeRankingService service,
  ) async {
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSubject(service));
  }

  Finder comparableLeagueFinder() {
    return find.byWidgetPredicate((widget) {
      if (widget is! Text) return false;

      final text = widget.data?.toLowerCase() ?? '';

      return text.contains('similars') && text.contains('lliga');
    });
  }

  Finder comparableSeasonFinder() {
    return find.byWidgetPredicate((widget) {
      if (widget is! Text) return false;

      final text = widget.data?.toLowerCase() ?? '';

      return text.contains('similars') && text.contains('temporada');
    });
  }

  testWidgets('mostra el ranking carregat correctament', (tester) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);

    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));

    await pumpRanking(tester);

    expect(find.textContaining('Estiu 2026'), findsWidgets);
    expect(find.text('Lliga Silver - Estiu 2026'), findsOneWidget);
    expect(find.textContaining('Posició actual: #10'), findsOneWidget);

    expect(find.text('La meva lliga'), findsWidgets);
    expect(comparableLeagueFinder(), findsOneWidget);
    expect(comparableSeasonFinder(), findsOneWidget);
    expect(find.text('Progrés de temporades'), findsOneWidget);

    expect(find.text('Top 3'), findsOneWidget);
    expect(find.text('Top 5'), findsOneWidget);
    expect(find.text('Top 10'), findsOneWidget);

    expect(find.text('Edifici #1'), findsOneWidget);
    expect(find.text('Edifici #2'), findsOneWidget);
    expect(find.text('Carrega més competidors'), findsOneWidget);

    expect(service.calls.first.scope, RankingScope.league);
    expect(service.calls.first.page, 1);
    expect(service.calls.first.targetTop, 3);
  });

  testWidgets('canvia a ranking de similars de la lliga', (tester) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    await tester.tap(comparableLeagueFinder());
    await pumpRanking(tester);

    expect(service.calls.last.scope, RankingScope.comparableLeague);
  });

  testWidgets('canvia a ranking de similars de la temporada', (tester) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    await tester.tap(comparableSeasonFinder());
    await pumpRanking(tester);

    expect(service.calls.last.scope, RankingScope.comparableSeason);
  });

  testWidgets(
    'mostra la vista de progrés sense fer una nova crida de ranking',
    (tester) async {
      final service = FakeRankingService();

      await pumpSubject(tester, service);
      await pumpRanking(tester);

      final callsBeforeProgress = service.calls.length;

      await tester.tap(find.text('Progrés de temporades'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Progrés de temporades'), findsWidgets);
      expect(find.text('Període de comparació'), findsOneWidget);
      expect(find.text('Últimes 3'), findsOneWidget);
      expect(find.text('Últimes 5'), findsOneWidget);
      expect(find.text('Últimes 10'), findsOneWidget);

      expect(find.text('Veure detall'), findsWidgets);
      expect(service.calls.length, callsBeforeProgress);
      expect(service.progressRankingCalls, 1);
    },
  );

  testWidgets('canvia el període de progrés a últimes 5 temporades', (
    tester,
  ) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    await tester.tap(find.text('Progrés de temporades'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.progressRankingCalls, 1);

    await tester.tap(find.text('Últimes 5'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(service.progressRankingCalls, 2);

    expect(find.textContaining('últimes 5 temporades'), findsOneWidget);
  });
  testWidgets('obre el modal de detall del progrés del meu edifici', (
    tester,
  ) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    await tester.tap(find.text('Progrés de temporades'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final detailFinder = find.text('Veure detall').first;

    await tester.scrollUntilVisible(
      detailFinder,
      250,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.pump();

    await tester.tap(detailFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('Progrés de'), findsWidgets);
    expect(find.textContaining('Millora acumulada:'), findsOneWidget);
  });

  testWidgets('canvia el top objectiu a Top 5', (tester) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    await tester.tap(find.text('Top 5'));
    await pumpRanking(tester);

    expect(service.calls.last.targetTop, 5);
    expect(find.textContaining('Top 5'), findsWidgets);
  });

  testWidgets('carrega més competidors quan hi ha més pàgines', (tester) async {
    final service = FakeRankingService();

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    final loadMoreFinder = find.text('Carrega més competidors');

    await tester.scrollUntilVisible(
      loadMoreFinder,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpRanking(tester);

    await tester.tap(loadMoreFinder);
    await pumpRanking(tester);

    expect(service.calls.last.page, 2);
    expect(find.text('Edifici #11'), findsOneWidget);
  });

  testWidgets('mostra estat d’error si falla el servei', (tester) async {
    final service = FakeRankingService(shouldThrow: true);

    await pumpSubject(tester, service);
    await pumpRanking(tester);

    expect(find.text('No s’ha pogut carregar el rànquing'), findsOneWidget);
    expect(find.text('Error fake de ranking'), findsOneWidget);
    expect(find.text('Torna-ho a provar'), findsOneWidget);
  });
}

Future<void> pumpRanking(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump();
}

class FakeRankingService extends RankingService {
  final bool shouldThrow;
  final List<RankingCall> calls = [];

  FakeRankingService({this.shouldThrow = false}) : super(useMockData: true);

  int progressRankingCalls = 0;

  @override
  Future<List<ProgressRankingEntry>> getProgressRanking({
    required int idEdifici,
    int window = 3,
  }) async {
    progressRankingCalls++;

    return [
      ProgressRankingEntry(
        idEdifici: idEdifici,
        position: 1,
        name: 'Edifici #$idEdifici',
        startPoints: 610,
        currentPoints: window == 5 ? 820 : 700,
        delta: window == 5 ? 210 : 90,
        division: 'Gold',
        isCurrentBuilding: true,
        series: [
          const RankingProgressPoint(
            seasonId: 1,
            seasonName: 'T-3',
            category: 'PROGRES',
            points: 610,
            position: 8,
            division: 'Bronze',
          ),
          const RankingProgressPoint(
            seasonId: 2,
            seasonName: 'T-2',
            category: 'PROGRES',
            points: 700,
            position: 5,
            division: 'Silver',
          ),
          if (window == 5)
            const RankingProgressPoint(
              seasonId: 3,
              seasonName: 'T-1',
              category: 'PROGRES',
              points: 820,
              position: 1,
              division: 'Gold',
            ),
        ],
      ),
      const ProgressRankingEntry(
        idEdifici: 11,
        position: 2,
        name: 'Edifici #11',
        startPoints: 640,
        currentPoints: 790,
        delta: 150,
        division: 'Silver',
        series: [
          RankingProgressPoint(
            seasonId: 1,
            seasonName: 'T-3',
            category: 'PROGRES',
            points: 640,
            position: 9,
            division: 'Bronze',
          ),
          RankingProgressPoint(
            seasonId: 2,
            seasonName: 'T-2',
            category: 'PROGRES',
            points: 790,
            position: 2,
            division: 'Silver',
          ),
        ],
      ),
    ];
  }

  @override
  Future<RankingResponse> getRanking({
    required int idEdifici,
    required String buildingName,
    required int currentPoints,
    required RankingScope scope,
    String? search,
    int page = 1,
    int targetTop = 3,
  }) async {
    calls.add(
      RankingCall(
        scope: scope,
        page: page,
        targetTop: targetTop,
        search: search,
      ),
    );

    if (shouldThrow) {
      throw const RankingApiException('Error fake de ranking');
    }

    if (page == 2) {
      return RankingResponse(
        summary: _summary(targetTop),
        entries: const [
          RankingEntry(
            idEdifici: 11,
            position: 11,
            name: 'Edifici #11',
            points: 760,
            isCurrentBuilding: false,
          ),
        ],
        page: 2,
        hasMore: false,
      );
    }

    return RankingResponse(
      summary: _summary(targetTop),
      entries: const [
        RankingEntry(
          idEdifici: 1,
          position: 1,
          name: 'Edifici #1',
          points: 980,
          isCurrentBuilding: false,
        ),
        RankingEntry(
          idEdifici: 2,
          position: 10,
          name: 'Edifici #2',
          points: 780,
          isCurrentBuilding: true,
        ),
      ],
      page: 1,
      hasMore: true,
    );
  }

  RankingSummary _summary(int targetTop) {
    final targetPoints = switch (targetTop) {
      3 => 940,
      5 => 900,
      10 => 780,
      _ => 940,
    };

    return RankingSummary(
      seasonName: 'Estiu 2026',
      leagueName: 'Lliga Silver - Estiu 2026',
      currentPoints: 780,
      targetPoints: targetPoints,
      progress: targetTop == 10 ? 1.0 : 0.85,
      daysRemaining: 120,
      promotionText: targetTop == 10
          ? 'Ja formes part del Top 10.'
          : 'Et falten punts per arribar al Top $targetTop.',
      currentPosition: 10,
    );
  }
}

class RankingCall {
  final RankingScope scope;
  final int page;
  final int targetTop;
  final String? search;

  const RankingCall({
    required this.scope,
    required this.page,
    required this.targetTop,
    this.search,
  });
}

final Uint8List _transparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);
