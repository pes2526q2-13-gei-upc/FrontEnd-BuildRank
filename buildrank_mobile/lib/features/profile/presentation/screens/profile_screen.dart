import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/formBuilding/presentation/screens/form_building_screen.dart';
import 'package:buildrank_mobile/shared/widgets/building_list_item.dart';
import 'package:buildrank_mobile/shared/widgets/badge_item.dart';
import 'package:buildrank_mobile/features/myChat/my_chats_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();

  bool _isLoading = true;
  bool _isLoggingOut = false;
  String? _errorText;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final user = await _authService.getMe();

      if (!mounted) return;

      setState(() {
        _userData = user;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await _authService.logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthBaseScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  String _buildFullName() {
    final firstName = (_userData?['first_name'] ?? '').toString().trim();
    final lastName = (_userData?['last_name'] ?? '').toString().trim();

    final fullName = '$firstName $lastName'.trim();
    if (fullName.isNotEmpty) return fullName;

    return (_userData?['email'] ?? 'Usuari').toString();
  }

  String _buildRoleLabel() {
    final role = (_userData?['role'] ?? '').toString();

    switch (role) {
      case 'owner':
        return 'Administrador de finca';
      case 'tenant':
        return 'Llogater';
      case 'admin':
        return 'Administrador';
      default:
        return 'Usuari';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/logoSimple.png"),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadProfile,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _isLoggingOut ? null : _handleLogout,
            icon: _isLoggingOut
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorText != null
          ? _buildErrorState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildUserCard(),

                const SizedBox(height: 16),

                Column(
                  children: [
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
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyChatsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text("Els meus xats"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildSeasonCard(),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Els meus edificis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Veure Tots", style: TextStyle(color: Colors.green)),
                  ],
                ),

                const SizedBox(height: 10),

                BuildingListItem(
                  title: "Torre Crystal Heights",
                  address: "452 Skyline Blvd, Central District",
                  score: 88,
                  status: "Certificat",
                ),
                BuildingListItem(
                  title: "Greenwood Resident",
                  address: "12 Oakwood Ave, North Sector",
                  score: 74,
                  status: "Verificat",
                ),
                BuildingListItem(
                  title: "Industrial Bay Plaza",
                  address: "Carrer de la Indústria, 123",
                  score: 52,
                  status: "Actiu",
                ),
                BuildingListItem(
                  title: "Legacy Heritage Suite",
                  address: "Carrer de la Indústria, 123",
                  score: 38,
                  status: "Actiu",
                ),

                const SizedBox(height: 20),

                const Text(
                  "Insígnies Actives",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

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
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(
              _errorText ?? 'No s’ha pogut carregar el perfil.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Torna-ho a provar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    final email = (_userData?['email'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(radius: 25),
            title: Text(_buildFullName()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_buildRoleLabel()),
                if (email.isNotEmpty) Text(email),
              ],
            ),
          ),
          const Divider(),
          const Row(
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

  Widget _buildSeasonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Proper reinici de temporada",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(value: 0.7),
          SizedBox(height: 8),
          Text("Queden 12 dies", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

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
