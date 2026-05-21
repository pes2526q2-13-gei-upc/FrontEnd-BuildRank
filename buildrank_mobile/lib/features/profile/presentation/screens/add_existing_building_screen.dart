import 'dart:async';

import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/profile/data/add_existing_building_service.dart';
import 'package:buildrank_mobile/features/verification/data/admin_verification_service.dart';
import 'package:buildrank_mobile/features/verification/presentation/widgets/admin_verification_documents_section.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class AddExistingBuildingScreen extends StatefulWidget {
  final String userRole;
  final AddExistingBuildingService service;

  const AddExistingBuildingScreen({
    super.key,
    required this.userRole,
    this.service = const AddExistingBuildingService(),
  });

  @override
  State<AddExistingBuildingScreen> createState() =>
      _AddExistingBuildingScreenState();
}

class _AddExistingBuildingScreenState extends State<AddExistingBuildingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _refCadastralController = TextEditingController();
  final TextEditingController _plantaController = TextEditingController();
  final TextEditingController _portaController = TextEditingController();
  final TextEditingController _superficieController = TextEditingController();

  Timer? _debounce;
  bool _isSearching = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<ExistingBuildingItem> _results = [];
  ExistingBuildingItem? _selectedBuilding;
  List<AdminVerificationDocumentInput> _verificationDocuments = [];

  bool get _isAdminRole => widget.userRole == 'admin';

  String get _membershipRole => _isAdminRole ? 'administrator' : 'resident';

  bool get _canShowHabitatgeForm =>
      !_isAdminRole &&
      _selectedBuilding != null &&
      _selectedBuilding!.acceptsNewRequests;

  bool get _canSubmitRequest {
    if (_selectedBuilding == null || _isSubmitting) return false;

    if (_isAdminRole) {
      return _verificationDocuments.isNotEmpty;
    }

    return _canShowHabitatgeForm && _isHabitatgeFormValid;
  }

  bool get _requiresBlockFields =>
      _selectedBuilding != null && _selectedBuilding!.isBlock;

  bool get _isHabitatgeFormValid {
    if (_selectedBuilding == null) return false;

    final hasRef = _refCadastralController.text.trim().isNotEmpty;
    final hasSurface = _superficieController.text.trim().isNotEmpty;

    if (!_requiresBlockFields) {
      return hasRef && hasSurface;
    }

    return hasRef &&
        hasSurface &&
        _plantaController.text.trim().isNotEmpty &&
        _portaController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _refCadastralController.dispose();
    _plantaController.dispose();
    _portaController.dispose();
    _superficieController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      await _searchBuildings(value);
    });
  }

  Future<void> _searchBuildings(String query) async {
    final trimmed = query.trim();

    setState(() {
      _errorMessage = null;
      _selectedBuilding = null;
      _results = [];
      _clearHabitatgeForm();
      _verificationDocuments = [];
    });

    if (trimmed.length < 3) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await widget.service.searchBuildings(trimmed);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _results = [];
        _isSearching = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _clearHabitatgeForm() {
    _refCadastralController.clear();
    _plantaController.clear();
    _portaController.clear();
    _superficieController.clear();
  }

  void _selectBuilding(ExistingBuildingItem building) {
    setState(() {
      _selectedBuilding = building;
      _errorMessage = null;
      _clearHabitatgeForm();
      _verificationDocuments = [];
    });
  }

  Future<void> _submitJoinRequest() async {
    final building = _selectedBuilding;
    if (building == null) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final habitatgePayload = _isAdminRole
        ? <String, dynamic>{}
        : {
            'building_id': building.id,
            'referencia_cadastral': _refCadastralController.text.trim(),
            'planta': _requiresBlockFields
                ? _plantaController.text.trim()
                : null,
            'porta': _requiresBlockFields ? _portaController.text.trim() : null,
            'superficie': _superficieController.text.trim(),
            'valid': false,
            'requested_membership_role': _membershipRole,
          };

    try {
      await widget.service.createJoinRequest(
        building: building,
        userRole: widget.userRole,
        habitatgePayload: habitatgePayload,
        verificationDocuments: _verificationDocuments,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.userRole == 'admin'
                ? AppLocalizations.of(context).addExistingAdminRequestSent
                : AppLocalizations.of(context).addExistingResidentRequestSent,
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasMinQuery = _searchController.text.trim().length >= 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addExistingAppBarTitle),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF6F7F2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF8EE),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.addExistingTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.userRole == 'admin'
                        ? l10n.addExistingAdminSubtitle
                        : l10n.addExistingResidentSubtitle,
                    style: const TextStyle(color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.addExistingLocationSection,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.green,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: l10n.addExistingSearchHint,
                prefixIcon: const Icon(Icons.location_on_outlined),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _results = [];
                            _selectedBuilding = null;
                            _errorMessage = null;
                            _clearHabitatgeForm();
                            _verificationDocuments = [];
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (!hasMinQuery)
              Text(
                l10n.addExistingMinSearch,
                style: TextStyle(color: Colors.black54),
              ),
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDA4AF)),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Color(0xFF9F1239)),
                ),
              ),
            ],
            if (!_isSearching && _results.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                l10n.addExistingResultsTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ..._results.map(
                (building) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ExistingBuildingCard(
                    building: building,
                    isSelected: _selectedBuilding?.id == building.id,
                    onTap: () => _selectBuilding(building),
                  ),
                ),
              ),
            ],
            if (!_isSearching &&
                hasMinQuery &&
                _results.isEmpty &&
                _errorMessage == null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  l10n.addExistingNoResults,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (_selectedBuilding != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8EE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Text(
                  l10n.addExistingSelectedBuilding(
                    _selectedBuilding!.name,
                    _isAdminRole
                        ? l10n.profileRoleAdmin
                        : l10n.profileRoleTenant,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                ),
              ),
            if (!_isAdminRole &&
                _selectedBuilding != null &&
                !_selectedBuilding!.acceptsNewRequests) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Text(
                  l10n.addExistingClosedRequests,
                  style: TextStyle(
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (_canShowHabitatgeForm) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.addExistingHabitatgeTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.addExistingHabitatgeSubtitle,
                      style: TextStyle(color: Colors.black54, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _refCadastralController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.habitatgeCadastralReference,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_requiresBlockFields) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _plantaController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.habitatgeFloor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _portaController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: l10n.habitatgeDoor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: _superficieController,
                      onChanged: (_) => setState(() {}),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.habitatgeSurface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_isAdminRole && _selectedBuilding != null) ...[
              const SizedBox(height: 16),
              AdminVerificationDocumentsSection(
                documents: _verificationDocuments,
                enabled: !_isSubmitting,
                onChanged: (documents) {
                  setState(() {
                    _verificationDocuments = documents;
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _canSubmitRequest ? _submitJoinRequest : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFBFC7C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.addExistingSubmit,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExistingBuildingCard extends StatelessWidget {
  final ExistingBuildingItem building;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExistingBuildingCard({
    required this.building,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFEAF8EE) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.apartment_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      building.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      building.address,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    if (building.city != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        building.city!,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? const Color(0xFF22C55E) : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
