import 'package:flutter/material.dart';
import '../../../../shared/widgets/main_bottom_navigation.dart';
import '../../../buildingCard/presentation/screens/building_card_screen.dart';
import '../../../ranking/presentation/screens/ranking_screen.dart';
import '../../../simulation/presentation/screens/simulation_screen.dart';
import '../../../xat/presentation/screens/xat_screen.dart';
import '../../../vots/presentation/screens/votacions_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    BuildingDetailScreen(),
    RankingScreen(),
    SimulationScreen(),
    XatScreen(),
    VotacionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: MainBottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
