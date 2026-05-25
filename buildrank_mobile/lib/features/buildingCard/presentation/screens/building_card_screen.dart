import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/formBuilding/data/building_service.dart';
import '../../../../shared/widgets/metric_card.dart';
import '../../../../shared/widgets/action_tile.dart';
import '../../../../shared/widgets/league_info_card.dart';
import '../../../../shared/widgets/revision_card.dart';
import 'package:buildrank_mobile/features/buildingRequests/presentation/screens/pending_building_requests_screen.dart';
import 'package:buildrank_mobile/features/habitatge/presentation/screens/edit_habitatge_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class BuildingDetailScreen extends StatefulWidget {
  final int idEdifici;
  final Map<String, dynamic> building;
  final String userRole;
  final String title;
  final String address;
  final int score;

  const BuildingDetailScreen({
    super.key,
    required this.idEdifici,
    required this.building,
    required this.userRole,
    required this.title,
    required this.address,
    required this.score,
  });

  @override
  State<BuildingDetailScreen> createState() => _BuildingDetailScreenState();
}

class _BuildingDetailScreenState extends State<BuildingDetailScreen> {
  final BuildingService _buildingService = BuildingService();

  int _tabIndex = 0;
  bool _isLoading = true;
  String? _errorText;
  Map<String, dynamic>? _buildingDetail;

  bool _badgesLoading = true;
  String? _badgesErrorText;
  List<BuildingBadgeItem> _badges = [];

  @override
  void initState() {
    super.initState();
    _buildingDetail = widget.building;
    _loadBuildingDetail();
    _loadBuildingBadges();
  }

  Future<void> _refreshAll() async {
    await _loadBuildingDetail();
    await _loadBuildingBadges();
  }

  Future<void> _loadBuildingDetail() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final detail = await _buildingService.getBuildingDetail(widget.idEdifici);

      if (!mounted) return;

