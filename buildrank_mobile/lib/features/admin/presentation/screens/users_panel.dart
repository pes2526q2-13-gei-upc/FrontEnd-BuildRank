import 'package:buildrank_mobile/features/admin/data/admin_user.dart';
import 'package:buildrank_mobile/features/admin/data/user_management_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class UsersPanel extends StatefulWidget {
  const UsersPanel({super.key});

  @override
  State<UsersPanel> createState() => _UsersPanelState();
}

class _UsersPanelState extends State<UsersPanel> {
  final _service = UserManagementService();

  List<AdminUser>? _users;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await _service.getUsers();
      if (mounted) {
        setState(() {
          _users = users;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  Future<void> _blockUser(AdminUser user) async {
    final l10n = AppLocalizations.of(context);

    try {
      final updated = await _service.blockUser(user.id);
      _replaceUser(updated);
      _showSnack(l10n.adminUsersBlockedSnack(user.email));
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  Future<void> _unblockUser(AdminUser user) async {
    final l10n = AppLocalizations.of(context);

    try {
      final updated = await _service.unblockUser(user.id);
      _replaceUser(updated);
      _showSnack(l10n.adminUsersUnblockedSnack(user.email));
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  Future<void> _showSuspendDialog(AdminUser user) async {
    final l10n = AppLocalizations.of(context);
    final reasonController = TextEditingController();
    DateTime? selectedDate;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Text(
            AppLocalizations.of(context).adminUsersSuspendTitle(user.email),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).adminUsersReasonLabel,
                  border: OutlineInputBorder(),
                  hintText: AppLocalizations.of(context).adminUsersReasonHint,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? AppLocalizations.of(
                              context,
                            ).adminUsersIndefiniteSuspension
                          : AppLocalizations.of(
                              context,
                            ).adminUsersUntilDate(_formatDate(selectedDate!)),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(AppLocalizations.of(context).adminUsersEndDate),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 7),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                  ),
                  if (selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      tooltip: AppLocalizations.of(
                        context,
                      ).adminUsersRemoveDate,
                      onPressed: () =>
                          setDialogState(() => selectedDate = null),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(AppLocalizations.of(context).commonCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context).adminUsersConfirm),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final updated = await _service.suspendUser(
        user.id,
        reason: reasonController.text.trim().isEmpty
            ? null
            : reasonController.text.trim(),
        suspendedUntil: selectedDate,
      );
      _replaceUser(updated);
      _showSnack(l10n.adminUsersSuspendedSnack(user.email));
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  Future<void> _unsuspendUser(AdminUser user) async {
    final l10n = AppLocalizations.of(context);

    try {
      final updated = await _service.unsuspendUser(user.id);
      _replaceUser(updated);
      _showSnack(l10n.adminUsersUnsuspendedSnack(user.email));
    } catch (e) {
      _showSnack(e.toString().replaceFirst('Exception: ', ''), isError: true);
    }
  }

  void _replaceUser(AdminUser updated) {
    if (!mounted) return;
    setState(() {
      final index = _users?.indexWhere((u) => u.id == updated.id) ?? -1;
      if (index != -1) _users![index] = updated;
    });
  }

  void _showSnack(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFDC2626) : null,
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E6EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).adminUsersTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _loading
                        ? '...'
                        : AppLocalizations.of(
                            context,
                          ).adminUsersCount(_users?.length ?? 0),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EA)),
          _buildBody(),
          _buildRefreshButton(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(28),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF19C463)),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Color(0xFFDC2626)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final users = _users ?? [];
    if (users.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          AppLocalizations.of(context).adminUsersEmpty,
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
      );
    }

    return Column(
      children: [
        for (final user in users)
          _UserTile(
            user: user,
            onBlock: () => _blockUser(user),
            onUnblock: () => _unblockUser(user),
            onSuspend: () => _showSuspendDialog(user),
            onUnsuspend: () => _unsuspendUser(user),
          ),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return InkWell(
      onTap: _loadUsers,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).adminUsersRefreshList,
              style: const TextStyle(
                color: Color(0xFF19C463),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.refresh, size: 17, color: Color(0xFF19C463)),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final AdminUser user;
  final VoidCallback onBlock;
  final VoidCallback onUnblock;
  final VoidCallback onSuspend;
  final VoidCallback onUnsuspend;

  const _UserTile({
    required this.user,
    required this.onBlock,
    required this.onUnblock,
    required this.onSuspend,
    required this.onUnsuspend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E9ED))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.fullName.isNotEmpty
                          ? '${user.fullName} · ${user.roleLabel}'
                          : user.roleLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _AccountStatusBadge(status: user.accountStatus),
            ],
          ),
          if (user.isSuspended && user.suspensionReason.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(
                context,
              ).adminUsersReason(user.suspensionReason),
              style: const TextStyle(fontSize: 11, color: Color(0xFF92400E)),
            ),
          ],
          if (user.isSuspended && user.suspendedUntil != null) ...[
            const SizedBox(height: 2),
            Text(
              AppLocalizations.of(
                context,
              ).adminUsersUntilDate(_formatIsoDate(user.suspendedUntil!)),
              style: const TextStyle(fontSize: 11, color: Color(0xFF92400E)),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _actionButtons(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _actionButtons(BuildContext context) {
    if (user.isActiveStatus) {
      return [
        _ActionChip(
          label: AppLocalizations.of(context).adminUsersBlock,
          color: const Color(0xFFDC2626),
          onTap: onBlock,
        ),
        const SizedBox(width: 8),
        _ActionChip(
          label: AppLocalizations.of(context).adminUsersSuspend,
          color: const Color(0xFFD97706),
          onTap: onSuspend,
        ),
      ];
    }
    if (user.isBlocked) {
      return [
        _ActionChip(
          label: AppLocalizations.of(context).adminUsersUnblock,
          color: const Color(0xFF19C463),
          onTap: onUnblock,
        ),
      ];
    }
    if (user.isSuspended) {
      return [
        _ActionChip(
          label: AppLocalizations.of(context).adminUsersUnsuspend,
          color: const Color(0xFF19C463),
          onTap: onUnsuspend,
        ),
      ];
    }
    return [];
  }

  String _formatIsoDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }
}

class _AccountStatusBadge extends StatelessWidget {
  final String status;

  const _AccountStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      'blocked' => (
        const Color(0xFFFEE2E2),
        const Color(0xFF991B1B),
        'BLOQUEJAT',
      ),
      'suspended' => (
        const Color(0xFFFEF3C7),
        const Color(0xFF92400E),
        'SUSPÈS',
      ),
      _ => (const Color(0xFFD1FAE5), const Color(0xFF065F46), 'ACTIU'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: fg,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
