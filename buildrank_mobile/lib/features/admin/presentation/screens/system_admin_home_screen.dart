import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/admin/data/admin_dashboard_service.dart';
import 'package:buildrank_mobile/features/admin/data/admin_dashboard_summary.dart';
import 'package:buildrank_mobile/features/admin/data/admin_improvement_validation_service.dart';
import 'package:buildrank_mobile/features/admin/data/implemented_improvement_validation.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/audit_logs_screen.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/user_management_screen.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/seasons/data/season_models.dart';
import 'package:buildrank_mobile/features/seasons/data/season_service.dart';
import 'package:buildrank_mobile/features/verification/data/admin_verification_service.dart';
import 'package:flutter/material.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:buildrank_mobile/features/legal/presentation/screens/legal_document_screen.dart';

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

enum _AdminTab { tasks, seasons, improvements }

class _SeasonCreationFormData {
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const _SeasonCreationFormData({
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AdminVerificationService _verificationService =
      const AdminVerificationService();
  final SeasonService _seasonService = const SeasonService();
  final AdminDashboardService _dashboardService = const AdminDashboardService();
  final AdminImprovementValidationService _improvementValidationService =
      const AdminImprovementValidationService();

  _AdminTab _selectedTab = _AdminTab.tasks;
  String _search = '';
  final _authService = AuthService();
  bool _isLoggingOut = false;
  bool _isLoadingVerifications = true;
  String? _verificationError;
  List<AdminVerificationItem> _verifications = [];
  final Set<int> _processingVerificationIds = {};
  bool _isLoadingSeasons = true;
  bool _isCreatingSeason = false;
  String? _seasonsError;
  List<Season> _seasons = [];
  AdminDashboardSummary _dashboardSummary = AdminDashboardSummary.empty();
  bool _isLoadingDashboardSummary = true;
  String? _dashboardError;
  bool _isLoadingImprovements = true;
  String? _improvementsError;
  List<ImplementedImprovementValidationItem> _pendingImprovements = [];
  final Set<int> _processingImprovementIds = {};

  List<_VerificationTask> get _tasks {
    return _verifications.map(_VerificationTask.fromVerification).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _search = _searchController.text.trim().toLowerCase());
    });
    _loadDashboardSummary();
    _loadVerifications();
    _loadSeasons();
    _loadPendingImprovements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait([
      _loadDashboardSummary(),
      _loadVerifications(),
      _loadSeasons(),
      _loadPendingImprovements(),
    ]);
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppLocalizations.of(context).adminHomeNoAccessPermission,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
            _isLoggingOut
                ? AppLocalizations.of(context).adminHomeLoggingOut
                : AppLocalizations.of(context).adminHomeLogoutButton,
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
              Text(
                AppLocalizations.of(context).adminHomePanelTitle,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF14181F),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.adminName} · ${AppLocalizations.of(context).adminHomeSeasonLabel(widget.seasonNumber)}',
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
          label: Text(
            AppLocalizations.of(context).adminHomeAuditButton,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCards() {
    final pendingVerificationsFallback = _verifications
        .where((item) => item.status.toLowerCase() == 'review')
        .length;
    final validatedVerificationsFallback = _verifications
        .where((item) => item.status.toLowerCase() == 'approved')
        .length;

    final summary = _dashboardSummary;
    final pendingVerifications = summary.hasRealData
        ? summary.pendingVerifications
        : pendingVerificationsFallback;
    final totalUsers = summary.totalUsers;
    final pendingImprovements = summary.hasRealData
        ? summary.pendingImprovements
        : _pendingImprovements.length;
    final managedBuildings = summary.managedBuildings;
    final validatedImprovements = summary.hasRealData
        ? summary.validatedImprovements
        : validatedVerificationsFallback;

    final trend = _isLoadingDashboardSummary
        ? '...'
        : _dashboardError == null
        ? 'API'
        : 'local';

    return SizedBox(
      height: 126,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _MetricCard(
            icon: Icons.error_outline,
            title: pendingVerifications.toString(),
            subtitle: AppLocalizations.of(context).adminHomeVerificationPending,
            trend: trend,
            iconBackground: const Color(0xFFE5F9ED),
            iconColor: const Color(0xFF19C463),
          ),
          const SizedBox(width: 12),
          _MetricCard(
            icon: Icons.groups_2_outlined,
            title: totalUsers.toString(),
            subtitle: AppLocalizations.of(context).adminHomeTotalUsers,
            trend: trend,
            iconBackground: const Color(0xFFE5F9ED),
            iconColor: const Color(0xFF19C463),
          ),
          const SizedBox(width: 12),
          _MetricCard(
            icon: Icons.handyman_outlined,
            title: pendingImprovements.toString(),
            subtitle: AppLocalizations.of(context).adminHomePendingImprovements,
            trend: trend,
            iconBackground: const Color(0xFFEAF2FF),
            iconColor: const Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          _MetricCard(
            icon: Icons.apartment_outlined,
            title: managedBuildings == 0
                ? validatedImprovements.toString()
                : managedBuildings.toString(),
            subtitle: managedBuildings == 0
                ? AppLocalizations.of(context).adminHomeValidatedImprovements
                : AppLocalizations.of(context).adminHomeManagedBuildings,
            trend: trend,
            iconBackground: const Color(0xFFFFF7E6),
            iconColor: const Color(0xFFE08A00),
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
        hintText: AppLocalizations.of(context).adminHomeSearchHint,
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
            label: AppLocalizations.of(context).adminHomeTasksTab,
            selected: _selectedTab == _AdminTab.tasks,
            onTap: () => setState(() => _selectedTab = _AdminTab.tasks),
          ),
          _AdminTabButton(
            label: AppLocalizations.of(context).adminHomeSeasonsTab,
            selected: _selectedTab == _AdminTab.seasons,
            onTap: () => setState(() => _selectedTab = _AdminTab.seasons),
          ),
          _AdminTabButton(
            label: AppLocalizations.of(context).adminHomeImprovementsTab,
            selected: _selectedTab == _AdminTab.improvements,
            onTap: () => setState(() => _selectedTab = _AdminTab.improvements),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPanel() {
    return switch (_selectedTab) {
      _AdminTab.tasks => _buildVerificationQueue(),
      _AdminTab.seasons => _buildSeasonsPanel(),
      _AdminTab.improvements => _buildImprovementsPanel(),
    };
  }

  Widget _buildVerificationQueue() {
    final reviewTasks = _tasks
        .where((task) => task.status == _TaskStatus.pending)
        .toList();

    final filteredTasks = reviewTasks.where((task) {
      if (_search.isEmpty) return true;
      return task.title.toLowerCase().contains(_search) ||
          task.category.toLowerCase().contains(_search) ||
          task.requester.toLowerCase().contains(_search) ||
          task.status.label.toLowerCase().contains(_search);
    }).toList();

    return _PanelCard(
      title: AppLocalizations.of(context).adminHomeVerificationQueue,
      badge: AppLocalizations.of(
        context,
      ).adminHomePendingCount(filteredTasks.length),
      children: [
        if (_isLoadingVerifications)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_verificationError != null)
          _EmptyState(
            icon: Icons.error_outline,
            title: AppLocalizations.of(context).adminHomeVerificationLoadError,
            subtitle: _verificationError!,
          )
        else if (filteredTasks.isEmpty)
          _EmptyState(
            icon: Icons.fact_check_outlined,
            title: AppLocalizations.of(context).adminHomeNoPendingVerifications,
            subtitle: AppLocalizations.of(
              context,
            ).adminHomeNoPendingVerificationsBody,
          )
        else
          for (final task in filteredTasks)
            _VerificationTaskTile(
              task: task,
              isProcessing: _processingVerificationIds.contains(
                task.verificationId,
              ),
              onApprove: () => _reviewVerification(task.verificationId, true),
              onReject: () => _reviewVerification(task.verificationId, false),
            ),
        _PanelActionButton(
          label: AppLocalizations.of(context).adminHomeRefreshVerifications,
          onTap: _loadVerifications,
        ),
      ],
    );
  }

  Widget _buildSeasonsPanel() {
    final l10n = AppLocalizations.of(context);

    return _PanelCard(
      title: l10n.adminHomeSeasonManagement,
      badge: _isLoadingSeasons
          ? l10n.adminHomeSeasonsLoading
          : l10n.adminHomeClosedSeasonsCount(_seasons.length),
      children: [
        if (_isLoadingSeasons)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_seasonsError != null)
          _EmptyState(
            icon: Icons.error_outline,
            title: l10n.adminHomeSeasonLoadErrorTitle,
            subtitle: _seasonsError!,
          )
        else if (_seasons.isEmpty)
          _EmptyState(
            icon: Icons.calendar_month_outlined,
            title: l10n.adminHomeNoClosedSeasonsTitle,
            subtitle: l10n.adminHomeNoClosedSeasonsBody,
          )
        else
          for (final season in _seasons) _SeasonTile(season: season),
        _PanelActionButton(
          label: _isCreatingSeason
              ? l10n.adminHomeCreatingAndStartingSeason
              : l10n.adminHomeCreateAndStartSeason,
          icon: _isCreatingSeason ? Icons.hourglass_top : Icons.add,
          onTap: _isCreatingSeason ? null : _confirmCreateAndStartSeason,
        ),
        _PanelActionButton(
          label: _seasonsError == null
              ? l10n.adminHomeRefreshSeasonHistory
              : l10n.adminHomeRetryLoadSeasons,
          icon: Icons.refresh,
          onTap: _loadSeasons,
        ),
      ],
    );
  }

  Widget _buildImprovementsPanel() {
    final filteredImprovements = _pendingImprovements.where((item) {
      if (_search.isEmpty) return true;
      return item.improvementName.toLowerCase().contains(_search) ||
          item.edificiTitle.toLowerCase().contains(_search) ||
          item.requesterName.toLowerCase().contains(_search) ||
          item.requesterEmail.toLowerCase().contains(_search) ||
          item.status.toLowerCase().contains(_search);
    }).toList();

    return _PanelCard(
      title: AppLocalizations.of(context).adminHomeImprovementValidationQueue,
      badge: AppLocalizations.of(
        context,
      ).adminHomePendingCount(filteredImprovements.length),
      children: [
        if (_isLoadingImprovements)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_improvementsError != null)
          _EmptyState(
            icon: Icons.error_outline,
            title: AppLocalizations.of(context).adminHomeImprovementLoadError,
            subtitle: _improvementsError!,
          )
        else if (filteredImprovements.isEmpty)
          _EmptyState(
            icon: Icons.handyman_outlined,
            title: AppLocalizations.of(context).adminHomeNoPendingImprovements,
            subtitle: AppLocalizations.of(
              context,
            ).adminHomeNoPendingImprovementsBody,
          )
        else
          for (final improvement in filteredImprovements)
            _PendingImprovementTile(
              item: improvement,
              isProcessing: _processingImprovementIds.contains(improvement.id),
              onApprove: () => _reviewImprovement(improvement.id, true),
              onReject: () => _reviewImprovement(improvement.id, false),
            ),
        _PanelActionButton(
          label: AppLocalizations.of(context).adminHomeRefreshImprovements,
          icon: Icons.refresh,
          onTap: _loadPendingImprovements,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        ).adminHomeChatsModerationTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context).adminHomeChatsBody,
                        style: const TextStyle(
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
            label: AppLocalizations.of(context).adminHomeOpenBuildingChats,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).adminUsersTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context).adminHomeUsersBody,
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
            label: AppLocalizations.of(context).adminHomeOpenUsers,
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
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: Color(0xFF19C463),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppLocalizations.of(context).adminHomeIntegrityAlertTitle,
                  style: const TextStyle(
                    color: Color(0xFF19C463),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              AppLocalizations.of(context).adminHomeAnomalyBody,
              style: const TextStyle(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  AppLocalizations.of(context).adminHomeRunAuditNow,
                  style: const TextStyle(
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
    return Column(
      children: [
        const Divider(height: 1, color: Color(0xFFE2E6EA)),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                '© 2026 BuildRank Performance Systems.',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LegalDocumentScreen(
                      type: LegalDocumentType.privacy,
                    ),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context).legalPrivacyTitle,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LegalDocumentScreen(
                      type: LegalDocumentType.terms,
                    ),
                  ),
                );
              },
              child: Text(
                AppLocalizations.of(context).legalTermsTitle,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _loadDashboardSummary() async {
    setState(() {
      _isLoadingDashboardSummary = true;
      _dashboardError = null;
    });

    try {
      final summary = await _dashboardService.getSummary();

      if (!mounted) return;

      setState(() {
        _dashboardSummary = summary;
      });
    } on AdminDashboardApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _dashboardError = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _dashboardError = AppLocalizations.of(
          context,
        ).adminHomeDashboardLoadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDashboardSummary = false;
        });
      }
    }
  }

  Future<void> _loadPendingImprovements() async {
    setState(() {
      _isLoadingImprovements = true;
      _improvementsError = null;
    });

    try {
      final improvements = await _improvementValidationService
          .listPendingImprovements();

      if (!mounted) return;

      setState(() {
        _pendingImprovements = improvements;
      });
    } on AdminImprovementValidationApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _improvementsError = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _improvementsError = AppLocalizations.of(
          context,
        ).adminHomeImprovementLoadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingImprovements = false;
        });
      }
    }
  }

  Future<void> _reviewImprovement(int improvementId, bool approve) async {
    String? reason;

    if (!approve) {
      reason = await _askRejectReason();
      if (!mounted) return;
      if (reason == null || reason.trim().isEmpty) return;
    }

    setState(() {
      _processingImprovementIds.add(improvementId);
    });

    try {
      await _improvementValidationService.reviewImprovement(
        improvementId: improvementId,
        approve: approve,
        reason: reason,
      );

      if (!mounted) return;

      _showSnackBar(
        approve
            ? AppLocalizations.of(context).adminHomeImprovementApproved
            : AppLocalizations.of(context).adminHomeImprovementRejected,
      );

      await Future.wait([_loadDashboardSummary(), _loadPendingImprovements()]);
    } on AdminImprovementValidationApiException catch (e) {
      if (!mounted) return;
      _showSnackBar(e.message);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(
        AppLocalizations.of(context).adminHomeUnexpectedImprovementError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _processingImprovementIds.remove(improvementId);
        });
      }
    }
  }

  Future<void> _loadVerifications() async {
    setState(() {
      _isLoadingVerifications = true;
      _verificationError = null;
    });

    try {
      final verifications = await _verificationService.listVerifications();

      if (!mounted) return;

      setState(() {
        _verifications = verifications;
      });
    } on AdminVerificationApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _verificationError = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _verificationError =
            'S’ha produït un error inesperat carregant verificacions.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingVerifications = false;
        });
      }
    }
  }

  Future<void> _loadSeasons() async {
    setState(() {
      _isLoadingSeasons = true;
      _seasonsError = null;
    });

    try {
      final seasons = await _seasonService.getSeasons();

      if (!mounted) return;

      setState(() {
        _seasons = seasons;
      });
    } on SeasonApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _seasonsError = e.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _seasonsError = AppLocalizations.of(
          context,
        ).adminHomeSeasonUnexpectedLoadError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSeasons = false;
        });
      }
    }
  }

  Future<void> _confirmCreateAndStartSeason() async {
    final l10n = AppLocalizations.of(context);
    final creation = await _askSeasonCreationDetails();

    if (!mounted) return;
    if (creation == null || _isCreatingSeason) return;

    setState(() {
      _isCreatingSeason = true;
    });

    try {
      final result = await _seasonService.createAndStartSeason(
        name: creation.name,
        startDate: creation.startDate,
        endDate: creation.endDate,
      );

      if (!mounted) return;

      _showSnackBar(
        l10n.adminHomeSeasonActivationSuccess(
          result.displaySummary(l10n.adminHomeSeasonActivationDefaultSummary),
        ),
      );

      await Future.wait([
        _loadDashboardSummary(),
        _loadSeasons(),
        _loadVerifications(),
        _loadPendingImprovements(),
      ]);
    } on SeasonApiException catch (e) {
      if (!mounted) return;
      _showSnackBar(_seasonCreationErrorMessage(e, l10n));
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(l10n.adminHomeSeasonActivationUnexpectedError);
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingSeason = false;
        });
      }
    }
  }

  Future<_SeasonCreationFormData?> _askSeasonCreationDetails() async {
    return showDialog<_SeasonCreationFormData>(
      context: context,
      builder: (context) => const _CreateSeasonDialog(),
    );
  }

  String _seasonCreationErrorMessage(
    SeasonApiException error,
    AppLocalizations l10n,
  ) {
    final details = error.details;
    if (details is Map) {
      if (details.containsKey('nom')) return l10n.adminHomeSeasonNameRequired;
      if (details.containsKey('dataInici')) {
        return l10n.adminHomeSeasonStartDateRequired;
      }
      if (details.containsKey('dataFi')) {
        return l10n.adminHomeSeasonEndDateRequired;
      }
    }
    return error.message;
  }

  Future<void> _reviewVerification(int verificationId, bool approve) async {
    String? reason;

    if (!approve) {
      reason = await _askRejectReason();
      if (!mounted) return;
      if (reason == null || reason.trim().isEmpty) return;
    }

    setState(() {
      _processingVerificationIds.add(verificationId);
    });

    try {
      await _verificationService.reviewVerification(
        verificationId: verificationId,
        approve: approve,
        reason: reason,
      );

      if (!mounted) return;

      _showSnackBar(
        approve ? 'Verificació aprovada.' : 'Verificació rebutjada.',
      );

      await Future.wait([_loadDashboardSummary(), _loadVerifications()]);
    } on AdminVerificationApiException catch (e) {
      if (!mounted) return;
      _showSnackBar(e.message);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar(
        AppLocalizations.of(context).adminHomeUnexpectedVerificationError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _processingVerificationIds.remove(verificationId);
        });
      }
    }
  }

  Future<String?> _askRejectReason() async {
    return showDialog<String>(
      context: context,
      builder: (context) => const _RejectReasonDialog(),
    );
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
      _showSnackBar(AppLocalizations.of(context).adminHomeFiltersPending);
}

