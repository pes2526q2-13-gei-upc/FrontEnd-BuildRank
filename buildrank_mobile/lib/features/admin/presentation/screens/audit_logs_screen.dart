import 'package:buildrank_mobile/features/admin/data/audit_log.dart';
import 'package:buildrank_mobile/features/admin/data/audit_log_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String _toIsoDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String _formatDisplayDate(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString().padLeft(4, '0');
  return '$d/$m/$y';
}

String _formatDisplayDateTime(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString().padLeft(4, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final mi = dt.minute.toString().padLeft(2, '0');
  final s = dt.second.toString().padLeft(2, '0');
  return '$d/$mo/$y $h:$mi:$s';
}

class AuditLogsScreen extends StatefulWidget {
  final AuditLogService? service;

  const AuditLogsScreen({super.key, this.service});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  late final AuditLogService _service;
  final _userController = TextEditingController();

  AuditLogPage? _page;
  bool _loading = false;
  String? _error;
  int _currentPage = 1;

  // Filters
  String? _method;
  String? _resourceType;
  int? _statusCode;
  DateTime? _fromDate;
  DateTime? _toDate;

  static const _methods = ['GET', 'POST', 'PATCH', 'PUT', 'DELETE'];
  static const _statusCodes = [200, 201, 204, 400, 401, 403, 404, 500];

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? AuditLogService();
    _load();
  }

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }

  Future<void> _load({int page = 1}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userId = int.tryParse(_userController.text.trim());
      final result = await _service.getLogs(
        userId: userId,
        method: _method,
        resourceType: _resourceType,
        statusCode: _statusCode,
        fromDate: _fromDate != null ? _toIsoDate(_fromDate!) : null,
        toDate: _toDate != null ? _toIsoDate(_toDate!) : null,
        page: page,
      );
      if (!mounted) return;
      setState(() {
        _page = result;
        _currentPage = page;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _resetAndLoad() {
    _currentPage = 1;
    _load(page: 1);
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom
        ? (_fromDate ?? DateTime.now().subtract(const Duration(days: 7)))
        : (_toDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF19C463)),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = picked;
      } else {
        _toDate = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.adminAuditTitle,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Color(0xFF14181F),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : () => _load(page: _currentPage),
            tooltip: l10n.commonRefresh,
          ),
        ],
      ),
      body: Column(
        children: [
          _FiltersPanel(
            userController: _userController,
            method: _method,
            resourceType: _resourceType,
            statusCode: _statusCode,
            fromDate: _fromDate,
            toDate: _toDate,
            methods: _methods,
            statusCodes: _statusCodes,
            onMethodChanged: (v) => setState(() => _method = v),
            onResourceTypeChanged: (v) => setState(() => _resourceType = v),
            onStatusCodeChanged: (v) => setState(() => _statusCode = v),
            onPickFromDate: () => _pickDate(isFrom: true),
            onPickToDate: () => _pickDate(isFrom: false),
            onClearFromDate: () => setState(() => _fromDate = null),
            onClearToDate: () => setState(() => _toDate = null),
            onApply: _resetAndLoad,
            onReset: () {
              setState(() {
                _method = null;
                _resourceType = null;
                _statusCode = null;
                _fromDate = null;
                _toDate = null;
                _userController.clear();
              });
              _resetAndLoad();
            },
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF19C463)),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFEF4444),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _load(page: _currentPage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF19C463),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                child: Text(AppLocalizations.of(context).commonRetry),
              ),
            ],
          ),
        ),
      );
    }
    if (_page == null) return const SizedBox.shrink();

    final logs = _page!.results;
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.manage_search, size: 48, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).adminAuditEmpty,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            itemCount: logs.length,
            separatorBuilder: (_, idx) => const SizedBox(height: 6),
            itemBuilder: (_, i) => _LogTile(log: logs[i]),
          ),
        ),
        _PaginationBar(
          currentPage: _currentPage,
          totalCount: _page!.count,
          hasNext: _page!.hasNext,
          hasPrevious: _page!.hasPrevious,
          onPrevious: () => _load(page: _currentPage - 1),
          onNext: () => _load(page: _currentPage + 1),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filters Panel
// ─────────────────────────────────────────────────────────────────────────────

class _FiltersPanel extends StatelessWidget {
  final TextEditingController userController;
  final String? method;
  final String? resourceType;
  final int? statusCode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String> methods;
  final List<int> statusCodes;
  final ValueChanged<String?> onMethodChanged;
  final ValueChanged<String?> onResourceTypeChanged;
  final ValueChanged<int?> onStatusCodeChanged;
  final VoidCallback onPickFromDate;
  final VoidCallback onPickToDate;
  final VoidCallback onClearFromDate;
  final VoidCallback onClearToDate;
  final VoidCallback onApply;
  final VoidCallback onReset;

  const _FiltersPanel({
    required this.userController,
    required this.method,
    required this.resourceType,
    required this.statusCode,
    required this.fromDate,
    required this.toDate,
    required this.methods,
    required this.statusCodes,
    required this.onMethodChanged,
    required this.onResourceTypeChanged,
    required this.onStatusCodeChanged,
    required this.onPickFromDate,
    required this.onPickToDate,
    required this.onClearFromDate,
    required this.onClearToDate,
    required this.onApply,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: user id / email + method
          Row(
            children: [
              Expanded(
                child: _FilterTextField(
                  controller: userController,
                  label: l10n.adminAuditUserId,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterDropdown<String>(
                  label: l10n.adminAuditMethod,
                  value: method,
                  items: methods,
                  itemLabel: (v) => v,
                  onChanged: onMethodChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: resource_type + status_code
          Row(
            children: [
              Expanded(
                child: _FilterTextField(
                  controller: null,
                  label: l10n.adminAuditResourceType,
                  initialValue: resourceType,
                  onChanged: onResourceTypeChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterDropdown<int>(
                  label: l10n.adminAuditHttpCode,
                  value: statusCode,
                  items: statusCodes,
                  itemLabel: (v) => v.toString(),
                  onChanged: onStatusCodeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 3: date range
          Row(
            children: [
              Expanded(
                child: _DateChip(
                  label: l10n.adminAuditFromDate,
                  date: fromDate,
                  onTap: onPickFromDate,
                  onClear: onClearFromDate,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateChip(
                  label: l10n.adminAuditToDate,
                  date: toDate,
                  onTap: onPickToDate,
                  onClear: onClearToDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7280),
                    side: const BorderSide(color: Color(0xFFDDE2E8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.adminAuditClear,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF19C463),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.adminAuditApplyFilters,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final TextInputType keyboardType;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const _FilterTextField({
    this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
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
}

class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE2E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE2E8)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: true,
          hint: Text(l10n.adminAuditAll, style: const TextStyle(fontSize: 13)),
          style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: Text(
                l10n.adminAuditAll,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            ...items.map(
              (v) => DropdownMenuItem<T>(
                value: v,
                child: Text(itemLabel(v), style: const TextStyle(fontSize: 13)),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DateChip({
    required this.label,
    this.date,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final text = date != null ? _formatDisplayDate(date!) : label;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          border: Border.all(
            color: date != null
                ? const Color(0xFF19C463)
                : const Color(0xFFDDE2E8),
          ),
          borderRadius: BorderRadius.circular(8),
          color: date != null ? const Color(0xFFEAFBF1) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: date != null
                  ? const Color(0xFF19C463)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: date != null
                      ? const Color(0xFF19C463)
                      : const Color(0xFF6B7280),
                  fontWeight: date != null
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (date != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Color(0xFF19C463),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Log Tile
// ─────────────────────────────────────────────────────────────────────────────

class _LogTile extends StatelessWidget {
  final AuditLog log;

  const _LogTile({required this.log});

  static const _methodColors = {
    'GET': Color(0xFF2563EB),
    'POST': Color(0xFF19C463),
    'PATCH': Color(0xFFF59E0B),
    'PUT': Color(0xFFF59E0B),
    'DELETE': Color(0xFFEF4444),
  };

  Color get _statusColor {
    if (log.statusCode < 300) return const Color(0xFF19C463);
    if (log.statusCode < 400) return const Color(0xFF2563EB);
    if (log.statusCode < 500) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final methodColor = _methodColors[log.method] ?? const Color(0xFF6B7280);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E6EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: method badge + endpoint + status badge
          Row(
            children: [
              _Badge(text: log.method, color: methodColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  log.endpoint,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _Badge(text: log.statusCode.toString(), color: _statusColor),
            ],
          ),
          const SizedBox(height: 6),
          // Second row: user + IP + duration
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 13,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  log.userEmail.isNotEmpty ? log.userEmail : '–',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.router_outlined,
                size: 13,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                log.ipAddress,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.timer_outlined,
                size: 13,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                '${log.durationMs} ms',
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Timestamp
          Text(
            _formatTimestamp(log.timestamp),
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return _formatDisplayDateTime(dt);
    } catch (_) {
      return iso;
    }
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pagination Bar
// ─────────────────────────────────────────────────────────────────────────────

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalCount;
  final bool hasNext;
  final bool hasPrevious;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PaginationBar({
    required this.currentPage,
    required this.totalCount,
    required this.hasNext,
    required this.hasPrevious,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const pageSize = 50;
    final firstItem = (currentPage - 1) * pageSize + 1;
    final lastItem = (currentPage * pageSize).clamp(0, totalCount);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Text(
            l10n.adminAuditPageRange(firstItem, lastItem, totalCount),
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const Spacer(),
          IconButton(
            onPressed: hasPrevious ? onPrevious : null,
            icon: const Icon(Icons.chevron_left),
            color: const Color(0xFF19C463),
            disabledColor: const Color(0xFFD1D5DB),
            tooltip: l10n.adminAuditPreviousPage,
          ),
          Text(
            l10n.adminAuditPage(currentPage),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          IconButton(
            onPressed: hasNext ? onNext : null,
            icon: const Icon(Icons.chevron_right),
            color: const Color(0xFF19C463),
            disabledColor: const Color(0xFFD1D5DB),
            tooltip: l10n.adminAuditNextPage,
          ),
        ],
      ),
    );
  }
}
