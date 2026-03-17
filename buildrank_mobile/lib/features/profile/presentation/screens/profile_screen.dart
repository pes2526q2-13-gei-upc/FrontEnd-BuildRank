import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/formBuilding/presentation/screens/form_building_screen.dart';
import 'package:buildrank_mobile/features/main/presentation/screens/building_main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BuildRank"),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.settings_outlined),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 USER CARD
          _buildUserCard(),

          const SizedBox(height: 16),

          // 🔹 ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BuildingFormScreen(),
                      ),
                    );
                  },
                  child: const Text("Afegeix Edifici"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("Informes"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 SEASON CARD
          _buildSeasonCard(),

          const SizedBox(height: 20),

          // 🔹 BUILDINGS TITLE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Els meus edificis",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("Veure Tots", style: TextStyle(color: Colors.green)),
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 BUILDINGS LIST
          _buildBuildingItem(
            context,
            title: "Torre Crystal Heights",
            score: "88/100",
          ),

          _buildBuildingItem(
            context,
            title: "Greenwood Resident",
            score: "74/100",
          ),

          _buildBuildingItem(
            context,
            title: "Industrial Bay Plaza",
            score: "52/100",
          ),

          _buildBuildingItem(
            context,
            title: "Legacy Heritage Suite",
            score: "38/100",
          ),

          const SizedBox(height: 20),

          // 🔹 BADGES
          const Text(
            "Insígnies Actives",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(child: _BadgeCard(title: "Mestre d'eficiència")),
              SizedBox(width: 10),
              Expanded(child: _BadgeCard(title: "Pioner Solar")),
              SizedBox(width: 10),
              Expanded(child: _BadgeCard(title: "Heroi de CO₂")),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 USER CARD
  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: const [
          ListTile(
            leading: CircleAvatar(radius: 25),
            title: Text("Marcus"),
            subtitle: Text("Gestor de cartera sènior"),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Metric(title: "12", subtitle: "EDIFICIS"),
              _Metric(title: "B+", subtitle: "RÀNQUING MITJÀ"),
              _Metric(title: "+14%", subtitle: "PROGRÉS"),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 SEASON CARD
  Widget _buildSeasonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Proper reinici de temporada"),
          SizedBox(height: 8),
          LinearProgressIndicator(value: 0.7),
          SizedBox(height: 8),
          Text("Queden 12 dies"),
        ],
      ),
    );
  }

  // 🔹 BUILDING ITEM
  Widget _buildBuildingItem(
    BuildContext context, {
    required String title,
    required String score,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(width: 50, height: 50, color: Colors.grey.shade300),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
            Text(score),
          ],
        ),
      ),
    );
  }
}

// 🔹 METRIC
class _Metric extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Metric({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// 🔹 BADGE CARD
class _BadgeCard extends StatelessWidget {
  final String title;

  const _BadgeCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}
