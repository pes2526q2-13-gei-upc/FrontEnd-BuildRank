import 'dart:async';

import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/ranking/data/ranking_model.dart';
import 'package:buildrank_mobile/features/ranking/data/ranking_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class RankingScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingName;
  final int currentPoints;
  final RankingService rankingService;
  final ImageProvider<Object>? avatarImage;

  const RankingScreen({
    super.key,
    required this.idEdifici,
    required this.buildingName,
    required this.currentPoints,
    this.rankingService = const RankingService(),
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
  List<ProgressRankingEntry> _progressRanking = const [];
  bool _isLoadingProgress = false;
  String? _progressErrorText;

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
        _errorText = AppLocalizations.of(context).rankingLoadError;
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
        SnackBar(
          content: Text(AppLocalizations.of(context).rankingLoadMoreError),
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

    _loadProgressRanking();
  }

  Future<void> _loadProgressRanking() async {
    setState(() {
      _isLoadingProgress = true;
      _progressErrorText = null;
    });

    try {
      final result = await widget.rankingService.getProgressRanking(
        idEdifici: widget.idEdifici,
        window: _progressSeasonsCount,
      );

      if (!mounted) return;

      setState(() {
        _progressRanking = result;
        _isLoadingProgress = false;
      });
    } on RankingApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _progressErrorText = e.message;
        _isLoadingProgress = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _progressErrorText = AppLocalizations.of(
          context,
        ).rankingProgressLoadError;
        _isLoadingProgress = false;
      });
    }
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

  String _scopeLabel(RankingScope scope, AppLocalizations l10n) {
    switch (scope) {
      case RankingScope.league:
        return l10n.rankingScopeLeague;
      case RankingScope.comparableLeague:
        return l10n.rankingScopeComparableLeague;
      case RankingScope.comparableSeason:
        return l10n.rankingScopeComparableSeason;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                  label: Text(l10n.commonBack),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  tooltip: l10n.commonRefresh,
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
        heroTag: 'ranking_fab',
        onPressed: _isLoading ? null : _loadRanking,
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context);

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
          Text(
            _errorText ==
                    'Aquest edifici encara no participa en cap temporada activa.'
                ? l10n.rankingUnavailableTitle
                : l10n.rankingLoadErrorTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            _errorText ?? l10n.commonUnknownError,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadRanking,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.commonRetry),
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
    final l10n = AppLocalizations.of(context);
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
              _HeaderChip(text: l10n.rankingActiveSeason(summary.seasonName)),
              _HeaderChip(text: _scopeLabel(_scope, l10n)),
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
            _cleanBuildingDisplayName(widget.buildingName),
            style: const TextStyle(color: Colors.white70, height: 1.3),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.rankingProgressToTop(_targetTop),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          _buildTargetTopSelectorCompact(),
          const SizedBox(height: 6),
          Text(
            l10n.rankingPointsProgress(
              _formatPoints(summary.currentPoints),
              _formatPoints(summary.targetPoints),
            ),
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
                : l10n.rankingSeasonPendingCalendar,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          if (summary.currentPosition > 0) ...[
            const SizedBox(height: 10),
            Text(
              l10n.rankingCurrentPosition(summary.currentPosition),
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
    final l10n = AppLocalizations.of(context);
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
          Text(
            l10n.rankingComparisonPeriod,
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
                      label: Text(l10n.rankingLastSeasons(option)),
                      selected: _progressSeasonsCount == option,
                      onSelected: (_) {
                        setState(() {
                          _progressSeasonsCount = option;
                        });

                        _loadProgressRanking();
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
    final l10n = AppLocalizations.of(context);
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
                      l10n.rankingTopTarget(option),
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

  Widget _buildToggle() {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                text: _scopeLabel(RankingScope.league, l10n),
                selected: !_showProgress && _scope == RankingScope.league,
                onTap: () => _changeScope(RankingScope.league),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                text: _scopeLabel(RankingScope.comparableLeague, l10n),
                selected:
                    !_showProgress && _scope == RankingScope.comparableLeague,
                onTap: () => _changeScope(RankingScope.comparableLeague),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ToggleButton(
                text: _scopeLabel(RankingScope.comparableSeason, l10n),
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
    final l10n = AppLocalizations.of(context);

    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: l10n.rankingSearchHint,
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
    final l10n = AppLocalizations.of(context);

    if (_entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          l10n.rankingNoCompetitors,
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
              : Text(AppLocalizations.of(context).rankingLoadMore),
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
    final l10n = AppLocalizations.of(context);

    if (_isLoadingProgress) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_progressErrorText != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          _progressErrorText!,
          style: const TextStyle(color: Colors.black54, height: 1.35),
        ),
      );
    }

    if (_progressRanking.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          l10n.rankingNoProgressHistory,
          style: const TextStyle(color: Colors.black54, height: 1.35),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rankingSeasonProgressTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.rankingSeasonProgressSubtitle(_progressSeasonsCount),
          style: const TextStyle(color: Colors.black54, height: 1.35),
        ),
        const SizedBox(height: 14),
        ..._progressRanking.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ProgressRankingCard(
              entry: entry,
              onDetail: entry.series.isEmpty
                  ? null
                  : () => _showProgressDetailModal(entry),
            ),
          ),
        ),
      ],
    );
  }

  void _showProgressDetailModal(ProgressRankingEntry entry) {
    final l10n = AppLocalizations.of(context);
    final values = entry.series.isEmpty
        ? [entry.startPoints, entry.currentPoints]
        : entry.series.map((item) => item.points).toList();

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
                  l10n.rankingProgressForBuilding(
                    _cleanBuildingDisplayName(entry.name),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.rankingProgressModalSubtitle(_progressSeasonsCount),
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
                    l10n.rankingAccumulatedImprovement(entry.delta),
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
  final ProgressRankingEntry entry;
  final VoidCallback? onDetail;

  const _ProgressRankingCard({required this.entry, this.onDetail});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  _cleanBuildingDisplayName(entry.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.rankingPointsRange(
                    entry.startPoints,
                    entry.currentPoints,
                  ),
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
                l10n.rankingDeltaPoints(deltaText),
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
                  child: Text(
                    l10n.rankingViewDetail,
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

class _ProgressToggleButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _ProgressToggleButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                l10n.rankingSeasonProgressTitle,
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
                  _cleanBuildingDisplayName(entry.name),
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

String _cleanBuildingDisplayName(String value) {
  return value
      .replaceFirst(
        RegExp(r'^Edifici\s*#?\s*\d+\s*[-–—]\s*', caseSensitive: false),
        '',
      )
      .trim();
}
