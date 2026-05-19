import 'package:buildrank_mobile/features/vots/data/votation_model.dart';
import 'package:buildrank_mobile/features/vots/data/votation_service.dart';
import 'package:flutter/material.dart';

class VotacionsScreen extends StatefulWidget {
  final int idEdifici;
  final String userRole;
  final String buildingName;

  const VotacionsScreen({
    super.key,
    required this.idEdifici,
    required this.userRole,
    required this.buildingName,
  });

  @override
  State<VotacionsScreen> createState() => _VotacionsScreenState();
}

class _VotacionsScreenState extends State<VotacionsScreen> {
  final _service = VotationService();

  bool _loading = true;
  bool _voting = false;
  String? _error;
  int _tab = 0;
  List<VotationModel> _votacions = [];

  bool get _isAdmin => widget.userRole == 'admin';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final votacions = await _service.getVotacions(widget.idEdifici);
      if (!mounted) return;
      setState(() => _votacions = votacions);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                ? 'Vot a favor registrat.'
                : 'Vot en contra registrat.',
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
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
              else if (_filtered.isEmpty)
                _buildEmpty()
              else
                for (final votacio in _filtered) ...[
                  _VotationCard(
                    votacio: votacio,
                    voting: _voting,
                    onVote: (sentit) => _vote(votacio, sentit),
                  ),
                  const SizedBox(height: 14),
                ],
              const SizedBox(height: 10),
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Votació interna',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: 'Presa de decisions per ',
            style: const TextStyle(color: Colors.black54, fontSize: 15),
            children: [
              TextSpan(
                text: widget.buildingName,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    final activeCount = _votacions.where((v) => v.isActive).length;
    final completedCount = _votacions.where((v) => v.isCompleted).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabChip(
            selected: _tab == 0,
            label: 'Actiu ($activeCount)',
            onTap: () => setState(() => _tab = 0),
          ),
          const SizedBox(width: 8),
          _TabChip(
            selected: _tab == 1,
            label: 'Completat ($completedCount)',
            onTap: () => setState(() => _tab = 1),
          ),
          const SizedBox(width: 8),
          _TabChip(
            selected: _tab == 2,
            label: _isAdmin ? 'Les meves propostes' : 'Les meves votacions',
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
            onPressed: _load,
            child: const Text('Torna-ho a provar'),
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
                ? 'No hi ha votacions actives ara mateix.'
                : 'No hi ha votacions en aquesta secció.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Quan l’administrador sotmeti una simulació a votació, apareixerà aquí.',
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
          const Text(
            'Només els propietaris i administradors poden votar propostes de millora.',
            textAlign: TextAlign.center,
            style: TextStyle(
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
  final ValueChanged<String> onVote;

  const _VotationCard({
    required this.votacio,
    required this.voting,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final simulation = votacio.simulacio;
    final days = votacio.diesRestants;
    final participation = votacio.participacioPercent.clamp(0, 100).toDouble();
    final favor = votacio.favorPercent.clamp(0, 100).toDouble();
    final contra = (100 - favor).clamp(0, 100).toDouble();

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
                                ? 'Activa'
                                : days == 0
                                ? 'Finalitza avui'
                                : '$days dies restants'
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
                            'Proposta de millora energètica.',
                  style: const TextStyle(color: Colors.black54, height: 1.35),
                ),
                const SizedBox(height: 14),
                _ProgressBox(
                  title: 'Progrés del quòrum',
                  valueLabel:
                      '${participation.toStringAsFixed(0)}% / ${votacio.quorumPercent.toStringAsFixed(0)}%',
                  value: participation / 100,
                  helper: votacio.participacioPercent >= votacio.quorumPercent
                      ? 'Quòrum assolit'
                      : 'Cal més participació',
                ),
                const SizedBox(height: 18),
                const Text(
                  'VOTA',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                _VoteOption(
                  title: 'A favor',
                  percent: favor,
                  selected: votacio.elMeuVot == 'favor',
                  enabled: votacio.isActive && votacio.potVotar && !voting,
                  onTap: () => onVote('favor'),
                  subtitle: simulation == null
                      ? null
                      : 'Cost estimat ${_money(simulation.costEstimat)} · +${simulation.estalviAnual.toStringAsFixed(0)} €/any',
                ),
                const SizedBox(height: 10),
                _VoteOption(
                  title: 'En contra',
                  percent: contra,
                  selected: votacio.elMeuVot == 'contra',
                  enabled: votacio.isActive && votacio.potVotar && !voting,
                  onTap: () => onVote('contra'),
                  subtitle: 'Mantenir l’estat actual',
                ),
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
                  '${votacio.totalVots} vots',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  votacio.hasVoted
                      ? 'El teu vot: ${votacio.elMeuVot}'
                      : 'Pendent de vot',
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

  static String _money(double value) {
    if (value <= 0) return 'no informat';
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
