import 'package:flutter/material.dart';

class BuildingFormScreen extends StatefulWidget {
  const BuildingFormScreen({super.key});

  @override
  State<BuildingFormScreen> createState() => _BuildingFormScreenState();
}

class _BuildingFormScreenState extends State<BuildingFormScreen> {
  final TextEditingController _addressController = TextEditingController();

  String _selectedType = 'residential';

  final List<Map<String, dynamic>> _buildingTypes = [
    {
      'id': 'residential',
      'icon': Icons.apartment,
      'title': 'Residencial',
      'subtitle': 'Unifamiliar o pisos',
    },
    {
      'id': 'commercial',
      'icon': Icons.business,
      'title': 'Comercial',
      'subtitle': 'Oficines, comerç...',
    },
    {
      'id': 'education',
      'icon': Icons.school,
      'title': 'Educatiu',
      'subtitle': 'Escoles',
    },
    {
      'id': 'health',
      'icon': Icons.local_hospital,
      'title': 'Sanitari',
      'subtitle': 'Hospitals',
    },
    {
      'id': 'mixed',
      'icon': Icons.business_center,
      'title': 'Mixt',
      'subtitle': 'Edificis amb usos combinats',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuildRank'),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text('Torna'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 6),

          const Chip(
            label: Text('Nou Edifici'),
            backgroundColor: Color(0xFFE4F6EA),
          ),

          const SizedBox(height: 10),

          const Text(
            "Registra l'edifici",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Completa les dades tècniques per obtenir el teu rànquing energètic.",
            style: TextStyle(
              color: Colors.black54,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          const _StepIndicator(),

          const SizedBox(height: 24),

          const Text(
            "UBICACIÓ",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          const Text("Adreça"),

          const SizedBox(height: 6),

          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: "p. ex., C/ Verda 123, Eco City",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Tipologia de l'edifici",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _buildingTypes.length,
              itemBuilder: (context, index) {
                final type = _buildingTypes[index];

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == _buildingTypes.length - 1 ? 0 : 12,
                  ),
                  child: _BuildingTypeCard(
                    icon: type['icon'],
                    title: type['title'],
                    subtitle: type['subtitle'],
                    selected: _selectedType == type['id'],
                    onTap: () {
                      setState(() {
                        _selectedType = type['id'];
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5ED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Consell: Una tipologia acurada ens ajuda a comparar el teu edifici amb d'altres similars.",
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: () {
              // TODO: enviar dades
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF25C05A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Desa i Continua →",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StepCircle(number: 1, active: true),
        Expanded(child: Divider()),
        _StepCircle(number: 2),
        Expanded(child: Divider()),
        _StepCircle(number: 3),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int number;
  final bool active;

  const _StepCircle({
    required this.number,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: active ? Colors.green : Colors.grey.shade300,
      child: Text(
        number.toString(),
        style: TextStyle(
          color: active ? Colors.white : Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _BuildingTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _BuildingTypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE7F6EC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.green : const Color(0xFFE4E7E2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}