      setState(() {
        _buildingDetail = detail;
      });
    } on BuildingApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = AppLocalizations.of(context).buildingCardDetailLoadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadBuildingBadges({bool recalculate = false}) async {
    setState(() {
      _badgesLoading = true;
      _badgesErrorText = null;
    });

    try {
      final response = recalculate
          ? await _buildingService.recalculateBuildingBadges(widget.idEdifici)
          : await _buildingService.getBuildingBadges(widget.idEdifici);

      if (!mounted) return;

      setState(() {
        _badges = response.badges;
      });

      if (recalculate && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).buildingCardBadgesRecalculated,
            ),
          ),
        );
      }
    } on BuildingApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _badgesErrorText = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _badgesErrorText = AppLocalizations.of(
          context,
        ).buildingCardBadgesLoadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _badgesLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> get _building => _buildingDetail ?? widget.building;

  Map<String, dynamic>? get _localitzacio {
    final value = _building['localitzacio'];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  int get _score => _readScore(_building, fallback: widget.score);

  String get _title {
    final localitzacio = _localitzacio;
    final carrer = localitzacio?['carrer']?.toString().trim();
    final numero = localitzacio?['numero']?.toString().trim();

    if (carrer != null && carrer.isNotEmpty) {
      return numero != null && numero.isNotEmpty ? '$carrer, $numero' : carrer;
    }

    return widget.title;
  }

  String _address(AppLocalizations l10n) {
    final localitzacio = _localitzacio;

    if (localitzacio == null) {
      return widget.address;
    }

    final barri = localitzacio['barri']?.toString().trim();
    final codiPostal = localitzacio['codiPostal']?.toString().trim();
    final zona = localitzacio['zonaClimatica']?.toString().trim();

    final parts = [
      if (barri != null && barri.isNotEmpty) barri,
      if (codiPostal != null && codiPostal.isNotEmpty) codiPostal,
      if (zona != null && zona.isNotEmpty) l10n.buildingCardClimateZone(zona),
    ];

    return parts.isEmpty ? widget.address : parts.join(' · ');
  }

  String _scoreLabel(AppLocalizations l10n) {
    if (_score >= 80) return l10n.buildingCardScoreExcellent;
    if (_score >= 65) return l10n.buildingCardScoreGood;
    if (_score >= 50) return l10n.buildingCardScoreImprove;
    return l10n.buildingCardScorePriority;
  }

  Color get _scoreColor {
    if (_score >= 80) return Colors.green;
    if (_score >= 65) return Colors.blue;
    if (_score >= 50) return Colors.orange;
    return Colors.red;
  }

  String _value(String key, {String? fallback}) {
    final fallbackText =
        fallback ?? AppLocalizations.of(context).commonUnavailable;
    final value = _building[key];
    if (value == null) return fallbackText;

    final text = value.toString().trim();
    return text.isEmpty ? fallbackText : text;
  }

  String _formatDouble(String key, {String suffix = '', String? fallback}) {
    final fallbackText =
        fallback ?? AppLocalizations.of(context).commonUnavailable;
    final value = _building[key];

    if (value is int) {
      return '$value$suffix';
    }
    if (value is double) {
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}$suffix';
    }
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return '${parsed.toStringAsFixed(parsed.truncateToDouble() == parsed ? 0 : 1)}$suffix';
      }
    }

    return fallbackText;
  }

  int _readScore(Map<String, dynamic> building, {required int fallback}) {
    final value = building['puntuacioBase'];

    if (value is int) return value.clamp(0, 100);
    if (value is double) return value.round().clamp(0, 100);
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed.round().clamp(0, 100);
    }

    return fallback.clamp(0, 100);
  }

  String _energyGradeFromScore() {
    if (_score >= 90) return 'A';
    if (_score >= 75) return 'B';
    if (_score >= 60) return 'C';
    if (_score >= 45) return 'D';
    return 'E';
  }

  Map<String, dynamic>? get _classificacioEnergetica {
    final value = _building['classificacio_energetica'];

    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);

    return null;
  }

  String get _energyLetter {
    final letter = _classificacioEnergetica?['lletra']?.toString();

    if (letter == null || letter.isEmpty || letter == 'null') {
      // Fallback visual si el backend encara no retorna classificació.
      // Així la pantalla no queda buida ni es trenca.
      return _classificacioEnergetica == null ? _energyGradeFromScore() : '—';
    }

    return letter;
  }

  String _energyMetricTitle(AppLocalizations l10n) {
    final label = _classificacioEnergetica?['etiqueta']?.toString();

    if (label == null || label.isEmpty || label == 'null') {
      return l10n.buildingCardEstimatedRating;
    }

    return label.toUpperCase();
  }

  String? get _energyDetail {
    final detail = _classificacioEnergetica?['detall']?.toString();

    if (detail == null || detail.isEmpty || detail == 'null') {
      return null;
    }

    return detail;
  }

  String? _energyMissingDataText(AppLocalizations l10n) {
    final missing = _classificacioEnergetica?['dades_insuficients'];

    if (missing is List && missing.isNotEmpty) {
      return l10n.buildingCardPendingData(missing.join(", "));
    }

    return null;
  }

  String _activeStatusLabel(AppLocalizations l10n) {
    final actiu = _building['actiu'];
    if (actiu == false) return l10n.profileInactive.toUpperCase();
    return l10n.profileActive.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshAll,
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
                  onPressed: _isLoading ? null : _refreshAll,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
                  ),
                ),
              ],
            ),

            if (_errorText != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildErrorState(),
              )
            else
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildPerformance(),
                    const SizedBox(height: 20),
                    _buildBadgesSection(),
                    const SizedBox(height: 20),
                    _buildActions(),
                    const SizedBox(height: 20),
                    _buildTabs(),
                    const SizedBox(height: 16),
                    _buildTabContent(),
                    const SizedBox(height: 20),
                    const LeagueInfoCard(),
                    const SizedBox(height: 20),
                    const RevisionCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 42),
          const SizedBox(height: 12),
          Text(
            _errorText ?? AppLocalizations.of(context).buildingCardLoadError,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadBuildingDetail,
            child: Text(AppLocalizations.of(context).commonRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);

    return Container(
      color: const Color(0xFFE8F4EC),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(text: _activeStatusLabel(l10n), color: Colors.green),
              _StatusChip(
                text: 'ID ${widget.idEdifici}',
                color: Colors.blueGrey,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            _title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(_address(l10n))),
            ],
          ),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _scoreColor, width: 10),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _score.toString(),
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _scoreLabel(l10n),
                          style: TextStyle(
                            color: _scoreColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(l10n.buildingCardBaseScore),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformance() {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.buildingCardPerformance,
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              Text(
                l10n.buildingCardInitialData,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: [
              MetricCard(
                title: _energyMetricTitle(l10n),
                value: _energyLetter,
                icon: Icons.bolt,
              ),
              MetricCard(
                title: l10n.buildingCardSurface,
                value: _formatDouble('superficieTotal', suffix: ' m²'),
                icon: Icons.square_foot,
              ),
              MetricCard(
                title: l10n.buildingCardFloors,
                value: _value('nombrePlantes'),
                icon: Icons.layers,
              ),
              MetricCard(
                title: l10n.buildingCardOrientation,
                value: _value('orientacioPrincipal'),
                icon: Icons.explore,
              ),
            ],
          ),

          if (_energyDetail != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _energyDetail!,
                    style: TextStyle(
                      color: Colors.blueGrey.shade900,
                      height: 1.35,
                      fontSize: 13,
                    ),
                  ),
                  if (_energyMissingDataText(l10n) != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _energyMissingDataText(l10n)!,
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        height: 1.35,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    final l10n = AppLocalizations.of(context);
    final isAdmin = widget.userRole == 'admin';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_outlined, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.buildingCardBadgesTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                if (isAdmin)
                  TextButton.icon(
                    onPressed: _badgesLoading
                        ? null
                        : () => _loadBuildingBadges(recalculate: true),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(l10n.buildingCardRecalculate),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_badgesLoading)
              const LinearProgressIndicator()
            else if (_badgesErrorText != null)
              _BadgeStateMessage(
                icon: Icons.info_outline,
                text: _badgesErrorText!,
              )
            else if (_badges.isEmpty)
              _BadgeStateMessage(
                icon: Icons.emoji_events_outlined,
                text: l10n.buildingCardNoBadges,
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final badge in _badges)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _BuildingBadgeCard(badge: badge),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    final l10n = AppLocalizations.of(context);
    final isAdmin = widget.userRole == 'admin';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.buildingCardRecommendedActions,
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
          ),
          const SizedBox(height: 14),
          ActionTile(
            icon: Icons.description,
            title: l10n.buildingCardActionReportTitle,
            subtitle: l10n.buildingCardActionReportSubtitle,
            color: Color(0xFFF1F1F1),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 10),
            ActionTile(
              icon: Icons.verified_user_outlined,
              title: l10n.buildingCardActionManageRequestsTitle,
              subtitle: l10n.buildingCardActionManageRequestsSubtitle,
              color: const Color(0xFFFFF7ED),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PendingBuildingRequestsScreen(
                      idEdifici: widget.idEdifici,
                      buildingTitle: _title,
                      userRole: widget.userRole,
                    ),
                  ),
                );
              },
            ),
          ] else if (widget.userRole == 'owner') ...[
            const SizedBox(height: 10),
            ActionTile(
              icon: Icons.home_outlined,
              title: l10n.buildingCardActionEditHabitatgeTitle,
              subtitle: l10n.buildingCardActionEditHabitatgeSubtitle,
              color: const Color(0xFFFFF7ED),
              onTap: () async {
                final updated = await Navigator.push<Map<String, dynamic>?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditHabitatgeScreen(
                      idEdifici: widget.idEdifici,
                      buildingTitle: _title,
                    ),
                  ),
                );

                if (!mounted) return;

                if (updated != null) {
                  await _loadBuildingDetail();
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SegmentedButton<int>(
        segments: [
          ButtonSegment(value: 0, label: Text(l10n.buildingCardTabDetails)),
          ButtonSegment(value: 1, label: Text(l10n.buildingCardTabHistory)),
          ButtonSegment(value: 2, label: Text(l10n.buildingCardTabDocuments)),
        ],
        selected: {_tabIndex},
        onSelectionChanged: (value) {
          setState(() {
            _tabIndex = value.first;
          });
        },
      ),
    );
  }

  Widget _buildTabContent() {
    final l10n = AppLocalizations.of(context);

    switch (_tabIndex) {
      case 1:
        return _buildPlaceholderTab(
          icon: Icons.history,
          title: l10n.buildingCardHistoryUnavailableTitle,
          text: l10n.buildingCardHistoryUnavailableBody,
        );
      case 2:
        return _buildPlaceholderTab(
          icon: Icons.folder_outlined,
          title: l10n.buildingCardDocumentsSoonTitle,
          text: l10n.buildingCardDocumentsSoonBody,
        );
      case 0:
      default:
        return _buildDetails();
    }
  }

  Widget _buildPlaceholderTab({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.black45),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    final l10n = AppLocalizations.of(context);
    final localitzacio = _localitzacio;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: l10n.buildingCardConstructionYear,
                  value: _value("anyConstruccio"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: l10n.buildingCardFloors,
                  value: l10n.buildingCardFloorsCount(_value("nombrePlantes")),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: l10n.buildingCardTypology,
                  value: _value("tipologia"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: l10n.buildingCardSurface,
                  value: _formatDouble("superficieTotal", suffix: " m²"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: l10n.buildingCardRegulation,
                  value: _value("reglament"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: l10n.buildingCardOrientation,
                  value: _value("orientacioPrincipal"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Text(
              localitzacio == null
                  ? l10n.buildingCardNoLocation
                  : l10n.buildingCardLocationSummary(
                      (localitzacio['carrer'] ?? '-').toString(),
                      (localitzacio['numero'] ?? '-').toString(),
                      (localitzacio['barri'] ?? '-').toString(),
                      (localitzacio['codiPostal'] ?? '-').toString(),
                    ),
              style: TextStyle(height: 1.35, color: Colors.green.shade900),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: color.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      side: BorderSide(color: color.withValues(alpha: 0.2)),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _BuildingBadgeCard extends StatelessWidget {
  final BuildingBadgeItem badge;

  const _BuildingBadgeCard({required this.badge});

  Color get _color {
    final text = '${badge.code} ${badge.category}'.toLowerCase();

    if (text.contains('emiss')) return Colors.green;
    if (text.contains('dades') || text.contains('data')) return Colors.blue;
    if (text.contains('millora')) return Colors.deepPurple;
    if (text.contains('ranking') ||
        text.contains('or') ||
        text.contains('gold')) {
      return Colors.amber;
    }

    return Colors.orange;
  }

  IconData get _icon {
    final text = '${badge.code} ${badge.category}'.toLowerCase();

    if (text.contains('emiss')) return Icons.co2_outlined;
    if (text.contains('dades') || text.contains('data')) {
      return Icons.verified_outlined;
    }
    if (text.contains('millora')) return Icons.construction_outlined;
    if (text.contains('bhs') || text.contains('score')) return Icons.speed;
    if (text.contains('ranking') ||
        text.contains('or') ||
        text.contains('gold')) {
      return Icons.emoji_events_outlined;
    }

    return Icons.workspace_premium_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      width: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Color.fromRGBO(0, 0, 0, 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.14),
            foregroundColor: color,
            child: Icon(_icon),
          ),
          const SizedBox(height: 10),
          Text(
            badge.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            badge.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          if (badge.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              badge.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.25,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            badge.awardedText,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeStateMessage extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BadgeStateMessage({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.black45),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
        ),
      ],
    );
  }
}
