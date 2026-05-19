import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../core/services/stream_service.dart';
import '../xat/presentation/screens/building_chat_screen.dart';
import '../xat/presentation/screens/direct_channel_screen.dart';

class MyChatsScreen extends StatefulWidget {
  const MyChatsScreen({super.key});

  @override
  State<MyChatsScreen> createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  String? _connectionError;
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() {
      _retrying = true;
      _connectionError = null;
    });
    try {
      await StreamService.reconnect();
    } catch (e) {
      if (mounted) {
        setState(() => _connectionError = e.toString());
      }
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Els meus xats")),
      body: StreamBuilder<ConnectionStatus>(
        stream: StreamService.client.wsConnectionStatusStream,
        initialData: StreamService.client.wsConnectionStatus,
        builder: (context, snapshot) {
          final status = snapshot.data ?? ConnectionStatus.disconnected;

          if (status == ConnectionStatus.connecting || _retrying) {
            return const Center(child: CircularProgressIndicator());
          }

          if (status == ConnectionStatus.disconnected) {
            return _buildDisconnectedView();
          }

          return _ChannelList();
        },
      ),
    );
  }

  Widget _buildDisconnectedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No s\'ha pogut connectar al xat.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            if (_connectionError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _connectionError!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _retry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reconnectar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelList extends StatefulWidget {
  @override
  State<_ChannelList> createState() => _ChannelListState();
}

class _ChannelListState extends State<_ChannelList> {
  late final StreamChannelListController _controller;

  @override
  void initState() {
    super.initState();
    final userId = StreamService.client.state.currentUser?.id ?? '';
    _controller = StreamChannelListController(
      client: StreamService.client,
      filter: Filter.in_('members', [userId]),
      channelStateSort: const [SortOption.desc(ChannelSortKey.lastUpdated)],
      limit: 20,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannelListView(
      controller: _controller,
      itemBuilder: (context, channels, index, _) {
        final channel = channels[index];
        final name =
            channel.extraData['name'] as String? ?? channel.name ?? 'Xat';
        final lastMessage = channel.state?.messages
            .where((m) => !m.isDeleted)
            .toList()
            .lastOrNull;
        final unread = channel.state?.unreadCount ?? 0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7E3)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFE8F4EC),
              child: Icon(Icons.apartment, color: Colors.green.shade700),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                lastMessage?.text ?? 'Sense missatges',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: unread > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            onTap: () {
              final channelId = channel.id ?? '';

              if (channelId.startsWith('building_')) {
                final buildingIdStr = channelId.replaceFirst('building_', '');
                final buildingId = int.tryParse(buildingIdStr) ?? 0;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BuildingChatScreen(
                      idEdifici: buildingId,
                      buildingName: name,
                    ),
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DirectChannelScreen(
                    channelId: channelId,
                    channelName: name,
                    description:
                        'Conversa directa o canal compartit entre administradors.',
                  ),
                ),
              );
            },
          ),
        );
      },
      emptyBuilder: (_) => const Center(child: Text('No tens cap xat actiu.')),
      errorBuilder: (context, error) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Error: $error',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
      ),
      loadingBuilder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }
}
