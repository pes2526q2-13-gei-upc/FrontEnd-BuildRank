import 'package:flutter/material.dart';

import 'package:buildrank_mobile/l10n/app_localizations.dart';

class MainBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MainBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.grid_view),
          label: l10n.mainNavHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.emoji_events_outlined),
          label: l10n.mainNavLeagues,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bolt_outlined),
          label: l10n.mainNavSimulate,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble_outline),
          label: l10n.mainNavChat,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.how_to_vote_outlined),
          label: l10n.mainNavVotes,
        ),
      ],
    );
  }
}
