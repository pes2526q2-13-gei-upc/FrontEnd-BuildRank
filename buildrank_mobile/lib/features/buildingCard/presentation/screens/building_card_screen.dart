import 'package:flutter/material.dart';

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

          _buildLeagueInfo(),

          const SizedBox(height: 20),

          _buildRevision(),

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
              _MetricCard(
                title: "QUALIFICACIÓ ENERGÈTICA",
                value: "B",
                icon: Icons.bolt,
              ),

              _MetricCard(
                title: "EFICIÈNCIA HÍDRICA",
                value: "A",
                icon: Icons.water_drop,
              ),

              _MetricCard(
                title: "RESILIÈNCIA",
                value: "Alta",
                icon: Icons.shield,
              ),

              _MetricCard(
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

          _ActionTile(
            icon: Icons.bolt,
            title: "Executa Simulació",
            subtitle: "Prova el ROI de solar i aïllament",
            color: Color(0xFFE8F4EC),
          ),

          SizedBox(height: 10),

          _ActionTile(
            icon: Icons.how_to_vote,
            title: "Votació de la comunitat",
            subtitle: "Revisa 2 renovacions actives",
            color: Color(0xFFE7ECF7),
          ),

          SizedBox(height: 10),

          _ActionTile(
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

  Widget _buildLeagueInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4E7E2)),
          color: const Color(0xFFF8FAF7),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 22, color: Colors.black54),

            const SizedBox(width: 12),

            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: "Aquest edifici és actualment a la "),
                    TextSpan(
                      text: "Silver League",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ". Millora la qualificació energètica per passar a la ",
                    ),
                    TextSpan(
                      text: "Gold League",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE0A100),
                      ),
                    ),
                    TextSpan(text: "."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevision() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF4B5458),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.access_time, color: Colors.white, size: 20),

                SizedBox(width: 8),

                Text(
                  "Propera revisió: 15 des. 2026",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            LinearProgressIndicator(
              value: 0.75,
              color: Colors.green,
              backgroundColor: Colors.white24,
            ),

            SizedBox(height: 12),

            Text(
              "Les dades de verificació estan completes al 75%.",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, child: Icon(icon)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          const Icon(Icons.chevron_right),
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
