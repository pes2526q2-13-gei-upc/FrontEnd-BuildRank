import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../core/services/stream_service.dart';

class BuildingChatScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingName;

  const BuildingChatScreen({
    super.key,
    required this.idEdifici,
    required this.buildingName,
  });

  @override
  State<BuildingChatScreen> createState() => _BuildingChatScreenState();
}

class _BuildingChatScreenState extends State<BuildingChatScreen> {
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
          () => _error = 'Usuari no connectat. Tanca sessió i torna a entrar.',
        );
        return;
      }
      final userId = StreamService.client.state.currentUser!.id;
      final channel = StreamService.client.channel(
        'messaging',
        id: 'building_${widget.idEdifici}',
        extraData: {'name': widget.buildingName},
      );
      await channel.watch();
      // Asegura que el usuario actual es miembro (para que aparezca en "Els meus xats")
      final isMember =
          channel.state?.members.any((m) => m.userId == userId) ?? false;
      if (!isMember) await channel.addMembers([userId]);
      if (mounted) setState(() => _channel = channel);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

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
              const Expanded(child: StreamMessageListView()),
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
        ],
      ),
    );
  }
}
