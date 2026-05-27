import 'package:buildrank_mobile/features/vots/data/votacions_model.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_service.dart';
import 'package:buildrank_mobile/features/vots/data/votation_model.dart';
import 'package:buildrank_mobile/features/vots/data/votation_service.dart';
import 'package:buildrank_mobile/features/vots/presentation/screens/crear_votacio_screen.dart';
import 'package:buildrank_mobile/features/vots/presentation/screens/votacio_detall_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VotacionsScreen extends StatefulWidget {
  final int idEdifici;
  final String userRole;
  final String buildingName;
  final VotationService? service;
  final VotacionsService? legacyService;

  const VotacionsScreen({
    super.key,
    required this.idEdifici,
    required this.userRole,
    required this.buildingName,
    this.service,
    this.legacyService,
  });

  @override
  State<VotacionsScreen> createState() => _VotacionsScreenState();
}

class _VotacionsScreenState extends State<VotacionsScreen> {
  late final VotationService _service;
  late final VotacionsService _legacyService;

  bool _loading = true;
  bool _voting = false;
  bool _accrediting = false;
  String? _error;
  int _tab = 0;
  List<VotationModel> _votacions = [];
  List<VotacioResumModel> _comunitats = [];
  DateTime? _lastAutoRefresh;
  bool _autoRefreshing = false;

  String get _normalizedRole =>
      widget.userRole.trim().toLowerCase().replaceAll('-', '_');

  bool get _isAdmin =>
      _normalizedRole == 'admin' ||
      _normalizedRole == 'admin_finca' ||
      _normalizedRole == 'administrador_finca';

  bool get _isOwner =>
      _normalizedRole == 'owner' ||
      _normalizedRole == 'propietari' ||
      _normalizedRole == 'propietario';

  bool get _canVoteCommunity => _isAdmin || _isOwner;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? VotationService();
    _legacyService = widget.legacyService ?? VotacionsService();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    setState(() {
      if (!silent) {
        _loading = true;
      }
      _error = null;
    });

