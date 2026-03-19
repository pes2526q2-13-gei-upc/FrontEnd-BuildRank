import 'package:flutter/material.dart';

class BuildingChatScreen extends StatefulWidget {
  const BuildingChatScreen({super.key});

  @override
  State<BuildingChatScreen> createState() => _BuildingChatScreenState();
}

class _BuildingChatScreenState extends State<BuildingChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: "Laura",
      text:
          "Bon dia! He estat mirant opcions per millorar l’aïllament de la coberta.",
      time: "09:12",
      isMine: false,
    ),
    _ChatMessage(
      sender: "Tu",
      text:
          "Perfecte. Si voleu, ho podem comentar abans de portar-ho a votació.",
      time: "09:18",
      isMine: true,
    ),
    _ChatMessage(
      sender: "Marc",
      text:
          "També hauríem de revisar la instal·lació de llums LED de l’entrada.",
      time: "09:24",
      isMine: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(sender: "Tu", text: text, time: "Ara", isMine: true),
      );
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("Torna"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
            _buildComposer(),
          ],
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
        children: const [
          Text(
            "Comunitat de l’edifici",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Parla amb els membres d’aquest edifici sobre millores, incidències i propostes.",
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Escriu un missatge...",
                filled: true,
                fillColor: const Color(0xFFF4F6F3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 48,
            width: 48,
            child: ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isMine
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final bubbleColor = message.isMine ? Colors.green : const Color(0xFFF1F3F0);
    final textColor = message.isMine ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (!message.isMine)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              message.sender,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Text(
                message.text,
                style: TextStyle(color: textColor, height: 1.35),
              ),
              const SizedBox(height: 6),
              Text(
                message.time,
                style: TextStyle(
                  fontSize: 11,
                  color: message.isMine ? Colors.white70 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMine;

  _ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMine,
  });
}