class _CreateSeasonDialog extends StatefulWidget {
  const _CreateSeasonDialog();

  @override
  State<_CreateSeasonDialog> createState() => _CreateSeasonDialogState();
}

class _CreateSeasonDialogState extends State<_CreateSeasonDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart
        ? _startDate ?? _endDate ?? now
        : _endDate ?? _startDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 20, 12, 31),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF19C463)),
        ),
        child: child!,
      ),
    );

    if (picked == null || !mounted) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = _formatDateForApi(picked);
      } else {
        _endDate = picked;
        _endDateController.text = _formatDateForApi(picked);
      }
    });
    _formKey.currentState?.validate();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    Navigator.pop(
      context,
      _SeasonCreationFormData(
        name: _nameController.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
      ),
    );
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.adminHomeSeasonActivationTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.adminHomeSeasonActivationBody),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.adminHomeSeasonNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.adminHomeSeasonNameRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.adminHomeSeasonStartDateLabel,
                  hintText: l10n.adminHomeSeasonSelectStartDate,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
                onTap: () => _pickDate(isStart: true),
                validator: (_) => _startDate == null
                    ? l10n.adminHomeSeasonStartDateRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: l10n.adminHomeSeasonEndDateLabel,
                  hintText: l10n.adminHomeSeasonSelectEndDate,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
                onTap: () => _pickDate(isStart: false),
                validator: (_) {
                  if (_endDate == null) {
                    return l10n.adminHomeSeasonEndDateRequired;
                  }
                  if (_startDate != null && _endDate!.isBefore(_startDate!)) {
                    return l10n.adminHomeSeasonEndBeforeStart;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.adminHomeCancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(l10n.adminHomeSeasonActivationConfirm),
        ),
      ],
    );
  }
}

