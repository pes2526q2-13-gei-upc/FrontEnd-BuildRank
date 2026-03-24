import 'package:flutter/material.dart';

class MyChatsScreen extends StatelessWidget {
  const MyChatsScreen({super.key});

  final bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    const communityChats = [
      _ChatPreview(
        title: "Torre Crystal Heights",
        subtitle: "S'ha actualitzat la proposta de millora de façana.",
        trailing: "10:24",
        unreadCount: 3,
        icon: Icons.apartment,
      ),
      _ChatPreview(
        title: "Greenwood Resident",
        subtitle: "Hi ha una nova incidència oberta a l’ascensor.",
        trailing: "Ahir",
        unreadCount: 1,
        icon: Icons.location_city,
      ),
    ];

    const twinBuildingChats = [
      _ChatPreview(
        title: "Admin · Edifici Delta",
        subtitle: "Ens ha funcionat molt bé el canvi a plaques solars.",
        trailing: "09:40",
        unreadCount: 2,
        icon: Icons.forum_outlined,
      ),
      _ChatPreview(
        title: "Admin · Bloc Maragall",
        subtitle: "Us passo el pressupost que vam votar la setmana passada.",
        trailing: "Dll",
        unreadCount: 0,
        icon: Icons.forum_outlined,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Els meus xats")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(
            title: "Comunitats",
            subtitle: "Xats dels edificis on participes.",
          ),
          const SizedBox(height: 12),
          ...communityChats.map((chat) => _ChatTile(chat: chat)),
          if (isAdmin) ...[
            const SizedBox(height: 24),
            const _SectionHeader(
              title: "Twin Building",
              subtitle: "Missatges directes amb altres administradors.",
            ),
            const SizedBox(height: 12),
            ...twinBuildingChats.map((chat) => _ChatTile(chat: chat)),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, height: 1.3),
        ),
      ],
    );
  }
}

class _ChatTile extends StatelessWidget {
  final _ChatPreview chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7E3)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F4EC),
          child: Icon(chat.icon, color: Colors.green.shade700),
        ),
        title: Text(
          chat.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            chat.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat.trailing,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            if (chat.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${chat.unreadCount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class _ChatPreview {
  final String title;
  final String subtitle;
  final String trailing;
  final int unreadCount;
  final IconData icon;

  const _ChatPreview({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.unreadCount,
    required this.icon,
  });
}
