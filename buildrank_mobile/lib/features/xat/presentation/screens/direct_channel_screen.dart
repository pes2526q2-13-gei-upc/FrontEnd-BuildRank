import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/xat/data/chat_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class DirectChannelScreen extends StatefulWidget {
  final String channelId;
  final String channelName;
  final String channelType;
  final String description;

  const DirectChannelScreen({
    super.key,
    required this.channelId,
    required this.channelName,
    this.channelType = 'messaging',
    this.description = '',
  });

  @override
  State<DirectChannelScreen> createState() => _DirectChannelScreenState();
}

class _DirectChannelScreenState extends State<DirectChannelScreen> {
  Channel? _channel;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  Future<void> _initChannel() async {
    try {
      // S'uneix a la connexió en curs (si en login es va llançar en segon pla)
      // o n'inicia una de nova. Evita dobles handshakes de WebSocket.
      await ChatService.ensureConnected();

      if (StreamService.client.state.currentUser == null) {
        setState(
          () => _error = AppLocalizations.of(context).chatUserNotConnectedError,
        );
        return;
      }

      final channel = StreamService.client.channel(
        widget.channelType,
        id: widget.channelId,
        extraData: {'name': widget.channelName},
      );

      await channel.watch();

      if (mounted) setState(() => _channel = channel);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  void _retryInit() {
    setState(() {
      _error = null;
      _channel = null;
    });
    _initChannel();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatFallbackName)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.chatConnectionError(_error!),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _retryInit,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_channel == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.chatConnecting),
            ],
          ),
        ),
      );
    }

    return StreamChannel(
      channel: _channel!,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2EF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.channelName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1),
              const Expanded(child: StreamMessageListView()),
              const StreamMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      color: const Color(0xFFF8FAF7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.channelName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            widget.description.isNotEmpty
                ? widget.description
                : l10n.chatDirectDescription,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }
}