class _RejectReasonDialog extends StatefulWidget {
  const _RejectReasonDialog();

  @override
  State<_RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<_RejectReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.adminHomeRejectionReason),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: l10n.adminHomeRejectionHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.adminHomeCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(l10n.adminHomeReject),
        ),
      ],
    );
  }
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

class _PendingImprovementTile extends StatelessWidget {
  final ImplementedImprovementValidationItem item;
  final bool isProcessing;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _PendingImprovementTile({
    required this.item,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final costText = item.realCost == null
        ? l10n.commonUnavailable
        : '${item.realCost!.toStringAsFixed(0)} €';
    final executionDate = item.executionDate ?? l10n.commonUnavailable;

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
              Icons.handyman_outlined,
              color: Color(0xFF607080),
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.improvementName,
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
                  '${item.edificiTitle} • ${item.requesterName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.adminHomeImprovementCost}: $costText • ${l10n.adminHomeImprovementDate}: $executionDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                if (item.observations != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.adminHomeImprovementObservations}: ${item.observations}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _StatusPill(status: _TaskStatus.pending),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              if (isProcessing)
                const SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else ...[
                _CircleActionButton(
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF1F2937),
                  onTap: onApprove,
                  tooltip: l10n.adminHomeApproveImprovement,
                ),
                const SizedBox(height: 8),
                _CircleActionButton(
                  icon: Icons.cancel_outlined,
                  color: const Color(0xFFFF5555),
                  onTap: onReject,
                  tooltip: l10n.adminHomeRejectImprovement,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _VerificationTaskTile extends StatelessWidget {
  final _VerificationTask task;
  final bool isProcessing;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _VerificationTaskTile({
    required this.task,
    required this.isProcessing,
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
                  '${task.category} • ${task.requester}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.scoreLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
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
              if (isProcessing)
                const SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (task.canReview) ...[
                _CircleActionButton(
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFF1F2937),
                  onTap: onApprove,
                  tooltip: AppLocalizations.of(context).adminHomeApprove,
                ),
                const SizedBox(height: 8),
                _CircleActionButton(
                  icon: Icons.cancel_outlined,
                  color: const Color(0xFFFF5555),
                  onTap: onReject,
                  tooltip: AppLocalizations.of(context).adminHomeReject,
                ),
              ] else ...[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Icon(
                    Icons.hourglass_top,
                    color: Colors.black45,
                    size: 22,
                  ),
                ),
              ],
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
  final VoidCallback? onTap;

  const _PanelActionButton({
    required this.label,
    required this.onTap,
    this.icon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final color = enabled ? const Color(0xFF19C463) : const Color(0xFF9CA3AF);

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
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 17, color: color),
          ],
        ),
      ),
    );
  }
}

