import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/audit_logs_screen.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/user_management_screen.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:flutter/material.dart';

import '../../../myChat/my_chats_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  final String adminName;
  final int seasonNumber;
  final bool isSystemAdmin;

  const AdminPanelScreen({
    super.key,
    this.adminName = 'Governant BuildRank',
    this.seasonNumber = 4,
    this.isSystemAdmin = true,
  });

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

enum _AdminTab { tasks, seasons, roles }

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<_VerificationTask> _tasks = _VerificationTask.samples();
  final List<_SeasonRow> _seasons = _SeasonRow.samples();
  final List<_RoleRow> _roles = _RoleRow.samples();

  _AdminTab _selectedTab = _AdminTab.tasks;
  String _search = '';
  final _authService = AuthService();
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _search = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      try {
        await StreamService.disconnectUser();
      } catch (_) {}

      await _authService.logout();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthBaseScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;

      _showSnackBar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSystemAdmin) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F7F2),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No tens permisos per accedir al panell d’administració del sistema.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
            children: [
              _buildTopBar(),
              const SizedBox(height: 22),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildMetricCards(),
              const SizedBox(height: 22),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildTabs(),
              const SizedBox(height: 16),
              _buildSelectedPanel(),
              const SizedBox(height: 24),
              _buildChatModerationCard(),
              const SizedBox(height: 14),
              _buildUserManagementCard(),
              const SizedBox(height: 22),
              _buildIntegrityAlert(),
              const SizedBox(height: 36),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _isLoggingOut ? null : _handleLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF19C463),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFB7E8CB),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: _isLoggingOut
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.logout, size: 18),
          label: Text(
            _isLoggingOut ? 'Sortint...' : 'Tanca sessió',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE6F7EC),
              child: Text(
                'BR',
                style: TextStyle(
                  color: Color(0xFF126E3A),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFF19C463),
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Panell d’administració',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF14181F),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.adminName} · Temporada ${widget.seasonNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _showAuditSnackBar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF19C463),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.verified_user_outlined, size: 18),
          label: const Text(
            'Auditoria',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCards() {
    final pending = _tasks
        .where((task) => task.status == _TaskStatus.pending)
        .length;
    final verified = _tasks
        .where((task) => task.status == _TaskStatus.verified)
        .length;

    return SizedBox(
      height: 126,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _MetricCard(
            icon: Icons.error_outline,
            title: pending.toString(),
            subtitle: 'Verificacions pendents',
            trend: '+12%',
            iconBackground: const Color(0xFFE5F9ED),
            iconColor: const Color(0xFF19C463),
          ),
          const SizedBox(width: 12),
          const _MetricCard(
            icon: Icons.groups_2_outlined,
            title: '1,284',
            subtitle: 'Usuaris actius',
            trend: '+5.4%',
            iconBackground: Color(0xFFE5F9ED),
            iconColor: Color(0xFF19C463),
          ),
          const SizedBox(width: 12),
          _MetricCard(
            icon: Icons.verified_outlined,
            title: verified.toString(),
            subtitle: 'Millores validades',
            trend: '+8%',
            iconBackground: const Color(0xFFEAF2FF),
            iconColor: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          const _MetricCard(
            icon: Icons.warning_amber_rounded,
            title: '5',
            subtitle: 'Alertes d’integritat',
            trend: 'Nou',
            iconBackground: Color(0xFFFFF7E6),
            iconColor: Color(0xFFE08A00),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cerca edificis o usuaris...',
        hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
        suffixIcon: IconButton(
          onPressed: _showFiltersSnackBar,
          icon: const Icon(Icons.filter_list, color: Color(0xFF4B5563)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE2E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE2E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF19C463), width: 1.4),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDE2E8)),
      ),
      child: Row(
        children: [
          _AdminTabButton(
            label: 'Tasques',
            selected: _selectedTab == _AdminTab.tasks,
            onTap: () => setState(() => _selectedTab = _AdminTab.tasks),
          ),
          _AdminTabButton(
            label: 'Temporades',
            selected: _selectedTab == _AdminTab.seasons,
            onTap: () => setState(() => _selectedTab = _AdminTab.seasons),
          ),
          _AdminTabButton(
            label: 'Rols',
            selected: _selectedTab == _AdminTab.roles,
            onTap: () => setState(() => _selectedTab = _AdminTab.roles),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPanel() {
    return switch (_selectedTab) {
      _AdminTab.tasks => _buildVerificationQueue(),
      _AdminTab.seasons => _buildSeasonsPanel(),
      _AdminTab.roles => _buildRolesPanel(),
    };
  }

  Widget _buildVerificationQueue() {
    final filteredTasks = _tasks.where((task) {
      if (_search.isEmpty) return true;
      return task.title.toLowerCase().contains(_search) ||
          task.category.toLowerCase().contains(_search) ||
          task.status.label.toLowerCase().contains(_search);
    }).toList();

    return _PanelCard(
      title: 'Cua de verificació',
      badge: '${filteredTasks.length} actius',
      children: [
        if (filteredTasks.isEmpty)
          const _EmptyState(
            icon: Icons.fact_check_outlined,
            title: 'No hi ha tasques coincidents',
            subtitle: 'Canvia la cerca o el filtre per veure més resultats.',
          )
        else
          for (final task in filteredTasks)
            _VerificationTaskTile(
              task: task,
              onApprove: () => _updateTaskStatus(task.id, _TaskStatus.verified),
              onReject: () => _updateTaskStatus(task.id, _TaskStatus.rejected),
            ),
        _PanelActionButton(
          label: 'Veure totes les tasques de verificació',
          onTap: _showAllTasksSnackBar,
        ),
      ],
    );
  }

  Widget _buildSeasonsPanel() {
    return _PanelCard(
      title: 'Gestió de temporades',
      badge: '${_seasons.length} registres',
      children: [
        for (final season in _seasons) _SeasonTile(season: season),
        _PanelActionButton(
          label: 'Crear nova temporada',
          icon: Icons.add,
          onTap: _showCreateSeasonSnackBar,
        ),
      ],
    );
  }

  Widget _buildRolesPanel() {
    return _PanelCard(
      title: 'Rols i permisos',
      badge: '${_roles.length} rols',
      children: [
        for (final role in _roles) _RoleTile(role: role),
        _PanelActionButton(
          label: 'Revisar matriu de permisos',
          icon: Icons.admin_panel_settings_outlined,
          onTap: _showRolesSnackBar,
        ),
      ],
    );
  }

  Widget _buildChatModerationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE2E8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F9ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    color: Color(0xFF19C463),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moderació de xats',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Accedeix als xats dels edificis i aplica accions de moderació.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EA)),
          _PanelActionButton(
            label: 'Accedir als xats dels edificis',
            icon: Icons.chat_bubble_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyChatsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserManagementCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE2E8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.manage_accounts_outlined,
                    color: Color(0xFF2563EB),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gestió d\'usuaris',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Bloqueja, suspèn i gestiona els comptes dels usuaris.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EA)),
          _PanelActionButton(
            label: 'Accedir a la gestió d\'usuaris',
            icon: Icons.manage_accounts,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserManagementScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrityAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAFBF1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFF19C463), size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Alerta d’integritat de dades',
                  style: TextStyle(
                    color: Color(0xFF19C463),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              '5 edificis de la categoria “Comercial” han presentat dades que superen els punts de referència històrics en més d’un 20%. Cal una auditoria manual.',
              style: TextStyle(
                color: Color(0xFF51606F),
                fontSize: 13,
                height: 1.28,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: InkWell(
              onTap: _showAuditSnackBar,
              borderRadius: BorderRadius.circular(6),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Executa l’auditoria d’integritat ara',
                  style: TextStyle(
                    color: Color(0xFF19C463),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Divider(height: 1, color: Color(0xFFE2E6EA)),
        SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 8,
          children: [
            Text(
              '© 2026 BuildRank Performance Systems.',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            ),
            Text(
              'Política de privacitat',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            ),
            Text(
              'Termes del servei',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  void _updateTaskStatus(String taskId, _TaskStatus status) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index == -1) return;
      _tasks[index] = _tasks[index].copyWith(status: status);
    });

    final message = switch (status) {
      _TaskStatus.verified => 'Verificació aprovada',
      _TaskStatus.rejected => 'Verificació rebutjada',
      _TaskStatus.pending => 'Verificació pendent',
    };

    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showAuditSnackBar() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AuditLogsScreen()),
  );

  void _showFiltersSnackBar() =>
      _showSnackBar('Filtres avançats pendents d’integració.');

  void _showAllTasksSnackBar() =>
      _showSnackBar('Vista completa de tasques pendent d’integració.');

  void _showCreateSeasonSnackBar() =>
      _showSnackBar('Creació de temporada pendent d’integració.');

  void _showRolesSnackBar() =>
      _showSnackBar('Matriu de permisos pendent d’integració.');
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trend;
  final Color iconBackground;
  final Color iconColor;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trend,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const Spacer(),
              Text(
                trend,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 26,
              height: 1,
              fontWeight: FontWeight.w900,
              color: Color(0xFF14181F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF5D6673),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AdminTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF9FAFB) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: selected
                  ? const Color(0xFF111827)
                  : const Color(0xFF596575),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  final String title;
  final String badge;
  final List<Widget> children;

  const _PanelCard({
    required this.title,
    required this.badge,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E6EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E6EA)),
          ...children,
        ],
      ),
    );
  }
}

class _VerificationTaskTile extends StatelessWidget {
  final _VerificationTask task;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _VerificationTaskTile({
    required this.task,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E9ED))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFDDE2E8)),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.apartment_outlined,
              color: Color(0xFF607080),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF20252C),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${task.category} • Fa ${task.age}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _StatusPill(status: task.status),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              _CircleActionButton(
                icon: Icons.check_circle_outline,
                color: const Color(0xFF1F2937),
                onTap: onApprove,
                tooltip: 'Aprova',
              ),
              const SizedBox(height: 8),
              _CircleActionButton(
                icon: Icons.cancel_outlined,
                color: const Color(0xFFFF5555),
                onTap: onReject,
                tooltip: 'Rebutja',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final _TaskStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final background = switch (status) {
      _TaskStatus.pending => Colors.white,
      _TaskStatus.verified => const Color(0xFF4B5563),
      _TaskStatus.rejected => const Color(0xFFFFE8E8),
    };

    final foreground = switch (status) {
      _TaskStatus.pending => const Color(0xFF20252C),
      _TaskStatus.verified => Colors.white,
      _TaskStatus.rejected => const Color(0xFFD92D20),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: status == _TaskStatus.pending
              ? const Color(0xFFDDE2E8)
              : Colors.transparent,
        ),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

class _PanelActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PanelActionButton({
    required this.label,
    required this.onTap,
    this.icon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF19C463),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 17, color: const Color(0xFF19C463)),
          ],
        ),
      ),
    );
  }
}

