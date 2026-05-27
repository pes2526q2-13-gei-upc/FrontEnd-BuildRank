import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/formBuilding/data/building_service.dart';
import 'package:buildrank_mobile/features/formBuilding/presentation/screens/form_building_screen.dart';
import 'package:buildrank_mobile/features/myChat/my_chats_screen.dart';
import 'package:buildrank_mobile/features/notifications/data/notifications_service.dart';
import 'package:buildrank_mobile/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:buildrank_mobile/shared/widgets/building_list_item.dart';
import 'package:buildrank_mobile/features/weather/data/weather_service.dart';
import 'package:buildrank_mobile/features/weather/presentation/widgets/weather_alert_card.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/add_existing_building_screen.dart';
import 'package:buildrank_mobile/features/map/presentation/screens/building_map_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService? authService;
  final BuildingService? buildingService;
  final NotificacionsService? notificacionsService;
  final WeatherService? weatherService;

  const ProfileScreen({
    super.key,
    this.authService,
    this.buildingService,
    this.notificacionsService,
    this.weatherService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  late final AuthService _authService;
  late final BuildingService _buildingService;
  late final NotificacionsService _notificacionsService;

  bool _showWeatherAlert = true;

  bool _isLoading = true;
  bool _isLoggingOut = false;
  String? _errorText;
  int _noLlegides = 0;

  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>> _buildings = [];

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    _buildingService = widget.buildingService ?? BuildingService();
    _notificacionsService =
        widget.notificacionsService ?? NotificacionsService();
    WidgetsBinding.instance.addObserver(this);
    _loadProfile();
    _loadNoLlegides();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadNoLlegides();
  }

  Future<void> _loadNoLlegides() async {
    final count = await _notificacionsService.getNoLlegides();
    if (mounted) setState(() => _noLlegides = count);
  }

  Future<void> _openNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(
          userRole: _role,
          onBadgeUpdate: _loadNoLlegides,
        ),
      ),
    );
  }

  String get _role => (_userData?['role'] ?? '').toString();

  bool get _isAdminFinca => _role == 'admin';

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final user = await _authService.getMe();
      final buildings = await _buildingService.getMyBuildings();

      if (!mounted) return;

      setState(() {
        _userData = user;
        _buildings = buildings;
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

    return (_userData?['email'] ??
            AppLocalizations.of(context).profileUserFallback)
        .toString();
  }

  String _buildRoleLabel() {
    final l10n = AppLocalizations.of(context);
    switch (_role) {
      case 'admin':
        return l10n.profileRoleAdmin;
      case 'owner':
        return l10n.profileRoleOwner;
      case 'tenant':
        return l10n.profileRoleTenant;
      default:
        return l10n.profileUserFallback;
    }
  }

  String _buildBuildingsSectionTitle() {
    final l10n = AppLocalizations.of(context);
    switch (_role) {
      case 'admin':
        return l10n.profileAdminBuildingsTitle;
      case 'owner':
        return l10n.profileOwnerBuildingsTitle;
      case 'tenant':
        return l10n.profileTenantBuildingsTitle;
      default:
        return l10n.profileAccessibleBuildingsTitle;
    }
  }

  String _buildEmptyBuildingsMessage() {
    final l10n = AppLocalizations.of(context);
    switch (_role) {
      case 'admin':
        return l10n.profileEmptyAdminBuildings;
      case 'owner':
        return l10n.profileEmptyOwnerBuildings;
      case 'tenant':
        return l10n.profileEmptyTenantBuildings;
      default:
        return l10n.profileEmptyAccessibleBuildings;
    }
  }

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialFullName: _buildFullName(),
          initialEmail: (_userData?['email'] ?? '').toString(),
          initialAvatarUrl: (_userData?['avatar_url'] ?? '').toString(),
        ),
      ),
    );

    if (!mounted) return;

    if (updated == true) {
      await _loadProfile();
    }
  }

  Future<void> _openCreateBuilding() async {
    final createdBuilding = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const BuildingFormScreen()),
    );

    if (!mounted) return;

    if (createdBuilding != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).profileBuildingCreated),
        ),
      );
    }

    await _loadProfile();
  }

  Future<void> _openBuildingMap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BuildingMapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            tooltip: l10n.notificationsTitle,
            onPressed: _openNotifications,
            icon: Badge(
              label: Text('$_noLlegides'),
              isLabelVisible: _noLlegides > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            tooltip: l10n.commonRefresh,
            onPressed: _isLoading ? null : _loadProfile,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: l10n.profileLogoutTooltip,
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
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildUserCard(),

                  if (_showWeatherAlert) ...[
                    const SizedBox(height: 16),
                    WeatherAlertCard(
                      service: widget.weatherService,
                      onDismiss: () {
                        setState(() {
                          _showWeatherAlert = false;
                        });
                      },
                    ),
                  ],

                  const SizedBox(height: 16),

                  _buildRoleActions(),

                  const SizedBox(height: 16),

                  _buildMapAccessCard(),

                  const SizedBox(height: 20),

                  _buildBuildingsHeader(),

                  const SizedBox(height: 10),

                  _buildBuildingsList(),

                  const SizedBox(height: 20),

                  _buildBadgesSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildRoleActions() {
    if (_isAdminFinca) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openCreateBuilding,
                  icon: const Icon(Icons.add_business_outlined),
                  label: Text(
                    AppLocalizations.of(context).profileCreateBuilding,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyChatsScreen()),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text(AppLocalizations.of(context).myChatsTitle),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Text(
        AppLocalizations.of(context).profileNonAdminInfo,
        style: TextStyle(
          fontSize: 13,
          height: 1.35,
          color: Colors.green.shade900,
        ),
      ),
    );
  }

  Widget _buildMapAccessCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: _openBuildingMap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF8F1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.map_outlined, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).mapTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).profileMapSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 17),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingsHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _buildBuildingsSectionTitle(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "${_buildings.length}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddExistingBuildingScreen(userRole: _role),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              AppLocalizations.of(context).profileLinkNewBuilding,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingsList() {
    if (_buildings.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          _buildEmptyBuildingsMessage(),
          style: const TextStyle(height: 1.35),
        ),
      );
    }

    return Column(
      children: [
        for (final building in _buildings)
          if (_readInt(building, const ['idEdifici', 'id']) != null)
            BuildingListItem(
              idEdifici: _readInt(building, const ['idEdifici', 'id'])!,
              title: _buildBuildingTitle(building),
              address: _buildBuildingAddress(building),
              score: _readScore(building),
              status: _buildBuildingStatus(building),
              userRole: _role,
              building: building,
            ),
      ],
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
              _errorText ?? AppLocalizations.of(context).profileLoadError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: Text(AppLocalizations.of(context).commonRetry),
            ),
          ],
        ),
      ),
    );
  }

  String? _currentAvatarUrl() {
    final value = _userData?['avatar_url']?.toString().trim();
    if (value == null || value.isEmpty || value == 'null') return null;
    return value;
  }

  String _avatarInitial() {
    final fullName = _buildFullName().trim();
    if (fullName.isNotEmpty) {
      return fullName.characters.first.toUpperCase();
    }

    final email = (_userData?['email'] ?? '').toString().trim();
    if (email.isNotEmpty) {
      return email.characters.first.toUpperCase();
    }

    return '?';
  }

  Widget _buildUserAvatar() {
    final avatarUrl = _currentAvatarUrl();

    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.green.shade100,
      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
      child: avatarUrl == null
          ? Text(
              _avatarInitial(),
              style: TextStyle(
                color: Colors.green.shade900,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            )
          : null,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _buildFullName(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_buildRoleLabel()),
                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(email),
                      ],
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: AppLocalizations.of(context).editProfileTitle,
                onPressed: _openEditProfile,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Metric(
                title: _buildings.length.toString(),
                subtitle: _isAdminFinca
                    ? AppLocalizations.of(context).profileMetricBuildings
                    : AppLocalizations.of(context).profileMetricLinks,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7EADF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.emoji_events_outlined, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).profileBadgesTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context).profileBadgesBody,
                  style: const TextStyle(color: Colors.black54, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildBuildingTitle(Map<String, dynamic> building) {
    final localitzacio = _readMap(building['localitzacio']);
    final carrer = localitzacio?['carrer']?.toString().trim();
    final numero = localitzacio?['numero']?.toString().trim();

    if (carrer != null && carrer.isNotEmpty) {
      return numero != null && numero.isNotEmpty ? '$carrer, $numero' : carrer;
    }

    final id = _readInt(building, const ['idEdifici', 'id']);
    final l10n = AppLocalizations.of(context);
    return id != null ? l10n.profileBuildingNumber(id) : l10n.homeBuildingTitle;
  }

  String _buildBuildingAddress(Map<String, dynamic> building) {
    final localitzacio = _readMap(building['localitzacio']);

    if (localitzacio == null) {
      return AppLocalizations.of(context).profileLocationUnavailable;
    }

    final barri = localitzacio['barri']?.toString().trim();
    final codiPostal = localitzacio['codiPostal']?.toString().trim();
    final zona = localitzacio['zonaClimatica']?.toString().trim();

    final parts = [
      if (barri != null && barri.isNotEmpty) barri,
      if (codiPostal != null && codiPostal.isNotEmpty) codiPostal,
      if (zona != null && zona.isNotEmpty)
        AppLocalizations.of(context).twinClimateZone(zona),
    ];

    return parts.isEmpty
        ? AppLocalizations.of(context).profileLocationUnavailable
        : parts.join(' · ');
  }

  String _buildBuildingStatus(Map<String, dynamic> building) {
    final actiu = building['actiu'];
    if (actiu == false) return AppLocalizations.of(context).profileInactive;
    return AppLocalizations.of(context).profileActive;
  }

  int _readScore(Map<String, dynamic> building) {
    final value = building['puntuacioBase'];

    if (value is int) return value.clamp(0, 100);
    if (value is double) return value.round().clamp(0, 100);
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed.round().clamp(0, 100);
    }

    return 0;
  }

  int? _readInt(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];

      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }

    return null;
  }

  Map<String, dynamic>? _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
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
