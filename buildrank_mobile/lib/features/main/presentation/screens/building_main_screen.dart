import 'package:flutter/material.dart';
import '../../../../shared/widgets/main_bottom_navigation.dart';
import '../../../buildingCard/presentation/screens/building_card_screen.dart';
import '../../../ranking/presentation/screens/ranking_screen.dart';
import '../../../simulation/presentation/screens/simulation_screen.dart';
import '../../../xat/presentation/screens/building_chat_screen.dart';
import '../../../vots/presentation/screens/votacions_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    BuildingDetailScreen(),
    RankingScreen(),
    SimulationScreen(),
    BuildingChatScreen(),
    VotacionsScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: MainBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