class _SeasonTile extends StatelessWidget {
  final Season season;

  const _SeasonTile({required this.season});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final range = _formatRange(context, season.startDate, season.endDate);
    final isActive = _isActiveStatus(season.status);
    final stats = l10n.adminHomeSeasonStats(range, season.participants);

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
                  stats,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _SmallLabel(
            text: isActive
                ? l10n.adminHomeSeasonStatusActive
                : l10n.adminHomeSeasonStatusClosed,
            active: isActive,
          ),
        ],
      ),
    );
  }

  bool _isActiveStatus(String status) {
    final normalized = status.trim().toUpperCase();
    return normalized == 'ACTIVA' ||
        normalized == 'ACTIU' ||
        normalized == 'ACTIVE';
  }

  String _formatRange(
    BuildContext context,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final l10n = AppLocalizations.of(context);

    if (startDate == null && endDate == null) {
      return l10n.adminHomeSeasonDatesUnavailable;
    }

    final start = startDate == null ? null : _formatDate(startDate);
    final end = endDate == null ? null : _formatDate(endDate);

    if (start != null && end != null) return '$start - $end';
    if (start != null) return l10n.adminHomeSeasonStartedOn(start);
    return l10n.adminHomeSeasonEndedOn(end!);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
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
  pending('Revisió'),
  verified('Aprovat'),
  rejected('Rebutjat');

  final String label;
  const _TaskStatus(this.label);
}

