import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../core/services/stream_service.dart';
import '../../../auth/data/auth_service.dart';
import '../../data/moderation_service.dart';
import 'twin_building_admins_screen.dart';

class BuildingChatScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingName;
  final String userRole;
  final bool isSuperuser;

  const BuildingChatScreen({
    super.key,
    required this.idEdifici,
    required this.buildingName,
    this.userRole = '',
    this.isSuperuser = false,
  });

  @override
  State<BuildingChatScreen> createState() => _BuildingChatScreenState();
}

class _BuildingChatScreenState extends State<BuildingChatScreen> {
  Channel? _channel;
  String? _error;
  bool _isSuperuser = false;

  bool get _isAdmin => widget.userRole == 'admin';
  bool get _canModerate => _isAdmin || _isSuperuser;
  String get _channelId => 'building_${widget.idEdifici}';

  @override
  void initState() {
    super.initState();
    _initChannel();
    AuthService()
        .getMe()
        .then((me) {
          if (mounted) {
            setState(() => _isSuperuser = me['is_system_admin'] == true);
          }
        })
        .catchError((_) {});
  }

  Future<void> _initChannel() async {
    try {
      if (StreamService.client.state.currentUser == null) {
        await StreamService.reconnect();
      }
      if (StreamService.client.state.currentUser == null) {
        setState(
          () => _error = 'Usuari no connectat. Tanca sessió i torna a entrar.',
        );
        return;
      }
      final userId = StreamService.client.state.currentUser!.id;
      final channel = StreamService.client.channel(
        'messaging',
        id: _channelId,
        extraData: {'name': widget.buildingName},
      );
      await channel.watch();
      final isMember =
          channel.state?.members.any((m) => m.userId == userId) ?? false;
      if (!isMember) await channel.addMembers([userId]);
      if (mounted) setState(() => _channel = channel);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  int _djangoId(String streamUserId) =>
      int.tryParse(streamUserId.replaceFirst('user_', '')) ?? 0;

  void _showFeedback(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Returns the reason text, or null if the user cancelled.
  Future<String?> _askReason(String title) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Motiu (opcional)'),
          maxLines: 2,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel·lar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm(String text) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirmar acció'),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel·lar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Duration + reason dialog for mute/ban. Returns null if cancelled.
  Future<({int? timeout, String? reason})?> _askDurationAndReason(
    String title,
  ) {
    final controller = TextEditingController();
    int? selectedTimeout;
    return showDialog<({int? timeout, String? reason})>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int?>(
                decoration: const InputDecoration(labelText: 'Durada'),
                initialValue: selectedTimeout,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Indefinit')),
                  DropdownMenuItem(value: 30, child: Text('30 minuts')),
                  DropdownMenuItem(value: 60, child: Text('1 hora')),
                  DropdownMenuItem(value: 360, child: Text('6 hores')),
                  DropdownMenuItem(value: 1440, child: Text('24 hores')),
                ],
                onChanged: (v) => setStateDialog(() => selectedTimeout = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Motiu (opcional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel·lar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, (
                timeout: selectedTimeout,
                reason: controller.text.trim().isEmpty
                    ? null
                    : controller.text.trim(),
              )),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Message moderation ────────────────────────────────────────────────────

  Future<void> _flagMessage(Message msg) async {
    final reason = await _askReason('Reportar missatge');
    if (reason == null) return;
    try {
      await ModerationService.flagMessage(
        msg.id,
        _channelId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback('Missatge reportat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _hideMessage(Message msg) async {
    final reason = await _askReason('Ocultar missatge');
    if (reason == null) return;
    try {
      await ModerationService.hideMessage(
        msg.id,
        _channelId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback('Missatge ocult.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _deleteOwnMessage(Message msg) async {
    final ok = await _confirm('Segur que vols eliminar el teu missatge?');
    if (!ok) return;
    try {
      await ModerationService.deleteMessage(msg.id, _channelId, isOwn: true);
      _showFeedback('Missatge eliminat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _deleteOtherMessage(Message msg) async {
    final ok = await _confirm('Eliminar el missatge d\'aquest usuari?');
    if (!ok) return;
    try {
      await ModerationService.deleteMessage(msg.id, _channelId, isOwn: false);
      _showFeedback('Missatge eliminat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _restoreMessage(Message msg) async {
    try {
      await ModerationService.restoreMessage(msg.id, _channelId);
      _showFeedback('Missatge restaurat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _dismissFlag(Message msg) async {
    try {
      await ModerationService.dismissFlag(msg.id, _channelId);
      _showFeedback('Report desestimat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  // ── User moderation ───────────────────────────────────────────────────────

  Future<void> _warnUser(int djangoId) async {
    final reason = await _askReason('Advertir usuari');
    if (reason == null) return;
    try {
      await ModerationService.warnUser(
        djangoId,
        _channelId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback('Advertència enviada.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _muteUser(int djangoId) async {
    final params = await _askDurationAndReason('Silenciar usuari');
    if (params == null) return;
    try {
      await ModerationService.muteUser(
        djangoId,
        _channelId,
        timeout: params.timeout,
        reason: params.reason,
      );
      _showFeedback('Usuari silenciat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _unmuteUser(int djangoId) async {
    try {
      await ModerationService.unmuteUser(djangoId, _channelId);
      _showFeedback('Usuari dessilenciat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _banUser(int djangoId) async {
    final params = await _askDurationAndReason('Expulsar del canal');
    if (params == null) return;
    try {
      await ModerationService.banUser(
        djangoId,
        _channelId,
        timeout: params.timeout,
        reason: params.reason,
      );
      _showFeedback('Usuari expulsat del canal.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _unbanUser(int djangoId) async {
    try {
      await ModerationService.unbanUser(djangoId, _channelId);
      _showFeedback('Usuari readmès al canal.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _globalBanUser(int djangoId) async {
    final reason = await _askReason('Expulsió global');
    if (reason == null) return;
    try {
      await ModerationService.globalBanUser(
        djangoId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback('Usuari expulsat globalment.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _globalUnbanUser(int djangoId) async {
    final ok = await _confirm('Aixecar l\'expulsió global d\'aquest usuari?');
    if (!ok) return;
    try {
      await ModerationService.globalUnbanUser(djangoId);
      _showFeedback('Expulsió global aixecada.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _shadowBanUser(int djangoId) async {
    final reason = await _askReason('Shadow ban');
    if (reason == null) return;
    try {
      await ModerationService.shadowBanUser(
        djangoId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback('Shadow ban aplicat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _shadowUnbanUser(int djangoId) async {
    final ok = await _confirm('Aixecar el shadow ban d\'aquest usuari?');
    if (!ok) return;
    try {
      await ModerationService.shadowUnbanUser(djangoId);
      _showFeedback('Shadow ban aixecat.');
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  // ── User moderation bottom sheet ──────────────────────────────────────────

  void _showUserModerationSheet(User user) {
    final djangoId = _djangoId(user.id);
    if (djangoId == 0) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  user.name.isNotEmpty ? user.name : user.id,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              if (_canModerate) ...[
                _sheetTile(
                  ctx,
                  Icons.warning_amber_outlined,
                  'Advertir',
                  () => _warnUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.volume_off_outlined,
                  'Silenciar',
                  () => _muteUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.volume_up_outlined,
                  'Dessilenciar',
                  () => _unmuteUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.block_outlined,
                  'Expulsar del canal',
                  () => _banUser(djangoId),
                  color: Colors.orange,
                ),
                _sheetTile(
                  ctx,
                  Icons.how_to_reg_outlined,
                  'Readmetre al canal',
                  () => _unbanUser(djangoId),
                ),
              ],
              if (_isSuperuser) ...[
                const Divider(),
                _sheetTile(
                  ctx,
                  Icons.gavel,
                  'Expulsió global',
                  () => _globalBanUser(djangoId),
                  color: Colors.red,
                ),
                _sheetTile(
                  ctx,
                  Icons.how_to_reg,
                  'Aixecar expulsió global',
                  () => _globalUnbanUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.visibility_off,
                  'Shadow ban',
                  () => _shadowBanUser(djangoId),
                  color: Colors.purple,
                ),
                _sheetTile(
                  ctx,
                  Icons.visibility,
                  'Aixecar shadow ban',
                  () => _shadowUnbanUser(djangoId),
                  color: Colors.purple,
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetTile(
    BuildContext ctx,
    IconData icon,
    String label,
    Future<void> Function() action, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: color != null ? TextStyle(color: color) : null),
      onTap: () {
        Navigator.pop(ctx);
        action();
      },
    );
  }

  // ── Message actions builder ───────────────────────────────────────────────

  List<StreamMessageAction> _buildMessageActions(Message message) {
    final currentUserId = StreamService.client.state.currentUser?.id;
    final isOwn = message.user?.id == currentUserId;

    return [
      StreamMessageAction(
        leading: const Icon(Icons.flag_outlined),
        title: const Text('Reportar missatge'),
        onTap: _flagMessage,
      ),
      if (isOwn)
        StreamMessageAction(
          leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
          title: Text(
            'Eliminar el meu missatge',
            style: TextStyle(color: Colors.red.shade700),
          ),
          onTap: _deleteOwnMessage,
        ),
      if (_canModerate) ...[
        StreamMessageAction(
          leading: const Icon(Icons.visibility_off_outlined),
          title: const Text('Ocultar missatge'),
          onTap: _hideMessage,
        ),
        if (!isOwn)
          StreamMessageAction(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Colors.red.shade700,
            ),
            title: Text(
              'Eliminar missatge',
              style: TextStyle(color: Colors.red.shade700),
            ),
            onTap: _deleteOtherMessage,
          ),
        StreamMessageAction(
          leading: const Icon(Icons.restore_outlined),
          title: const Text('Restaurar missatge'),
          onTap: _restoreMessage,
        ),
        StreamMessageAction(
          leading: const Icon(Icons.check_circle_outline),
          title: const Text('Desestimar report'),
          onTap: _dismissFlag,
        ),
      ],
    ];
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error al connectar el xat:\n$_error'),
          ),
        ),
      );
    }

    if (_channel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return StreamChannel(
      channel: _channel!,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2EF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 120,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Torna"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 5),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1),
              Expanded(
                child: StreamMessageListView(
                  messageBuilder: (context, details, messages, defaultWidget) {
                    return defaultWidget.copyWith(
                      showFlagButton: false,
                      showDeleteMessage: false,
                      customActions: _buildMessageActions(details.message),
                      onUserAvatarTap: _canModerate
                          ? _showUserModerationSheet
                          : null,
                    );
                  },
                ),
              ),
              const StreamMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: const Color(0xFFF8FAF7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comunitat de ${widget.buildingName}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Parla amb els membres d'aquest edifici sobre millores, incidències i propostes.",
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
          if (widget.userRole == 'admin') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TwinBuildingAdminsScreen(
                        idEdifici: widget.idEdifici,
                        buildingName: widget.buildingName,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.apartment_outlined),
                label: const Text('Contactar admins similars'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
