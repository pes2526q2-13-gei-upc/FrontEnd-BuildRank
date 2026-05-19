import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Inici'),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events_outlined),
          label: 'Lligues',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bolt_outlined),
          label: 'Simula',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Xat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.how_to_vote_outlined),
          label: 'Votacions',
        ),
      ],
    );
  }
}
