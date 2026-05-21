import 'package:buildrank_mobile/features/buildingRequests/data/pending_building_requests_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PendingBuildingRequestsScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingTitle;
  final String userRole;
  final PendingBuildingRequestsService requestsService;

  const PendingBuildingRequestsScreen({
    super.key,
    required this.idEdifici,
    required this.buildingTitle,
    required this.userRole,
    this.requestsService = const PendingBuildingRequestsService(),
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
      _loadRequests();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final requests = await widget.requestsService.getPendingRequests(
        idEdifici: widget.idEdifici,
      );

      if (!mounted) return;

      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(PendingBuildingRequestItem item) async {
    setState(() {
      _processingRequestId = item.id;
      _processingAction = 'accept';
    });

    try {
      await widget.requestsService.validateRequest(
        referenciaCadastral: item.refCadastral,
        accepted: true,
      );

      if (!mounted) return;

      setState(() {
        _requests.removeWhere((request) => request.id == item.id);
        _processingRequestId = null;
        _processingAction = null;
      });

      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pendingRequestsAccepted(item.requesterName)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _processingRequestId = null;
        _processingAction = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _rejectRequest(PendingBuildingRequestItem item) async {
    setState(() {
      _processingRequestId = item.id;
      _processingAction = 'reject';
    });

    try {
      await widget.requestsService.validateRequest(
        referenciaCadastral: item.refCadastral,
        accepted: false,
      );

      if (!mounted) return;

      setState(() {
        _requests.removeWhere((request) => request.id == item.id);
        _processingRequestId = null;
        _processingAction = null;
      });

      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pendingRequestsRejected(item.requesterName)),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _processingRequestId = null;
        _processingAction = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(title: Text(l10n.pendingRequestsTitle), centerTitle: true),
      body: !_isAdmin
          ? _buildForbiddenState(l10n)
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorText != null
          ? _buildErrorState(l10n)
          : RefreshIndicator(
              onRefresh: _loadRequests,
              child: _requests.isEmpty
                  ? _buildEmptyState(l10n)
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildHeaderCard(l10n),
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

  Widget _buildHeaderCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.pendingRequestsTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.pendingRequestsIntro(widget.buildingTitle),
            style: const TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.pendingRequestsCount(_requests.length),
            style: const TextStyle(
              color: Color(0xFF166534),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(l10n),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.verified_outlined,
                size: 42,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.pendingRequestsEmptyTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.pendingRequestsEmptyBody,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              _errorText ?? l10n.pendingRequestsUnexpectedError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRequests,
              child: Text(l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForbiddenState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              l10n.pendingRequestsForbidden,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.4),
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
    final l10n = AppLocalizations.of(context);
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
              _RequestTypeChip(label: l10n.pendingRequestsResidentChip),
            ],
          ),
          const SizedBox(height: 14),
          _InfoRow(
            label: l10n.pendingRequestsRequestTypeLabel,
            value: l10n.pendingRequestsResidentJoinType,
          ),
          _InfoRow(
            label: l10n.pendingRequestsDateLabel,
            value: _formatDate(item.submittedAt),
          ),
          _InfoRow(
            label: l10n.pendingRequestsCadastralReferenceLabel,
            value: item.refCadastral,
          ),
          _InfoRow(
            label: l10n.pendingRequestsHomeLabel,
            value: _buildHabitatgeLabel(context, item),
          ),
          if (item.superficie != null)
            _InfoRow(
              label: l10n.pendingRequestsSurfaceLabel,
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
                      : Text(
                          l10n.pendingRequestsReject,
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
                      : Text(
                          l10n.pendingRequestsAccept,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildHabitatgeLabel(
    BuildContext context,
    PendingBuildingRequestItem item,
  ) {
    final l10n = AppLocalizations.of(context);
    final planta = item.planta?.trim();
    final porta = item.porta?.trim();

    if ((planta == null || planta.isEmpty) &&
        (porta == null || porta.isEmpty)) {
      return l10n.pendingRequestsNotSpecified;
    }

    if (planta != null &&
        planta.isNotEmpty &&
        porta != null &&
        porta.isNotEmpty) {
      return l10n.pendingRequestsFloorDoor(planta, porta);
    }

    if (planta != null && planta.isNotEmpty) {
      return l10n.pendingRequestsFloor(planta);
    }

    return l10n.pendingRequestsDoor(porta ?? '');
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

String _formatDate(DateTime date) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final day = twoDigits(date.day);
  final month = twoDigits(date.month);
  final year = date.year;
  final hour = twoDigits(date.hour);
  final minute = twoDigits(date.minute);

  return '$day/$month/$year · $hour:$minute';
}