class _VerificationTask {
  final String id;
  final int verificationId;
  final String title;
  final String category;
  final String requester;
  final String scoreLabel;
  final _TaskStatus status;
  final String rawStatus;

  bool get canReview => rawStatus.toLowerCase() == 'review';

  const _VerificationTask({
    required this.id,
    required this.verificationId,
    required this.title,
    required this.category,
    required this.requester,
    required this.scoreLabel,
    required this.status,
    required this.rawStatus,
  });

  factory _VerificationTask.fromVerification(AdminVerificationItem item) {
    final normalizedStatus = item.status.toLowerCase();

    final status = switch (normalizedStatus) {
      'review' => _TaskStatus.pending,
      'approved' => _TaskStatus.verified,
      'rejected' => _TaskStatus.rejected,
      _ => _TaskStatus.pending,
    };

    final scoreText = item.score == null
        ? 'Score pendent'
        : 'Score IA ${(item.score! * 100).toStringAsFixed(0)}%';

    final docText = item.documents.isEmpty
        ? 'sense documents'
        : '${item.documents.length} document(s)';

    return _VerificationTask(
      id: item.id.toString(),
      verificationId: item.id,
      title: item.edificiTitle,
      category: '${item.status} · $docText',
      requester: '${item.requesterName} · ${item.requesterEmail}',
      scoreLabel: item.suggeriment == null || item.suggeriment!.trim().isEmpty
          ? scoreText
          : '$scoreText · ${item.suggeriment}',
      status: status,
      rawStatus: item.status,
    );
  }
}
