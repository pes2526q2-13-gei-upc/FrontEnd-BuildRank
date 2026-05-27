import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../data/notification_model.dart';
import '../../data/notifications_service.dart';
import '../../../vots/data/votacions_service.dart';
import '../../../vots/presentation/screens/votacio_detall_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final String userRole;
  final VoidCallback? onBadgeUpdate;
  final NotificacionsService? notificacionsService;

  const NotificationsScreen({
    super.key,
    required this.userRole,
    this.onBadgeUpdate,
    this.notificacionsService,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificacionsService _service;
  final _votacionsService = VotacionsService();

  List<NotificacioModel> _notificacions = [];
  bool _loading = true;
  String? _error;
  bool _markingAll = false;

  @override
  void initState() {
    super.initState();
    _service = widget.notificacionsService ?? NotificacionsService();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _service.getNotificacions();
      if (mounted) setState(() => _notificacions = data);
    } on NotificacionsApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() => _error = l10n.notificationsLoadError);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _marcarLlegida(NotificacioModel notificacio) async {
    if (notificacio.llegida) return;

    try {
      await _service.marcarLlegida(notificacio.id);
      if (!mounted) return;
      setState(() {
        final idx = _notificacions.indexWhere((n) => n.id == notificacio.id);
        if (idx != -1) {
          _notificacions[idx] = _notificacions[idx].copyWith(llegida: true);
        }
      });
      widget.onBadgeUpdate?.call();
    } catch (_) {}
  }

  Future<void> _marcarTotes() async {
    if (_markingAll) return;
    setState(() => _markingAll = true);

    try {
      await _service.marcarTotesLlegides();
      if (!mounted) return;
      setState(() {
        _notificacions = _notificacions
            .map((n) => n.copyWith(llegida: true))
            .toList();
      });
      widget.onBadgeUpdate?.call();
    } on NotificacionsApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _markingAll = false);
    }
  }

  Future<void> _onTap(NotificacioModel notificacio) async {
    await _marcarLlegida(notificacio);
    if (!mounted) return;
    _navegarA(notificacio);
  }

  void _navegarA(NotificacioModel notificacio) {
    final id = notificacio.objecteId;
    if (id == null) return;

    const tipusVotacio = {
      'nova_votacio',
      'votacio_tancada',
      'votacio_cancellada',
    };

    if (tipusVotacio.contains(notificacio.tipus)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VotacioDetallScreen(
            idVotacio: id,
            service: _votacionsService,
            userRole: widget.userRole,
          ),
        ),
      );
    }
  }

  bool get _hiHaNoLlegides => _notificacions.any((n) => !n.llegida);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          if (_hiHaNoLlegides)
            _markingAll
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _marcarTotes,
                    child: Text(l10n.notificationsMarkAll),
                  ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: Text(l10n.commonRetry)),
          ],
        ),
      );
    }

    if (_notificacions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              l10n.notificationsEmpty,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        itemCount: _notificacions.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) => _NotificacioTile(
          notificacio: _notificacions[index],
          onTap: () => _onTap(_notificacions[index]),
        ),
      ),
    );
  }
}

class _NotificacioTile extends StatelessWidget {
  final NotificacioModel notificacio;
  final VoidCallback onTap;

  const _NotificacioTile({required this.notificacio, required this.onTap});

  IconData get _icon {
    return switch (notificacio.tipus) {
      'nova_votacio' => Icons.how_to_vote_outlined,
      'votacio_tancada' => Icons.lock_outline,
      'votacio_cancellada' => Icons.cancel_outlined,
      _ => Icons.notifications_outlined,
    };
  }

  String _formatData(BuildContext context, DateTime dt) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return l10n.notificationsNow;
    if (diff.inHours < 1) return l10n.notificationsMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.notificationsHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.notificationsDaysAgo(diff.inDays);

    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final llegida = notificacio.llegida;
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: llegida ? null : color.primary.withValues(alpha: 0.06),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: llegida
                    ? Colors.grey.withValues(alpha: 0.12)
                    : color.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icon,
                size: 20,
                color: llegida ? Colors.grey : color.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notificacio.titol,
                          style: TextStyle(
                            fontWeight: llegida
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!llegida)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8, top: 4),
                          decoration: BoxDecoration(
                            color: color.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (notificacio.cos.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      notificacio.cos,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatData(context, notificacio.dataCreacio),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
