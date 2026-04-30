import 'dart:typed_data';

import 'package:buildrank_mobile/features/ranking/data/ranking_model.dart';
import 'package:buildrank_mobile/features/ranking/data/ranking_service.dart';
import 'package:buildrank_mobile/features/ranking/presentation/screens/ranking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildSubject(FakeRankingService service) {
    return MaterialApp(
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
          showBadges: false,
          avatarImage: MemoryImage(_transparentImage),
        ),
      ),
    );
  }

  testWidgets('mostra el ranking carregat correctament', (tester) async {
    final service = FakeRankingService();

    await tester.pumpWidget(buildSubject(service));

    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));

    await pumpRanking(tester);

    expect(find.textContaining('Estiu 2026'), findsWidgets);
    expect(find.text('Lliga Silver - Estiu 2026'), findsOneWidget);
    expect(find.textContaining('Posició actual: #10'), findsOneWidget);

    expect(find.text('La meva lliga'), findsWidgets);
    expect(find.text('Edificis similars'), findsOneWidget);

    expect(find.text('Edifici #1'), findsOneWidget);
    expect(find.text('Edifici #2'), findsOneWidget);
    expect(find.text('Carrega més competidors'), findsOneWidget);

    expect(service.calls.first.scope, RankingScope.league);
    expect(service.calls.first.page, 1);
    expect(service.calls.first.targetTop, 3);
  });

  testWidgets('canvia a ranking d’edificis similars', (tester) async {
    final service = FakeRankingService();

    await tester.pumpWidget(buildSubject(service));
    await pumpRanking(tester);

    await tester.tap(find.text('Edificis similars'));
    await pumpRanking(tester);

    expect(service.calls.last.scope, RankingScope.comparable);
  });

  testWidgets('canvia el top objectiu a Top 5', (tester) async {
    final service = FakeRankingService();

    await tester.pumpWidget(buildSubject(service));
    await pumpRanking(tester);

    await tester.tap(find.text('Top 5'));
    await pumpRanking(tester);

    expect(service.calls.last.targetTop, 5);
    expect(find.textContaining('Top 5'), findsWidgets);
  });

  testWidgets('carrega més competidors quan hi ha més pàgines', (tester) async {
    final service = FakeRankingService();

    await tester.pumpWidget(buildSubject(service));
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

    await tester.pumpWidget(buildSubject(service));
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
    calls.add(RankingCall(scope: scope, page: page, targetTop: targetTop));

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

  const RankingCall({
    required this.scope,
    required this.page,
    required this.targetTop,
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
