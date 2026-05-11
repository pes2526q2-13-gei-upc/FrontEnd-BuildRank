import 'package:flutter/material.dart';

import '../../../../shared/widgets/main_bottom_navigation.dart';
import '../../../buildingCard/presentation/screens/building_card_screen.dart';
import '../../../ranking/presentation/screens/ranking_screen.dart';
import '../../../simulation/presentation/screens/simulation_screen.dart';
import '../../../xat/presentation/screens/building_chat_screen.dart';
import '../../../vots/presentation/screens/votacions_screen.dart';

class MainScreen extends StatefulWidget {
  final int idEdifici;
  final Map<String, dynamic> building;
  final String userRole;
  final String title;
  final String address;
  final int score;

  const MainScreen({
    super.key,
    required this.idEdifici,
    required this.building,
    required this.userRole,
    required this.title,
    required this.address,
    required this.score,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages {
    return [
      BuildingDetailScreen(
        idEdifici: widget.idEdifici,
        building: widget.building,
        userRole: widget.userRole,
        title: widget.title,
        address: widget.address,
        score: widget.score,
      ),
      RankingScreen(
        idEdifici: widget.idEdifici,
        buildingName: widget.title,
        currentPoints: widget.score,
      ),
      SimulationScreen(
        idEdifici: widget.idEdifici,
        userRole: widget.userRole,
        buildingName: widget.title,
        currentPoints: widget.score,
      ),
      const BuildingChatScreen(),
      const VotacionsScreen(),
    ];
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
