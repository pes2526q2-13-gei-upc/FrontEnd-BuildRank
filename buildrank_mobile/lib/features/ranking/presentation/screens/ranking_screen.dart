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
  int _targetTop = 3;
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
    if (_scope == scope) return;

    setState(() {
      _scope = scope;
    });

    _loadRanking();
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
                      const SizedBox(height: 12),
                      _buildTopSelector(),
                      const SizedBox(height: 20),
                      if (widget.showBadges) ...[
                        _buildBadges(),
                        const SizedBox(height: 20),
                      ],
                      _buildToggle(),
                      const SizedBox(height: 12),
                      _buildSearch(),
                      const SizedBox(height: 16),
                      _buildRanking(),
                      const SizedBox(height: 16),
                      _buildLoadMore(),
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

  Widget _buildLeagueCard() {
    final summary = _summary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6B7280),
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

  Widget _buildTopSelector() {
    const options = [3, 5, 10];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparar posició amb:',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                ChoiceChip(
                  label: Text('Top $option'),
                  selected: _targetTop == option,
                  onSelected: (selected) {
                    if (!selected || _targetTop == option) return;

                    setState(() {
                      _targetTop = option;
                    });

                    _loadRanking();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Row(
      children: [
        Expanded(
          child: _ToggleButton(
            text: RankingScope.league.label,
            selected: _scope == RankingScope.league,
            onTap: () => _changeScope(RankingScope.league),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToggleButton(
            text: RankingScope.comparableLeague.label,
            selected: _scope == RankingScope.comparableLeague,
            onTap: () => _changeScope(RankingScope.comparableLeague),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToggleButton(
            text: RankingScope.comparableSeason.label,
            selected: _scope == RankingScope.comparableSeason,
            onTap: () => _changeScope(RankingScope.comparableSeason),
          ),
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
