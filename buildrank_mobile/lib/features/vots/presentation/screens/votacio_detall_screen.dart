import 'package:flutter/material.dart';

import '../../data/votacions_model.dart';
import '../../data/votacions_service.dart';
import 'editar_votacio_screen.dart';

class VotacioDetallScreen extends StatefulWidget {
  final int idVotacio;
  final VotacionsService service;
  final String userRole;

  const VotacioDetallScreen({
    super.key,
    required this.idVotacio,
    required this.service,
    required this.userRole,
  });

  @override
  State<VotacioDetallScreen> createState() => _VotacioDetallScreenState();
}

class _VotacioDetallScreenState extends State<VotacioDetallScreen> {
  VotacioDetallModel? _votacio;
  ResultatsVotacioModel? _resultats;
  bool _isLoading = true;
  bool _isVoting = false;
  String? _errorText;
  int? _selectedOpcioId;
  bool _showResults = false;

  bool get _canManage =>
      widget.userRole == 'admin' || widget.userRole == 'owner';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      final votacio = await widget.service.getVotacioDetall(
        id: widget.idVotacio,
      );
      ResultatsVotacioModel? resultats;
      if (votacio.haVotat || votacio.estat != 'oberta') {
        resultats = await widget.service.getResultats(id: widget.idVotacio);
      }
      if (mounted) {
        setState(() {
          _votacio = votacio;
          _resultats = resultats;
          _showResults = votacio.haVotat || votacio.estat != 'oberta';
          _isLoading = false;
        });
      }
    } on VotacionsApiException catch (e) {
      if (mounted) {
        setState(() {
          _errorText = e.message;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _votar() async {
    final opcioId = _selectedOpcioId;
    if (opcioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una opció per votar.')),
      );
      return;
    }
    setState(() => _isVoting = true);
    try {
      await widget.service.votar(idVotacio: widget.idVotacio, opcioId: opcioId);
      final resultats = await widget.service.getResultats(id: widget.idVotacio);
      if (mounted) {
        setState(() {
          _resultats = resultats;
          _showResults = true;
          _isVoting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vot registrat correctament.')),
        );
      }
    } on VotacionsApiException catch (e) {
      if (mounted) {
        setState(() => _isVoting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _loadResultats() async {
    try {
      final resultats = await widget.service.getResultats(id: widget.idVotacio);
      if (mounted) {
        setState(() {
          _resultats = resultats;
          _showResults = true;
        });
      }
    } on VotacionsApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _openEditar() async {
    final votacio = _votacio;
    if (votacio == null) return;
    final updated = await Navigator.push<VotacioDetallModel>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditarVotacioScreen(votacio: votacio, service: widget.service),
      ),
    );
    if (updated != null && mounted) {
      ResultatsVotacioModel? resultats;
      if (updated.haVotat || updated.estat != 'oberta') {
        try {
          resultats = await widget.service.getResultats(id: updated.id);
        } catch (_) {}
      }
      setState(() {
        _votacio = updated;
        _resultats = resultats;
        _showResults = updated.haVotat || updated.estat != 'oberta';
        _selectedOpcioId = null;
      });
    }
  }

  Future<void> _confirmarEliminar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar votació'),
        content: const Text(
          'Segur que vols eliminar aquesta votació? S\'esborraran totes les opcions i vots emesos. Aquesta acció no es pot desfer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel·lar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red[700]),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await widget.service.eliminarVotacio(id: widget.idVotacio);
      if (mounted) Navigator.of(context).pop(true);
    } on VotacionsApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _votacio?.titol ?? 'Votació',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        actions: [
          if (_canManage)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'editar') _openEditar();
                if (value == 'eliminar') _confirmarEliminar();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'editar',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 10),
                      Text('Editar'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'eliminar',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Eliminar',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorText != null) {
      return _buildError();
    }
    final votacio = _votacio!;
    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(votacio),
            const SizedBox(height: 16),
            if (votacio.descripcio != null) ...[
              _buildDescripcio(votacio.descripcio!),
              const SizedBox(height: 16),
            ],
            if (_showResults && _resultats != null)
              _buildResultats(_resultats!)
            else
              _buildVoteOptions(votacio),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _load,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
              child: const Text(
                'Torna-ho a provar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(VotacioDetallModel votacio) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _estatBadge(votacio.estat),
                const Spacer(),
                Text(
                  '${votacio.numVotsTotal} vot${votacio.numVotsTotal == 1 ? '' : 's'}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              votacio.titol,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (votacio.dataLimit != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Fins al ${_formatDate(votacio.dataLimit!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDescripcio(String text) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
      ),
    );
  }

  Widget _buildVoteOptions(VotacioDetallModel votacio) {
    final canVote = votacio.estat == 'oberta' && !votacio.haVotat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          canVote ? 'Selecciona una opció' : 'Opcions',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...votacio.opcions.map((opcio) => _buildOpcioTile(opcio, canVote)),
        if (canVote) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isVoting ? null : _votar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isVoting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Votar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        ],
        if (!canVote && votacio.estat == 'oberta' && votacio.haVotat) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _loadResultats,
            icon: Icon(Icons.bar_chart, color: Colors.green[700]),
            label: Text(
              'Veure resultats',
              style: TextStyle(color: Colors.green[700]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOpcioTile(OpcioVotModel opcio, bool canVote) {
    final isSelected = _selectedOpcioId == opcio.id;
    return GestureDetector(
      onTap: canVote ? () => setState(() => _selectedOpcioId = opcio.id) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (canVote)
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? Colors.green[700] : Colors.grey[400],
                size: 20,
              ),
            if (canVote) const SizedBox(width: 10),
            Expanded(
              child: Text(opcio.text, style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultats(ResultatsVotacioModel resultats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resultats',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...resultats.opcions.map(
          (opcio) => _buildResultatBar(opcio, resultats.numVotsTotal),
        ),
        const SizedBox(height: 8),
        Text(
          'Total: ${resultats.numVotsTotal} vot${resultats.numVotsTotal == 1 ? '' : 's'}',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildResultatBar(OpcioResultatModel opcio, int total) {
    final pct = total > 0 ? opcio.percentatge / 100.0 : 0.0;
    final isWinner =
        total > 0 &&
        opcio.numVots > 0 &&
        opcio.numVots ==
            _resultats!.opcions
                .map((o) => o.numVots)
                .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  opcio.text,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isWinner ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              Text(
                '${opcio.percentatge.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isWinner ? FontWeight.w600 : FontWeight.normal,
                  color: isWinner ? Colors.green[700] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                isWinner ? Colors.green[600]! : Colors.green[300]!,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${opcio.numVots} vot${opcio.numVots == 1 ? '' : 's'}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _estatBadge(String estat) {
    Color color;
    String label;
    switch (estat) {
      case 'oberta':
        color = Colors.green[700]!;
        label = 'Oberta';
        break;
      case 'tancada':
        color = Colors.grey[600]!;
        label = 'Tancada';
        break;
      default:
        color = Colors.red[600]!;
        label = 'Cancel·lada';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
