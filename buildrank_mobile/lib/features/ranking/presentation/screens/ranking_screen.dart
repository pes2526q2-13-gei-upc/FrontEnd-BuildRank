import 'dart:async';

import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/ranking/data/ranking_model.dart';
import 'package:buildrank_mobile/features/ranking/data/ranking_service.dart';
import 'package:buildrank_mobile/shared/widgets/badge_item.dart';

class RankingScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingName;
  final int currentPoints;
  final RankingService rankingService;
  final bool showBadges;
  final ImageProvider<Object>? avatarImage;

  const RankingScreen({
    super.key,
    required this.idEdifici,
    required this.buildingName,
    required this.currentPoints,
    this.rankingService = const RankingService(),
    this.showBadges = true,
    this.avatarImage,
  });

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _searchDebounce;

  RankingScope _scope = RankingScope.league;
  bool _showProgress = false;

  int _targetTop = 3;
  int _progressSeasonsCount = 3;
  RankingResponse? _ranking;

  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorText;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRanking({bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _errorText = null;
        _page = 1;
      });
    }

    try {
      final result = await widget.rankingService.getRanking(
        idEdifici: widget.idEdifici,
        buildingName: widget.buildingName,
        currentPoints: widget.currentPoints,
        scope: _scope,
        search: _searchController.text,
        page: reset ? 1 : _page,
        targetTop: _targetTop,
      );

      if (!mounted) return;

      setState(() {
        _ranking = result;
        _isLoading = false;
        _errorText = null;
      });
    } on RankingApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = 'No s’ha pogut carregar el rànquing.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    final current = _ranking;
    if (current == null || !current.hasMore || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _page = current.page + 1;
    });

    try {
      final nextPage = await widget.rankingService.getRanking(
        idEdifici: widget.idEdifici,
        buildingName: widget.buildingName,
        currentPoints: widget.currentPoints,
        scope: _scope,
        search: _searchController.text,
        page: _page,
        targetTop: _targetTop,
      );

      if (!mounted) return;

      setState(() {
        _ranking = current.copyWith(
          entries: [...current.entries, ...nextPage.entries],
          page: nextPage.page,
          hasMore: nextPage.hasMore,
        );
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No s’han pogut carregar més competidors.'),
        ),
      );
    }
  }

  void _changeScope(RankingScope scope) {
    if (!_showProgress && _scope == scope) return;

    setState(() {
      _scope = scope;
      _showProgress = false;
    });

    _loadRanking();
  }

  void _showProgressRanking() {
    if (_showProgress) return;

    setState(() {
      _showProgress = true;
      _errorText = null;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {});

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _loadRanking();
    });
  }

  RankingSummary get _summary {
    return _ranking?.summary ??
        RankingSummary.mock(currentPoints: widget.currentPoints);
  }

  List<RankingEntry> get _entries {
    return _ranking?.entries ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadRanking,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Torna"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Refrescar',
                  onPressed: _isLoading ? null : _loadRanking,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage:
                        widget.avatarImage ??
                        const NetworkImage("https://i.pravatar.cc/100"),
                  ),
                ),
              ],
            ),

            if (_isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorText != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildErrorState(),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildLeagueCard(),
                      const SizedBox(height: 16),

                      if (widget.showBadges) ...[
                        _buildBadges(),
                        const SizedBox(height: 16),
                      ],

                      _buildToggle(),
                      const SizedBox(height: 16),
                      if (_showProgress) ...[
                        _buildProgressControls(),
                        const SizedBox(height: 16),
                        _buildProgressRanking(),
                      ] else ...[
                        _buildSearch(),
                        const SizedBox(height: 16),
                        _buildRanking(),
                        _buildLoadMore(),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _loadRanking,
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.leaderboard_outlined,
            size: 48,
            color: Colors.black45,
          ),
          const SizedBox(height: 16),
          const Text(
            'No s’ha pogut carregar el rànquing',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            _errorText ?? 'Error desconegut.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadRanking,
            icon: const Icon(Icons.refresh),
            label: const Text('Torna-ho a provar'),
          ),
        ],
      ),
    );
  }

  Color _leagueCardColor(String leagueName) {
    final normalized = leagueName.toLowerCase();

    if (normalized.contains('gold') ||
        normalized.contains('or') ||
        normalized.contains('oro')) {
      return const Color(0xFFB8860B); // daurat
    }

    if (normalized.contains('bronze') || normalized.contains('bronce')) {
      return const Color(0xFF92400E); // bronze
    }

    if (normalized.contains('silver') || normalized.contains('plata')) {
      return const Color(0xFF6B7280); // plata / gris actual
    }

    return const Color(0xFF6B7280); // fallback actual
  }

  Widget _buildLeagueCard() {
    final summary = _summary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _leagueCardColor(summary.leagueName),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeaderChip(text: 'Temporada activa: ${summary.seasonName}'),
              _HeaderChip(text: _scope.label),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.leagueName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.buildingName,
            style: const TextStyle(color: Colors.white70, height: 1.3),
          ),
          const SizedBox(height: 14),
          Text(
            'Progrés cap al Top $_targetTop',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          _buildTargetTopSelectorCompact(),
          const SizedBox(height: 6),
          Text(
            '${_formatPoints(summary.currentPoints)} / ${_formatPoints(summary.targetPoints)} punts',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: summary.progress.clamp(0, 1),
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            summary.daysRemaining > 0
                ? summary.promotionText
                : 'Temporada pendent de calendari.',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          if (summary.currentPosition > 0) ...[
            const SizedBox(height: 10),
            Text(
              'Posició actual: #${summary.currentPosition}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressControls() {
    const options = [3, 5, 10];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Període de comparació',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final option in options)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Text('Últimes $option'),
                      selected: _progressSeasonsCount == option,
                      onSelected: (_) {
                        setState(() {
                          _progressSeasonsCount = option;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetTopSelectorCompact() {
    const options = [3, 5, 10];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          for (final option in options)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: _targetTop == option
                      ? null
                      : () {
                          setState(() {
                            _targetTop = option;
                          });

                          if (!_showProgress) {
                            _loadRanking();
                          }
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: _targetTop == option
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Top $option',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _targetTop == option
                            ? const Color(0xFF166534)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Insígnies aconseguides',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text('Veure-ho tot', style: TextStyle(color: Colors.green)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              BadgeItem(
                icon: Icons.bolt,
                label: 'Mestre solar',
                date: 'Oct 25',
                color: Colors.yellow,
              ),
              BadgeItem(
                icon: Icons.trending_up,
                label: 'Màxim estalvi',
                date: 'Nov 25',
                color: Colors.green,
              ),
              BadgeItem(
                icon: Icons.apartment,
                label: 'Resilient',
                date: 'Dec 25',
                color: Colors.blue,
              ),
              BadgeItem(
                icon: Icons.location_city,
                label: 'Prova',
                date: 'Gen 26',
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                text: RankingScope.league.label,
                selected: !_showProgress && _scope == RankingScope.league,
                onTap: () => _changeScope(RankingScope.league),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                text: RankingScope.comparableLeague.label,
                selected:
                    !_showProgress && _scope == RankingScope.comparableLeague,
                onTap: () => _changeScope(RankingScope.comparableLeague),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                text: RankingScope.comparableSeason.label,
                selected:
                    !_showProgress && _scope == RankingScope.comparableSeason,
                onTap: () => _changeScope(RankingScope.comparableSeason),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ProgressToggleButton(
          selected: _showProgress,
          onTap: _showProgressRanking,
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Cerca per carrer...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchDebounce?.cancel();

                  setState(() {
                    _searchController.clear();
                  });

                  _loadRanking();
                },
                icon: const Icon(Icons.close),
              ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRanking() {
    if (_entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Text(
          'No s’ha trobat cap competidor amb aquests filtres.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, height: 1.35),
        ),
      );
    }

    return Column(
      children: [for (final entry in _entries) _RankingItem(entry: entry)],
    );
  }

  Widget _buildLoadMore() {
    final ranking = _ranking;

    if (ranking == null || !ranking.hasMore) {
      return const SizedBox.shrink();
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _isLoadingMore ? null : _loadMore,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: _isLoadingMore
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Carrega més competidors'),
        ),
      ),
    );
  }

  String _formatPoints(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final remaining = text.length - i;

      buffer.write(text[i]);

      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }

  Widget _buildProgressRanking() {
    final entries = _mockProgressEntries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ranking de progrés',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Millora acumulada durant les últimes $_progressSeasonsCount temporades.',
          style: const TextStyle(color: Colors.black54, height: 1.35),
        ),
        const SizedBox(height: 14),
        ...entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ProgressRankingCard(
              entry: entry,
              onDetail: entry.isCurrentBuilding
                  ? () => _showProgressDetailModal(entry)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _showProgressDetailModal(_ProgressRankingEntry entry) {
    final values = _mockProgressSeries(_progressSeasonsCount);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Progrés de ${entry.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Evolució de puntuació durant les últimes $_progressSeasonsCount temporades.',
                  style: const TextStyle(color: Colors.black54, height: 1.35),
                ),
                const SizedBox(height: 22),
                _ProgressBarPlot(values: values),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF8EE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Millora acumulada: +${entry.delta} punts',
                    style: const TextStyle(
                      color: Color(0xFF166534),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<int> _mockProgressSeries(int count) {
    final all = [
      610,
      635,
      660,
      690,
      715,
      735,
      760,
      780,
      805,
      widget.currentPoints,
    ];

    return all.sublist(all.length - count);
  }

  List<_ProgressRankingEntry> get _mockProgressEntries {
    return [
      const _ProgressRankingEntry(
        idEdifici: 101,
        position: 1,
        name: 'Green Heights Residencial',
        startPoints: 620,
        currentPoints: 840,
      ),
      const _ProgressRankingEntry(
        idEdifici: 102,
        position: 2,
        name: 'EcoTower Suites',
        startPoints: 590,
        currentPoints: 760,
      ),
      _ProgressRankingEntry(
        idEdifici: widget.idEdifici,
        position: 3,
        name: widget.buildingName,
        startPoints: 640,
        currentPoints: widget.currentPoints,
        isCurrentBuilding: true,
      ),
      const _ProgressRankingEntry(
        idEdifici: 103,
        position: 4,
        name: 'Solaris Complex',
        startPoints: 710,
        currentPoints: 820,
      ),
      const _ProgressRankingEntry(
        idEdifici: 104,
        position: 5,
        name: 'Habitatges Maragall',
        startPoints: 530,
        currentPoints: 610,
      ),
    ];
  }
}

class _HeaderChip extends StatelessWidget {
  final String text;

  const _HeaderChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}

class _ProgressBarPlot extends StatelessWidget {
  final List<int> values;

  const _ProgressBarPlot({required this.values});

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      values[i].toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 120 * (values[i] / maxValue),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'T-${values.length - i - 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRankingCard extends StatelessWidget {
  final _ProgressRankingEntry entry;
  final VoidCallback? onDetail;

  const _ProgressRankingCard({required this.entry, this.onDetail});

  @override
  Widget build(BuildContext context) {
    final deltaText = entry.delta >= 0 ? '+${entry.delta}' : '${entry.delta}';
    final percentageText = '${(entry.percentage * 100).toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: entry.isCurrentBuilding ? const Color(0xFFEAF8EE) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.isCurrentBuilding
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE5E7EB),
          width: entry.isCurrentBuilding ? 1.6 : 1.1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: entry.position <= 3
                ? const Color(0xFFDCFCE7)
                : const Color(0xFFF3F4F6),
            child: Text(
              '#${entry.position}',
              style: const TextStyle(
                color: Color(0xFF166534),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${entry.startPoints} → ${entry.currentPoints} punts',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$deltaText pts',
                style: const TextStyle(
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              Text(
                percentageText,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              if (onDetail != null) ...[
                const SizedBox(height: 6),
                InkWell(
                  onTap: onDetail,
                  child: const Text(
                    'Veure detall',
                    style: TextStyle(
                      color: Color(0xFF166534),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRankingEntry {
  final int idEdifici;
  final int position;
  final String name;
  final int startPoints;
  final int currentPoints;
  final bool isCurrentBuilding;

  const _ProgressRankingEntry({
    required this.idEdifici,
    required this.position,
    required this.name,
    required this.startPoints,
    required this.currentPoints,
    this.isCurrentBuilding = false,
  });

  int get delta => currentPoints - startPoints;

  double get percentage {
    if (startPoints <= 0) return 0;
    return delta / startPoints;
  }
}

class _ProgressToggleButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _ProgressToggleButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF166534) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF166534)
                  : const Color(0xFFE5E7EB),
              width: selected ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up,
                size: 20,
                color: selected ? Colors.white : const Color(0xFF166534),
              ),
              const SizedBox(width: 8),
              Text(
                'Progrés de temporades',
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF166534),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selected ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final RankingEntry entry;

  const _RankingItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: entry.isCurrentBuilding ? const Color(0xFFE8F4EC) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: entry.isCurrentBuilding
              ? Colors.green.shade200
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 34, child: Center(child: _buildPosition())),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: entry.isCurrentBuilding
                ? Colors.green.shade100
                : Colors.grey.shade200,
            child: Icon(
              entry.isCurrentBuilding
                  ? Icons.home_work_outlined
                  : Icons.apartment_outlined,
              color: entry.isCurrentBuilding ? Colors.green : Colors.black54,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: TextStyle(
                    fontWeight: entry.isCurrentBuilding
                        ? FontWeight.w800
                        : FontWeight.w600,
                  ),
                ),
                if (entry.address != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.address!,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _formatPoints(entry.points),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildPosition() {
    switch (entry.position) {
      case 1:
        return const Icon(Icons.emoji_events, color: Color(0xFFFFD700));
      case 2:
        return const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0));
      case 3:
        return const Icon(Icons.emoji_events, color: Color(0xFFCD7F32));
      default:
        return Text(
          '#${entry.position}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        );
    }
  }

  String _formatPoints(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final remaining = text.length - i;

      buffer.write(text[i]);

      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }
}
