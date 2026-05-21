import 'package:buildrank_mobile/core/services/stream_service.dart';
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
      if (StreamService.client.state.currentUser == null) {
        await StreamService.reconnect();
      }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatFallbackName)),
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
