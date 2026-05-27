import 'package:buildrank_mobile/features/xat/data/twin_building_model.dart';
import 'package:buildrank_mobile/features/xat/data/twin_building_service.dart';
import 'package:buildrank_mobile/features/xat/presentation/screens/direct_channel_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TwinBuildingAdminsScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingName;

  const TwinBuildingAdminsScreen({
    super.key,
    required this.idEdifici,
    required this.buildingName,
  });

  @override
  State<TwinBuildingAdminsScreen> createState() =>
      _TwinBuildingAdminsScreenState();
}

class _TwinBuildingAdminsScreenState extends State<TwinBuildingAdminsScreen> {
  final _service = TwinBuildingService();

  bool _loading = true;
  int? _creatingFor;
  String? _error;
  List<TwinBuildingAdminCandidate> _candidates = [];

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
      final results = await _service.getCandidates(widget.idEdifici);
      if (!mounted) return;
      setState(() => _candidates = results);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openChannel(TwinBuildingAdminCandidate candidate) async {
    if (_creatingFor != null) return;

    setState(() => _creatingFor = candidate.edificiId);

    try {
      final l10n = AppLocalizations.of(context);
      final channel = await _service.createChannel(
        idEdifici: widget.idEdifici,
        targetEdificiId: candidate.edificiId,
      );

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DirectChannelScreen(
            channelId: channel.streamChannelId,
            channelName: channel.name.isNotEmpty
                ? channel.name
                : l10n.twinChannelName(candidate.adreca),
            channelType: channel.type,
            description: l10n.twinChannelDescription(
              candidate.admin.name,
              candidate.adreca,
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _creatingFor = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F5),
      appBar: AppBar(
        title: Text(l10n.twinTitle),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildIntro(l10n),
            const SizedBox(height: 16),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _buildError(l10n)
            else if (_candidates.isEmpty)
              _buildEmpty(l10n)
            else
              for (final candidate in _candidates) ...[
                _CandidateCard(
                  candidate: candidate,
                  loading: _creatingFor == candidate.edificiId,
                  onOpen: () => _openChannel(candidate),
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildIntro(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.twinIntroTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.twinIntroBody(widget.buildingName),
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n) {
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
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: _load, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7E3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.apartment_outlined, size: 44, color: Colors.black45),
          const SizedBox(height: 12),
          Text(
            l10n.twinEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.twinEmptyBody,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  final TwinBuildingAdminCandidate candidate;
  final bool loading;
  final VoidCallback onOpen;

  const _CandidateCard({
    required this.candidate,
    required this.loading,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7E3)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green.shade50,
                child: Icon(Icons.apartment, color: Colors.green.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.adreca,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      candidate.barri.isNotEmpty
                          ? '${candidate.barri} · ${candidate.codiPostal}'
                          : candidate.codiPostal,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.twinPoints(candidate.puntuacioBase.toStringAsFixed(0)),
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MiniChip(
                label: candidate.tipologia.isEmpty
                    ? l10n.twinTypologyFallback
                    : candidate.tipologia,
              ),
              _MiniChip(
                label: '${candidate.superficieTotal.toStringAsFixed(0)} m²',
              ),
              if (candidate.zonaClimatica.isNotEmpty)
                _MiniChip(label: l10n.twinClimateZone(candidate.zonaClimatica)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.twinAdminLine(candidate.admin.name),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: loading ? null : onOpen,
                icon: loading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chat_bubble_outline, size: 18),
                label: Text(l10n.twinOpenChat),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;

  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }
}
