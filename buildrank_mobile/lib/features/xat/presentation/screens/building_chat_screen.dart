import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../core/services/stream_service.dart';
import '../../../auth/data/auth_service.dart';
import '../../data/chat_service.dart';
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
        await ChatService.provisionAndReconnect();
      }
      if (StreamService.client.state.currentUser == null) {
        setState(
          () => _error = AppLocalizations.of(context).chatUserNotConnectedError,
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

  Future<String?> _askReason(String title) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.chatReasonOptionalHint),
          maxLines: 2,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.commonCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm(String text) async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.chatConfirmActionTitle),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.commonCancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  l10n.commonConfirm,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<({int? timeout, String? reason})?> _askDurationAndReason(
    String title,
  ) {
    final l10n = AppLocalizations.of(context);
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
                decoration: InputDecoration(labelText: l10n.chatDurationLabel),
                initialValue: selectedTimeout,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.chatDurationIndefinite),
                  ),
                  DropdownMenuItem(
                    value: 30,
                    child: Text(l10n.chatDuration30Minutes),
                  ),
                  DropdownMenuItem(
                    value: 60,
                    child: Text(l10n.chatDuration1Hour),
                  ),
                  DropdownMenuItem(
                    value: 360,
                    child: Text(l10n.chatDuration6Hours),
                  ),
                  DropdownMenuItem(
                    value: 1440,
                    child: Text(l10n.chatDuration24Hours),
                  ),
                ],
                onChanged: (v) => setStateDialog(() => selectedTimeout = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: l10n.chatReasonOptionalHint,
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.commonCancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, (
                timeout: selectedTimeout,
                reason: controller.text.trim().isEmpty
                    ? null
                    : controller.text.trim(),
              )),
              child: Text(l10n.commonConfirm),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _flagMessage(Message msg) async {
    final l10n = AppLocalizations.of(context);
    final reason = await _askReason(l10n.chatReportMessage);
    if (reason == null) return;
    try {
      await ModerationService.flagMessage(
        msg.id,
        _channelId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback(l10n.chatMessageReported);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _hideMessage(Message msg) async {
    final l10n = AppLocalizations.of(context);
    final reason = await _askReason(l10n.chatHideMessage);
    if (reason == null) return;
    try {
      await ModerationService.hideMessage(
        msg.id,
        _channelId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback(l10n.chatMessageHidden);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _deleteOwnMessage(Message msg) async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirm(l10n.chatDeleteOwnMessageConfirm);
    if (!ok) return;
    try {
      await ModerationService.deleteMessage(msg.id, _channelId, isOwn: true);
      _showFeedback(l10n.chatMessageDeleted);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _deleteOtherMessage(Message msg) async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirm(l10n.chatDeleteOtherMessageConfirm);
    if (!ok) return;
    try {
      await ModerationService.deleteMessage(msg.id, _channelId, isOwn: false);
      _showFeedback(l10n.chatMessageDeleted);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _restoreMessage(Message msg) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ModerationService.restoreMessage(msg.id, _channelId);
      _showFeedback(l10n.chatMessageRestored);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _dismissFlag(Message msg) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ModerationService.dismissFlag(msg.id, _channelId);
      _showFeedback(l10n.chatReportDismissed);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _warnUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final reason = await _askReason(l10n.chatWarnUser);
    if (reason == null) return;
    try {
      await ModerationService.warnUser(
        djangoId,
        _channelId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback(l10n.chatWarningSent);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _muteUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final params = await _askDurationAndReason(l10n.chatMuteUser);
    if (params == null) return;
    try {
      await ModerationService.muteUser(
        djangoId,
        _channelId,
        timeout: params.timeout,
        reason: params.reason,
      );
      _showFeedback(l10n.chatUserMuted);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _unmuteUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ModerationService.unmuteUser(djangoId, _channelId);
      _showFeedback(l10n.chatUserUnmuted);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _banUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final params = await _askDurationAndReason(l10n.chatBanFromChannel);
    if (params == null) return;
    try {
      await ModerationService.banUser(
        djangoId,
        _channelId,
        timeout: params.timeout,
        reason: params.reason,
      );
      _showFeedback(l10n.chatUserBannedFromChannel);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _unbanUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ModerationService.unbanUser(djangoId, _channelId);
      _showFeedback(l10n.chatUserUnbannedFromChannel);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _globalBanUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final reason = await _askReason(l10n.chatGlobalBan);
    if (reason == null) return;
    try {
      await ModerationService.globalBanUser(
        djangoId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback(l10n.chatUserGloballyBanned);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _globalUnbanUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirm(l10n.chatGlobalUnbanConfirm);
    if (!ok) return;
    try {
      await ModerationService.globalUnbanUser(djangoId);
      _showFeedback(l10n.chatGlobalBanLifted);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _shadowBanUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final reason = await _askReason(l10n.chatShadowBan);
    if (reason == null) return;
    try {
      await ModerationService.shadowBanUser(
        djangoId,
        reason: reason.isEmpty ? null : reason,
      );
      _showFeedback(l10n.chatShadowBanApplied);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  Future<void> _shadowUnbanUser(int djangoId) async {
    final l10n = AppLocalizations.of(context);
    final ok = await _confirm(l10n.chatShadowUnbanConfirm);
    if (!ok) return;
    try {
      await ModerationService.shadowUnbanUser(djangoId);
      _showFeedback(l10n.chatShadowBanLifted);
    } catch (e) {
      _showFeedback(e.toString(), isError: true);
    }
  }

  void _showUserModerationSheet(User user) {
    final l10n = AppLocalizations.of(context);
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
                  l10n.chatWarn,
                  () => _warnUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.volume_off_outlined,
                  l10n.chatMute,
                  () => _muteUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.volume_up_outlined,
                  l10n.chatUnmute,
                  () => _unmuteUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.block_outlined,
                  l10n.chatBanFromChannel,
                  () => _banUser(djangoId),
                  color: Colors.orange,
                ),
                _sheetTile(
                  ctx,
                  Icons.how_to_reg_outlined,
                  l10n.chatReadmitToChannel,
                  () => _unbanUser(djangoId),
                ),
              ],
              if (_isSuperuser) ...[
                const Divider(),
                _sheetTile(
                  ctx,
                  Icons.gavel,
                  l10n.chatGlobalBan,
                  () => _globalBanUser(djangoId),
                  color: Colors.red,
                ),
                _sheetTile(
                  ctx,
                  Icons.how_to_reg,
                  l10n.chatLiftGlobalBan,
                  () => _globalUnbanUser(djangoId),
                ),
                _sheetTile(
                  ctx,
                  Icons.visibility_off,
                  l10n.chatShadowBan,
                  () => _shadowBanUser(djangoId),
                  color: Colors.purple,
                ),
                _sheetTile(
                  ctx,
                  Icons.visibility,
                  l10n.chatLiftShadowBan,
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

  List<StreamMessageAction> _buildMessageActions(Message message) {
    final l10n = AppLocalizations.of(context);
    final currentUserId = StreamService.client.state.currentUser?.id;
    final isOwn = message.user?.id == currentUserId;

    return [
      StreamMessageAction(
        leading: const Icon(Icons.flag_outlined),
        title: Text(l10n.chatReportMessage),
        onTap: _flagMessage,
      ),
      if (isOwn)
        StreamMessageAction(
          leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
          title: Text(
            l10n.chatDeleteMyMessage,
            style: TextStyle(color: Colors.red.shade700),
          ),
          onTap: _deleteOwnMessage,
        ),
      if (_canModerate) ...[
        StreamMessageAction(
          leading: const Icon(Icons.visibility_off_outlined),
          title: Text(l10n.chatHideMessage),
          onTap: _hideMessage,
        ),
        if (!isOwn)
          StreamMessageAction(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Colors.red.shade700,
            ),
            title: Text(
              l10n.chatDeleteMessage,
              style: TextStyle(color: Colors.red.shade700),
            ),
            onTap: _deleteOtherMessage,
          ),
        StreamMessageAction(
          leading: const Icon(Icons.restore_outlined),
          title: Text(l10n.chatRestoreMessage),
          onTap: _restoreMessage,
        ),
        StreamMessageAction(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(l10n.chatDismissReport),
          onTap: _dismissFlag,
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.chatConnectionError(_error!)),
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
              label: Text(l10n.commonBack),
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
              _buildHeader(l10n),
              const Divider(height: 1),
              Expanded(
                child: StreamMessageListView(
                  messageBuilder: (context, details, messages, defaultWidget) {
                    final msg = details.message;
                    final currentUserId =
                        StreamService.client.state.currentUser?.id;

                    // Ocultar missatges d'usuaris silenciats
                    final mutedIds =
                        StreamService.client.state.currentUser?.mutes
                            .map((m) => m.target.id)
                            .toSet() ??
                        {};
                    if (msg.user?.id != null &&
                        msg.user!.id != currentUserId &&
                        mutedIds.contains(msg.user!.id)) {
                      return const SizedBox.shrink();
                    }

                    final isHidden = msg.extraData['moderated'] == true;

                    if (isHidden) {
                      final chatTheme = StreamChatTheme.of(context);
                      final isOwn = msg.user?.id == currentUserId;
                      final base = isOwn
                          ? chatTheme.ownMessageTheme
                          : chatTheme.otherMessageTheme;
                      return defaultWidget.copyWith(
                        showFlagButton: false,
                        showDeleteMessage: false,
                        customActions: _buildMessageActions(msg),
                        onUserAvatarTap: _canModerate
                            ? _showUserModerationSheet
                            : null,
                        messageTheme: base.copyWith(
                          messageTextStyle: base.messageTextStyle?.copyWith(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                          messageBackgroundColor: Colors.grey.shade200,
                        ),
                      );
                    }

                    return defaultWidget.copyWith(
                      showFlagButton: false,
                      showDeleteMessage: false,
                      customActions: _buildMessageActions(msg),
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

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: const Color(0xFFF8FAF7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chatCommunityTitle(widget.buildingName),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.chatCommunitySubtitle,
            style: const TextStyle(color: Colors.black54, height: 1.35),
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
                label: Text(l10n.chatContactSimilarAdmins),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