    try {
      final simsFuture = _service.getVotacions(widget.idEdifici);
      final comsFuture = _legacyService
          .getVotacions(idEdifici: widget.idEdifici)
          .catchError((_) => <VotacioResumModel>[]);

      final sims = await simsFuture;
      final coms = await comsFuture;

      if (!mounted) return;
      setState(() {
        _votacions = sims;
        _comunitats = coms;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          if (!silent) {
            _loading = false;
          }
          _autoRefreshing = false;
        });
      }
    }
  }

  void _scheduleAutoRefresh() {
    if (_loading || _autoRefreshing) return;

    final now = DateTime.now();
    final last = _lastAutoRefresh;

    if (last != null && now.difference(last).inSeconds < 3) {
      return;
    }

    _lastAutoRefresh = now;
    _autoRefreshing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _load(silent: true);
    });
  }

  List<VotationModel> get _filtered {
    switch (_tab) {
      case 0:
        return _votacions.where((v) => v.isActive).toList();
      case 1:
        return _votacions.where((v) => v.isCompleted).toList();
      case 2:
        return _votacions.where((v) => _isAdmin || v.potVotar).toList();
      default:
        return _votacions;
    }
  }

  List<VotacioResumModel> get _filteredComunitats {
    switch (_tab) {
      case 0:
        return _comunitats.where((v) => v.estat == 'oberta').toList();
      case 1:
        return _comunitats.where((v) => v.estat != 'oberta').toList();
      case 2:
        return _isAdmin ? _comunitats : [];
      default:
        return _comunitats;
    }
  }

  Future<void> _vote(VotationModel votacio, String sentit) async {
    if (_voting) return;

    setState(() => _voting = true);

    try {
      final updated = await _service.votar(
        idEdifici: widget.idEdifici,
        votacioId: votacio.id,
        sentit: sentit,
      );

      if (!mounted) return;
      setState(() {
        _votacions = _votacions
            .map((v) => v.id == updated.id ? updated : v)
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            sentit == 'favor'
                ? AppLocalizations.of(context).votesRegisteredFavor
                : AppLocalizations.of(context).votesRegisteredAgainst,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _voting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scheduleAutoRefresh();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F5),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: _createVotacio,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _load(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              _buildTabs(),
              const SizedBox(height: 16),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                _buildError()
              else if (_filtered.isEmpty && _filteredComunitats.isEmpty)
                _buildEmpty()
              else ...[
                if (_filteredComunitats.isNotEmpty) ...[
                  _buildSectionLabel(
                    AppLocalizations.of(context).votesGeneralSection,
                  ),
                  const SizedBox(height: 8),
                  for (final v in _filteredComunitats) ...[
                    _ComunityCard(votacio: v, onTap: () => _openDetall(v)),
                    const SizedBox(height: 10),
                  ],
                  if (_filtered.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _buildSectionLabel(
                      AppLocalizations.of(context).votesSimulationSection,
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
                for (final votacio in _filtered) ...[
                  _VotationCard(
                    votacio: votacio,
                    voting: _voting,
                    accrediting: _accrediting,
                    canAccredit: _isAdmin,
                    onVote: (sentit) => _vote(votacio, sentit),
                    onAccredit: () => _acreditarImplementacio(votacio),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
              const SizedBox(height: 10),
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).votesListTitle,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).votesListSubtitle(widget.buildingName),
          style: const TextStyle(color: Colors.black54, fontSize: 15),
        ),
      ],
    );
  }

  Future<void> _acreditarImplementacio(VotationModel votacio) async {
    final simulation = votacio.simulacio;
    if (simulation == null || simulation.id <= 0 || _accrediting) {
      return;
    }

    final result = await showDialog<_ImplementationAccreditationData>(
      context: context,
      builder: (_) => _ImplementationAccreditationDialog(
        initialCost: simulation.costEstimat,
      ),
    );

    if (result == null || !mounted) return;

    setState(() => _accrediting = true);

    try {
      await _service.acreditarImplementacio(
        idEdifici: widget.idEdifici,
        simulacioId: simulation.id,
        dataExecucio: result.dataExecucio,
        costReal: result.costReal,
        documentBytes: result.documentBytes,
        documentName: result.documentName,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Implementació acreditada. Queda pendent de validació.',
          ),
        ),
      );

      await _load();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _accrediting = false);
      }
    }
  }

  Future<void> _createVotacio() async {
    final result = await Navigator.push<Object>(
      context,
      MaterialPageRoute(
        builder: (_) => CrearVotacioScreen(
          idEdifici: widget.idEdifici,
          service: _legacyService,
        ),
      ),
    );
    if (result != null && mounted) _load();
  }

  void _openDetall(VotacioResumModel v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotacioDetallScreen(
          idVotacio: v.id,
          service: _legacyService,
          userRole: widget.userRole,
        ),
      ),
    ).then((_) => _load());
  }

  Widget _buildTabs() {
    final activeCount =
        _votacions.where((v) => v.isActive).length +
        _comunitats.where((v) => v.estat == 'oberta').length;
    final completedCount =
        _votacions.where((v) => v.isCompleted).length +
        _comunitats.where((v) => v.estat != 'oberta').length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabChip(
            selected: _tab == 0,
            label: AppLocalizations.of(context).votesTabActive(activeCount),
            onTap: () => setState(() => _tab = 0),
          ),
          const SizedBox(width: 8),
          _TabChip(
            selected: _tab == 1,
            label: AppLocalizations.of(
              context,
            ).votesTabCompleted(completedCount),
            onTap: () => setState(() => _tab = 1),
          ),
          const SizedBox(width: 8),
          _TabChip(
            selected: _tab == 2,
            label: _isAdmin
                ? AppLocalizations.of(context).votesTabMyProposals
                : AppLocalizations.of(context).votesTabMyVotes,
            onTap: () => setState(() => _tab = 2),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade800),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => _load(),
            child: Text(AppLocalizations.of(context).votesRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7E3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.how_to_vote_outlined,
            size: 46,
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 12),
          Text(
            _tab == 0
                ? AppLocalizations.of(context).votesEmptyActive
                : AppLocalizations.of(context).votesEmptySection,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).votesEmptyBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7E3)),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 34, color: Colors.grey.shade600),
          const SizedBox(height: 10),
          Text(
            _canVoteCommunity
                ? AppLocalizations.of(context).votesInfoCanVote
                : AppLocalizations.of(context).votesInfoCannotVote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class _VotationCard extends StatelessWidget {
  final VotationModel votacio;
  final bool voting;
  final bool accrediting;
  final bool canAccredit;
  final ValueChanged<String> onVote;
  final VoidCallback onAccredit;

  const _VotationCard({
    required this.votacio,
    required this.voting,
    required this.accrediting,
    required this.canAccredit,
    required this.onVote,
    required this.onAccredit,
  });

  @override
  Widget build(BuildContext context) {
    final simulation = votacio.simulacio;
    final days = votacio.diesRestants;
    final participation = votacio.participacioPercent.clamp(0, 100).toDouble();
    final favor = votacio.favorPercent.clamp(0, 100).toDouble();
    final contra = (100 - favor).clamp(0, 100).toDouble();
    final simulationStatus = simulation?.estatAplicacio
        .trim()
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');
    final canShowAccreditation =
        canAccredit &&
        votacio.effectiveNormalizedEstat == 'aprovada' &&
        simulation != null &&
        simulation.id > 0 &&
        simulationStatus != 'implementada';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StatusPill(label: votacio.estatLabel),
                    const Spacer(),
                    Icon(
                      votacio.isActive
                          ? Icons.schedule
                          : Icons.check_circle_outline,
                      size: 17,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      votacio.isActive
                          ? days == null
                                ? AppLocalizations.of(context).votesActive
                                : days == 0
                                ? AppLocalizations.of(context).votesEndsToday
                                : AppLocalizations.of(
                                    context,
                                  ).votesDaysRemaining(days)
                          : votacio.estatLabel,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  votacio.titol,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  votacio.descripcio.isNotEmpty
                      ? votacio.descripcio
                      : simulation?.descripcio ??
                            AppLocalizations.of(
                              context,
                            ).votesEnergyProposalFallback,
                  style: const TextStyle(color: Colors.black54, height: 1.35),
                ),
                const SizedBox(height: 14),
                _ProgressBox(
                  title: AppLocalizations.of(context).votesQuorumProgress,
                  valueLabel:
                      '${participation.toStringAsFixed(0)}% / ${votacio.quorumPercent.toStringAsFixed(0)}%',
                  value: participation / 100,
                  helper: votacio.participacioPercent >= votacio.quorumPercent
                      ? AppLocalizations.of(context).votesQuorumReached
                      : AppLocalizations.of(context).votesNeedMoreParticipation,
                ),
                const SizedBox(height: 18),
                Text(
                  AppLocalizations.of(context).votesVoteSection,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                _VoteOption(
                  title: AppLocalizations.of(context).votesFavor,
                  percent: favor,
                  selected: votacio.elMeuVot == 'favor',
                  enabled: votacio.isActive && votacio.potVotar && !voting,
                  onTap: () => onVote('favor'),
                  subtitle: simulation == null
                      ? null
                      : 'Cost estimat ${_money(context, simulation.costEstimat)} · +${simulation.estalviAnual.toStringAsFixed(0)} €/any',
                ),
                const SizedBox(height: 10),
                _VoteOption(
                  title: AppLocalizations.of(context).votesAgainst,
                  percent: contra,
                  selected: votacio.elMeuVot == 'contra',
                  enabled: votacio.isActive && votacio.potVotar && !voting,
                  onTap: () => onVote('contra'),
                  subtitle: AppLocalizations.of(context).votesKeepCurrentState,
                ),

                if (canShowAccreditation) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: accrediting ? null : onAccredit,
                      icon: accrediting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_file_outlined),
                      label: Text(
                        accrediting
                            ? 'Acreditant implementació...'
                            : 'Acreditar implementació',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Un cop acreditada, la millora quedarà pendent de validació per part de l’administrador del sistema.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7E3))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.how_to_vote_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context).votesCount(votacio.totalVots),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  votacio.hasVoted
                      ? AppLocalizations.of(
                          context,
                        ).votesYourVote(votacio.elMeuVot ?? '')
                      : AppLocalizations.of(context).votesPendingVote,
                  style: TextStyle(
                    color: votacio.hasVoted
                        ? Colors.green.shade700
                        : Colors.black45,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _money(BuildContext context, double value) {
    if (value <= 0) return AppLocalizations.of(context).votesNotReported;
    return '${value.toStringAsFixed(0)} €';
  }
}

class _ProgressBox extends StatelessWidget {
  final String title;
  final String valueLabel;
  final double value;
  final String helper;

  const _ProgressBox({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7E3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.groups_2_outlined,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(
                valueLabel,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value.clamp(0, 1),
              minHeight: 7,
              backgroundColor: Colors.green.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              helper,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoteOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double percent;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _VoteOption({
    required this.title,
    required this.percent,
    required this.selected,
    required this.enabled,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.green.shade300 : const Color(0xFFE5E7E3),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle!,
                  style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0, 1),
                minHeight: 6,
                backgroundColor: const Color(0xFFE9ECE9),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.green.shade300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;

  const _StatusPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ComunityCard extends StatelessWidget {
  final VotacioResumModel votacio;
  final VoidCallback onTap;

  const _ComunityCard({required this.votacio, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOberta = votacio.estat == 'oberta';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7E3)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.04),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isOberta ? Colors.green.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isOberta
                    ? AppLocalizations.of(context).votesStatusOpen
                    : _formatEstat(context, votacio.estat),
                style: TextStyle(
                  color: isOberta
                      ? Colors.green.shade700
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                votacio.titol,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context).votesCount(votacio.numVotsTotal),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black38,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatEstat(BuildContext context, String estat) {
    switch (estat) {
      case 'tancada':
        return AppLocalizations.of(context).votesStatusClosed;
      case 'arxivada':
        return AppLocalizations.of(context).votesStatusArchived;
      default:
        return estat;
    }
  }
}

class _TabChip extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _TabChip({
    required this.selected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.green : const Color(0xFFDADDD8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ImplementationAccreditationData {
  final String dataExecucio;
  final double costReal;
  final List<int> documentBytes;
  final String documentName;

  const _ImplementationAccreditationData({
    required this.dataExecucio,
    required this.costReal,
    required this.documentBytes,
    required this.documentName,
  });
}

class _ImplementationAccreditationDialog extends StatefulWidget {
  final double initialCost;

  const _ImplementationAccreditationDialog({required this.initialCost});

  @override
  State<_ImplementationAccreditationDialog> createState() =>
      _ImplementationAccreditationDialogState();
}

class _ImplementationAccreditationDialogState
    extends State<_ImplementationAccreditationDialog> {
  late final TextEditingController _dateController;
  late final TextEditingController _costController;

  PlatformFile? _file;
  String? _error;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    _dateController = TextEditingController(text: today);
    _costController = TextEditingController(
      text: widget.initialCost > 0 ? widget.initialCost.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
    );

    if (result == null || result.files.isEmpty) return;

    setState(() {
      _file = result.files.single;
      _error = null;
    });
  }

  void _submit() {
    final cost = double.tryParse(
      _costController.text.trim().replaceAll(',', '.'),
    );

    if (_dateController.text.trim().isEmpty) {
      setState(() => _error = 'Introdueix la data d’execució.');
      return;
    }

    if (cost == null || cost <= 0) {
      setState(() => _error = 'Introdueix un cost real vàlid.');
      return;
    }

    final file = _file;
    final bytes = file?.bytes;

    if (file == null || bytes == null || bytes.isEmpty) {
      setState(() => _error = 'Adjunta un document d’evidència.');
      return;
    }

    Navigator.pop(
      context,
      _ImplementationAccreditationData(
        dataExecucio: _dateController.text.trim(),
        costReal: cost,
        documentBytes: bytes,
        documentName: file.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Acreditar implementació'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Aporta la informació real de la millora executada. Quedarà pendent de validació per l’administrador del sistema.',
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Data d’execució',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cost real (€)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: Text(_file == null ? 'Adjuntar evidència' : _file!.name),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel·lar'),
        ),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.upload_file_outlined),
          label: const Text('Acreditar'),
        ),
      ],
    );
  }
}
