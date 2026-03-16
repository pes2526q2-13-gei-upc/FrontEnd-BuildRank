import 'package:buildrank_mobile/shared/widgets/main_bottom_navigation.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/metric_card.dart';
import '../../../../shared/widgets/action_tile.dart';
import '../../../../shared/widgets/league_info_card.dart';
import '../../../../shared/widgets/revision_card.dart';
import '../../../../shared/widgets/main_bottom_navigation.dart';

class BuildingDetailScreen extends StatefulWidget {
  const BuildingDetailScreen({super.key});

  @override
  State<BuildingDetailScreen> createState() => _BuildingDetailScreenState();
}

class _BuildingDetailScreenState extends State<BuildingDetailScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("Torna"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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

      body: ListView(
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          _buildPerformance(),

          const SizedBox(height: 20),

          _buildActions(),

          const SizedBox(height: 20),

          _buildTabs(),

          const SizedBox(height: 16),

          _buildDetails(),

          const SizedBox(height: 20),

          const LeagueInfoCard(),

          const SizedBox(height: 20),

          const RevisionCard(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFFE8F4EC),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "VERIFICAT • NIVELL 3",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Torre Skyline Heights",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16),
              SizedBox(width: 6),
              Text("450 Grand Avenue, Metropolis"),
            ],
          ),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 10),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "94",
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "EXCEL·LENT",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text("+12% vs temporada anterior"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RENDIMENT",
                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
              ),
              Text(
                "Veure Auditoria",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.7,
            children: const [
              MetricCard(
                title: "QUALIFICACIÓ ENERGÈTICA",
                value: "B",
                icon: Icons.bolt,
              ),

              MetricCard(
                title: "EFICIÈNCIA HÍDRICA",
                value: "A",
                icon: Icons.water_drop,
              ),

              MetricCard(
                title: "RESILIÈNCIA",
                value: "Alta",
                icon: Icons.shield,
              ),

              MetricCard(
                title: "EMISSIONS DE CO2",
                value: "12kg/m²",
                icon: Icons.eco,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "ACCIONS RECOMANADES",
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
          ),

          SizedBox(height: 14),

          ActionTile(
            icon: Icons.bolt,
            title: "Executa Simulació",
            subtitle: "Prova el ROI de solar i aïllament",
            color: Color(0xFFE8F4EC),
          ),

          SizedBox(height: 10),

          ActionTile(
            icon: Icons.how_to_vote,
            title: "Votació de la comunitat",
            subtitle: "Revisa 2 renovacions actives",
            color: Color(0xFFE7ECF7),
          ),

          SizedBox(height: 10),

          ActionTile(
            icon: Icons.description,
            title: "Genera Informe",
            subtitle: "Exporta les dades de l'edifici",
            color: Color(0xFFF1F1F1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 0, label: Text("Detalls")),
          ButtonSegment(value: 1, label: Text("Historial")),
          ButtonSegment(value: 2, label: Text("Documents")),
        ],
        selected: {_tabIndex},
        onSelectionChanged: (value) {
          setState(() {
            _tabIndex = value.first;
          });
        },
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailItem(label: "ANY DE CONSTRUCCIÓ", value: "1998"),
              _DetailItem(label: "PLANTES", value: "12 plantes"),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DetailItem(label: "TIPOLOGIA", value: "Complex Residencial"),
              _DetailItem(
                label: "TIPUS SUBMINISTRAMENT",
                value: "Mixt (xarxa/gas)",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
