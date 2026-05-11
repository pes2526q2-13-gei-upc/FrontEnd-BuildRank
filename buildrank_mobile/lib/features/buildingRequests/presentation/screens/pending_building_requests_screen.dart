import 'package:flutter/material.dart';

class PendingBuildingRequestsScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingTitle;
  final String userRole;

  const PendingBuildingRequestsScreen({
    super.key,
    required this.idEdifici,
    required this.buildingTitle,
    required this.userRole,
  });

  @override
  State<PendingBuildingRequestsScreen> createState() =>
      _PendingBuildingRequestsScreenState();
}

class _PendingBuildingRequestsScreenState
    extends State<PendingBuildingRequestsScreen> {
  bool _isLoading = true;
  String? _errorText;
  int? _processingRequestId;
  String? _processingAction;

  List<PendingBuildingRequestItem> _requests = [];

  bool get _isAdmin => widget.userRole == 'admin';

  @override
  void initState() {
    super.initState();

    if (_isAdmin) {
      _loadMockRequests();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadMockRequests() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;

    try {
      setState(() {
        _requests = [
          PendingBuildingRequestItem(
            id: 101,
            requesterName: 'Laia Pons',
            requesterEmail: 'laia.pons@mail.com',
            refCadastral: '1234567DF3813A0001AB',
            planta: '2',
            porta: '1',
            superficie: 86.5,
            submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          PendingBuildingRequestItem(
            id: 102,
            requesterName: 'Marc Serra',
            requesterEmail: 'marc.serra@mail.com',
            refCadastral: '1234567DF3813A0002CD',
            planta: '3',
            porta: '2',
            superficie: 79.0,
            submittedAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorText = 'No s’han pogut carregar les sol·licituds pendents.';
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(PendingBuildingRequestItem item) async {
    setState(() {
      _processingRequestId = item.id;
      _processingAction = 'accept';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _requests.removeWhere((request) => request.id == item.id);
      _processingRequestId = null;
      _processingAction = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('S’ha acceptat la sol·licitud de ${item.requesterName}.'),
      ),
    );
  }

  Future<void> _rejectRequest(PendingBuildingRequestItem item) async {
    setState(() {
      _processingRequestId = item.id;
      _processingAction = 'reject';
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      _requests.removeWhere((request) => request.id == item.id);
      _processingRequestId = null;
      _processingAction = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('S’ha rebutjat la sol·licitud de ${item.requesterName}.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        title: const Text('Sol·licituds pendents'),
        centerTitle: true,
      ),
      body: !_isAdmin
          ? _buildForbiddenState()
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorText != null
          ? _buildErrorState()
          : RefreshIndicator(
              onRefresh: _loadMockRequests,
              child: _requests.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildHeaderCard(),
                        const SizedBox(height: 18),
                        ..._requests.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _PendingRequestCard(
                              item: item,
                              isProcessing: _processingRequestId == item.id,
                              processingAction: _processingAction,
                              onAccept: () => _acceptRequest(item),
                              onReject: () => _rejectRequest(item),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sol·licituds pendents',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Aquí pots revisar i validar les sol·licituds d’unió com a resident per a ${widget.buildingTitle}.',
            style: const TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 12),
          Text(
            '${_requests.length} pendents',
            style: const TextStyle(
              color: Color(0xFF166534),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Column(
            children: [
              Icon(Icons.verified_outlined, size: 42, color: Colors.green),
              SizedBox(height: 12),
              Text(
                'No hi ha sol·licituds pendents',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Quan altres usuaris demanin unir-se a aquest edifici, apareixeran aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              _errorText ?? 'S’ha produït un error inesperat.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMockRequests,
              child: const Text('Torna-ho a provar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForbiddenState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 42),
            SizedBox(height: 12),
            Text(
              'Només l’administrador de finca pot gestionar les sol·licituds pendents.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  final PendingBuildingRequestItem item;
  final bool isProcessing;
  final String? processingAction;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _PendingRequestCard({
    required this.item,
    required this.isProcessing,
    required this.processingAction,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isAccepting = isProcessing && processingAction == 'accept';
    final isRejecting = isProcessing && processingAction == 'reject';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person_outline)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.requesterName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.requesterEmail,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const _RequestTypeChip(label: 'Resident'),
            ],
          ),
          const SizedBox(height: 14),
          _InfoRow(label: 'Tipus de sol·licitud', value: 'Unió com a resident'),
          _InfoRow(label: 'Data', value: _formatDate(item.submittedAt)),
          _InfoRow(label: 'Referència cadastral', value: item.refCadastral),
          _InfoRow(label: 'Habitatge', value: _buildHabitatgeLabel(item)),
          if (item.superficie != null)
            _InfoRow(
              label: 'Superfície',
              value: '${item.superficie!.toStringAsFixed(1)} m²',
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isProcessing ? null : onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isRejecting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Rebutjar',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: isProcessing ? null : onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isAccepting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Acceptar',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildHabitatgeLabel(PendingBuildingRequestItem item) {
    final planta = item.planta?.trim();
    final porta = item.porta?.trim();

    if ((planta == null || planta.isEmpty) &&
        (porta == null || porta.isEmpty)) {
      return 'No especificat';
    }

    if (planta != null &&
        planta.isNotEmpty &&
        porta != null &&
        porta.isNotEmpty) {
      return 'Planta $planta · Porta $porta';
    }

    if (planta != null && planta.isNotEmpty) {
      return 'Planta $planta';
    }

    return 'Porta ${porta ?? ''}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestTypeChip extends StatelessWidget {
  final String label;

  const _RequestTypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFFEAF8EE),
      side: const BorderSide(color: Color(0xFF86EFAC)),
      labelStyle: const TextStyle(
        color: Color(0xFF166534),
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    );
  }
}

enum BuildingRequestType { resident, administrator }

class PendingBuildingRequestItem {
  final int id;
  final String requesterName;
  final String requesterEmail;
  final String refCadastral;
  final String? planta;
  final String? porta;
  final double? superficie;
  final DateTime submittedAt;

  const PendingBuildingRequestItem({
    required this.id,
    required this.requesterName,
    required this.requesterEmail,
    required this.refCadastral,
    required this.planta,
    required this.porta,
    required this.superficie,
    required this.submittedAt,
  });
}

String _formatDate(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final day = twoDigits(date.day);
  final month = twoDigits(date.month);
  final year = date.year;
  final hour = twoDigits(date.hour);
  final minute = twoDigits(date.minute);

  return '$day/$month/$year · $hour:$minute';
}
