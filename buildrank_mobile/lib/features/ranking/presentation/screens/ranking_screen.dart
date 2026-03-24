import 'package:flutter/material.dart';
import '../../../../shared/widgets/badge_item.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  bool isGlobal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLeagueCard(),
                  const SizedBox(height: 20),

                  _buildBadges(),
                  const SizedBox(height: 20),

                  _buildToggle(),
                  const SizedBox(height: 12),

                  _buildSearch(),
                  const SizedBox(height: 16),

                  _buildRanking(),
                  const SizedBox(height: 16),

                  _buildLoadMore(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(Icons.trending_up),
      ),
    );
  }

  // LEAGUE CARD
  Widget _buildLeagueCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6B7280),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30),
            ),
            child: const Text(
              "Temporada Activa: Hivern 26",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Silver League",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Progrés cap a Gold",
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 6),

          const Text("840 / 1200 punts", style: TextStyle(color: Colors.white)),

          const SizedBox(height: 10),

          const LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.white24,
            color: Colors.white,
          ),

          const SizedBox(height: 10),

          const Text(
            "El top 15% puja en 4 dies!",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // BADGES
  Widget _buildBadges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Insígnies aconseguides",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text("Veure-ho tot", style: TextStyle(color: Colors.green)),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              BadgeItem(
                icon: Icons.bolt,
                label: "Mestre solar",
                date: "Oct 25",
                color: Colors.yellow,
              ),
              BadgeItem(
                icon: Icons.trending_up,
                label: "Màxim estalvi",
                date: "Nov 25",
                color: Colors.green,
              ),
              BadgeItem(
                icon: Icons.apartment,
                label: "Resilient",
                date: "Dec 25",
                color: Colors.blue,
              ),
              BadgeItem(
                icon: Icons.location_city,
                label: "Prova",
                date: "Gen 26",
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TOGGLE
  Widget _buildToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isGlobal = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isGlobal ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Rànquing global",
                  style: TextStyle(
                    color: isGlobal ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isGlobal = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: !isGlobal ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Continent: Europa",
                  style: TextStyle(
                    color: !isGlobal ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // SEARCH
  Widget _buildSearch() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Cerca un edifici o administrador...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // RANKING
  Widget _buildRanking() {
    return Column(
      children: const [
        _RankingItem(position: 1, name: "Green Heights Res.", points: "2,840"),
        _RankingItem(position: 2, name: "EcoTower Suites", points: "2,715"),
        _RankingItem(position: 3, name: "Solaris Complex", points: "2,690"),
        _RankingItem(
          position: 4,
          name: "Skyline Manor",
          points: "2,540",
          isYou: true,
        ),
        _RankingItem(position: 5, name: "Central Park West", points: "2,480"),
      ],
    );
  }

  Widget _buildLoadMore() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(child: Text("Carrega més competidors")),
    );
  }
}

// RANKING ITEM
class _RankingItem extends StatelessWidget {
  final int position;
  final String name;
  final String points;
  final bool isYou;

  const _RankingItem({
    required this.position,
    required this.name,
    required this.points,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isYou ? const Color(0xFFE8F4EC) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPosition(),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name)),
          Text(points),
        ],
      ),
    );
  }

  Widget _buildPosition() {
    switch (position) {
      case 1:
        return const Icon(Icons.emoji_events, color: Color(0xFFFFD700));
      case 2:
        return const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0));
      case 3:
        return const Icon(Icons.emoji_events, color: Color(0xFFCD7F32));
      default:
        return Text(
          "$position",
          style: const TextStyle(fontWeight: FontWeight.w600),
        );
    }
  }
}