class _SeasonTile extends StatelessWidget {
  final _SeasonRow season;

  const _SeasonTile({required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E9ED))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFDDE2E8)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFF607080),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  season.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${season.range} · ${season.participants} edificis',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _SmallLabel(
            text: season.isActive ? 'ACTIVA' : 'TANCADA',
            active: season.isActive,
          ),
        ],
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final _RoleRow role;

  const _RoleTile({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6E9ED))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFDDE2E8)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(role.icon, color: const Color(0xFF607080)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${role.users} usuaris · ${role.permissions} permisos',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

class _SmallLabel extends StatelessWidget {
  final String text;
  final bool active;

  const _SmallLabel({required this.text, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEAFBF1) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? const Color(0xFF19A658) : const Color(0xFF4B5563),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Icon(icon, size: 34, color: const Color(0xFF9CA3AF)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

enum _TaskStatus {
  pending('Pendent'),
  verified('Verificat'),
  rejected('Rebutjat');

  final String label;
  const _TaskStatus(this.label);
}

class _VerificationTask {
  final String id;
  final String title;
  final String category;
  final String age;
  final _TaskStatus status;

  const _VerificationTask({
    required this.id,
    required this.title,
    required this.category,
    required this.age,
    required this.status,
  });

  _VerificationTask copyWith({_TaskStatus? status}) {
    return _VerificationTask(
      id: id,
      title: title,
      category: category,
      age: age,
      status: status ?? this.status,
    );
  }

  static List<_VerificationTask> samples() {
    return const [
      _VerificationTask(
        id: 'skyline-plaza',
        title: 'Skyline Plaza',
        category: 'Comercial',
        age: '2h',
        status: _TaskStatus.pending,
      ),
      _VerificationTask(
        id: 'green-valley',
        title: 'Green Valley Apts',
        category: 'Residencial',
        age: '5h',
        status: _TaskStatus.pending,
      ),
      _VerificationTask(
        id: 'tech-hub-v3',
        title: 'Tech Hub V3',
        category: 'Oficina',
        age: '1d',
        status: _TaskStatus.verified,
      ),
    ];
  }
}

class _SeasonRow {
  final String name;
  final String range;
  final int participants;
  final bool isActive;

  const _SeasonRow({
    required this.name,
    required this.range,
    required this.participants,
    required this.isActive,
  });

  static List<_SeasonRow> samples() {
    return const [
      _SeasonRow(
        name: 'Temporada 4 · Estiu 2026',
        range: 'Abr 2026 - Set 2026',
        participants: 1284,
        isActive: true,
      ),
      _SeasonRow(
        name: 'Temporada 3 · Hivern 2026',
        range: 'Oct 2025 - Mar 2026',
        participants: 1038,
        isActive: false,
      ),
    ];
  }
}

class _RoleRow {
  final String name;
  final int users;
  final int permissions;
  final IconData icon;

  const _RoleRow({
    required this.name,
    required this.users,
    required this.permissions,
    required this.icon,
  });

  static List<_RoleRow> samples() {
    return const [
      _RoleRow(
        name: 'Administrador de sistema',
        users: 6,
        permissions: 18,
        icon: Icons.admin_panel_settings_outlined,
      ),
      _RoleRow(
        name: 'Administrador de finca',
        users: 214,
        permissions: 11,
        icon: Icons.manage_accounts_outlined,
      ),
      _RoleRow(
        name: 'Propietari / Llogater',
        users: 1064,
        permissions: 7,
        icon: Icons.person_outline,
      ),
    ];
  }
}
