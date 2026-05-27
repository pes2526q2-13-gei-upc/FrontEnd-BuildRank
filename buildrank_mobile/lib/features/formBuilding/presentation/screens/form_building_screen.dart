import 'dart:async';

import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/formBuilding/data/building_form_data.dart';
import 'package:buildrank_mobile/features/verification/data/admin_verification_service.dart';
import 'package:buildrank_mobile/features/verification/presentation/widgets/admin_verification_documents_section.dart';
import 'package:buildrank_mobile/features/formBuilding/data/building_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class BuildingFormScreen extends StatefulWidget {
  const BuildingFormScreen({super.key});

  @override
  State<BuildingFormScreen> createState() => _BuildingFormScreenState();
}

class _BuildingFormScreenState extends State<BuildingFormScreen> {
  late final BuildingService _buildingService;
  late final AdminVerificationService _verificationService;

  int _currentStep = 1;
  bool _isSubmitting = false;
  bool _isLoadingStreetSuggestions = false;

  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _barriController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _constructionYearController =
      TextEditingController();
  final TextEditingController _regulationController = TextEditingController();

  final TextEditingController _floorsController = TextEditingController();
  final TextEditingController _surfaceController = TextEditingController();

  final FocusNode _streetFocusNode = FocusNode();

  Timer? _streetDebounce;
  List<Map<String, dynamic>> _streetSuggestions = [];
  Map<String, dynamic>? _selectedStreetSuggestion;
  String? _streetSuggestionsMessage;
  List<AdminVerificationDocumentInput> _verificationDocuments = [];

  String _selectedBuildingType = 'Residencial';
  String _selectedOrientation = '';

  final List<Map<String, dynamic>> _buildingTypes = const [
    {
      'id': 'Residencial',
      'icon': Icons.apartment,
      'title': 'Residencial',
      'subtitle': 'Unifamiliar o pisos',
    },
    {
      'id': 'Comercial',
      'icon': Icons.business,
      'title': 'Comercial',
      'subtitle': 'Oficines, comerç...',
    },
    {
      'id': 'Educatiu',
      'icon': Icons.school,
      'title': 'Educatiu',
      'subtitle': 'Escoles',
    },
    {
      'id': 'Sanitari',
      'icon': Icons.local_hospital,
      'title': 'Sanitari',
      'subtitle': 'Hospitals',
    },
    {
      'id': 'Mixt',
      'icon': Icons.business_center,
      'title': 'Mixt',
      'subtitle': 'Usos combinats',
    },
  ];

  final List<String> _orientationOptions = const ['Nord', 'Sud', 'Est', 'Oest'];

  @override
  void initState() {
    super.initState();

    _buildingService = BuildingService();
    _verificationService = const AdminVerificationService();
  }

  @override
  void dispose() {
    _postalCodeController.dispose();
    _barriController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _constructionYearController.dispose();
    _regulationController.dispose();
    _floorsController.dispose();
    _surfaceController.dispose();
    _streetFocusNode.dispose();
    _streetDebounce?.cancel();
    super.dispose();
  }

  BuildingFormData get _formData {
    return BuildingFormData(
      carrer: _streetNameForSubmit,
      numero: int.parse(_numberController.text.trim()),
      codiPostal: _postalCodeController.text.trim(),
      barri: _barriController.text.trim(),
      latitud: null,
      longitud: null,
      zonaClimatica: null,
      tipologia: _selectedBuildingType,
      anyConstruccio: int.parse(_constructionYearController.text.trim()),
      superficieTotal: double.parse(
        _surfaceController.text.trim().replaceAll(',', '.'),
      ),
      nombrePlantes: int.parse(_floorsController.text.trim()),
      reglament: _regulationController.text.trim(),
      orientacioPrincipal: _selectedOrientation,
    );
  }

  String get _streetNameForSubmit {
    final rawStreetName = _selectedStreetSuggestion?['nom_oficial']
        ?.toString()
        .trim();

    if (rawStreetName != null && rawStreetName.isNotEmpty) {
      return rawStreetName;
    }

    return _streetController.text.trim();
  }

  String _streetDisplayName(Map<String, dynamic> suggestion) {
    final tipusVia = suggestion['tipus_via']?.toString().trim();
    final nomOficial = suggestion['nom_oficial']?.toString().trim() ?? '';

    if (tipusVia == null || tipusVia.isEmpty) {
      return nomOficial;
    }

    return '$tipusVia $nomOficial';
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  Future<void> _onStreetChanged(String value) async {
    setState(() {
      _selectedStreetSuggestion = null;
      _streetSuggestionsMessage = null;
    });

    _streetDebounce?.cancel();

    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      if (!mounted) return;

      setState(() {
        _streetSuggestions = [];
        _isLoadingStreetSuggestions = false;
        _streetSuggestionsMessage = null;
      });

      return;
    }

    if (trimmed.length < 2) {
      if (!mounted) return;

      setState(() {
        _streetSuggestions = [];
        _isLoadingStreetSuggestions = false;
        _streetSuggestionsMessage = AppLocalizations.of(
          context,
        ).buildingFormStreetMinChars;
      });

      return;
    }

    _streetDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      setState(() {
        _isLoadingStreetSuggestions = true;
        _streetSuggestionsMessage = null;
      });

      try {
        final suggestions = await _buildingService.autocompleteCarrers(trimmed);

        if (!mounted) return;

        setState(() {
          _streetSuggestions = suggestions;
          _streetSuggestionsMessage = suggestions.isEmpty
              ? AppLocalizations.of(context).buildingFormNoStreetFound(trimmed)
              : null;
        });
      } on BuildingApiException catch (e) {
        if (!mounted) return;

        setState(() {
          _streetSuggestions = [];
          _streetSuggestionsMessage = e.message;
        });
      } catch (_) {
        if (!mounted) return;

        setState(() {
          _streetSuggestions = [];
          _streetSuggestionsMessage = AppLocalizations.of(
            context,
          ).buildingFormStreetSuggestionsError;
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingStreetSuggestions = false;
          });
        }
      }
    });
  }

  void _selectStreetSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _selectedStreetSuggestion = suggestion;
      _streetController.text = _streetDisplayName(suggestion);
      _streetSuggestions = [];
      _streetSuggestionsMessage = null;
    });

    _streetFocusNode.unfocus();
  }

  String? _validateStep1() {
    final l10n = AppLocalizations.of(context);
    final postalCode = _postalCodeController.text.trim();
    final barri = _barriController.text.trim();
    final streetName = _streetNameForSubmit;
    final streetNumber = _numberController.text.trim();

    if (postalCode.isEmpty) {
      return l10n.buildingFormPostalCodeRequired;
    }

    if (!RegExp(r'^\d{5}$').hasMatch(postalCode)) {
      return l10n.buildingFormPostalCodeInvalid;
    }

    if (barri.isEmpty) {
      return l10n.buildingFormNeighborhoodRequired;
    }

    if (streetName.isEmpty) {
      return l10n.buildingFormStreetRequired;
    }

    if (_selectedStreetSuggestion == null) {
      return l10n.buildingFormStreetSelectionRequired;
    }

    if (_selectedStreetSuggestion == null) {
      return l10n.buildingFormStreetSelectionRequired;
    }

    if (streetNumber.isEmpty) {
      return l10n.buildingFormNumberRequired;
    }

    final parsedNumber = int.tryParse(streetNumber);
    if (parsedNumber == null || parsedNumber <= 0) {
      return l10n.buildingFormNumberPositive;
    }

    final minNumber = _asInt(_selectedStreetSuggestion?['nre_min']);
    final maxNumber = _asInt(_selectedStreetSuggestion?['nre_max']);

    if (minNumber != null &&
        maxNumber != null &&
        (parsedNumber < minNumber || parsedNumber > maxNumber)) {
      return l10n.buildingFormNumberOutOfRange(minNumber, maxNumber);
    }

    return null;
  }

  String? _validateStep2() {
    final l10n = AppLocalizations.of(context);
    final constructionYear = _constructionYearController.text.trim();
    final regulation = _regulationController.text.trim();
    final currentYear = DateTime.now().year;

    if (_selectedBuildingType.trim().isEmpty) {
      return l10n.buildingFormTypeRequired;
    }

    if (constructionYear.isEmpty) {
      return l10n.buildingFormConstructionYearRequired;
    }

    final parsedYear = int.tryParse(constructionYear);
    if (parsedYear == null) {
      return l10n.buildingFormConstructionYearInteger;
    }

    if (parsedYear < 1800 || parsedYear > currentYear) {
      return l10n.buildingFormConstructionYearRange(currentYear);
    }

    if (regulation.isEmpty) {
      return l10n.buildingFormRegulationRequired;
    }

    return null;
  }

  String? _validateStep3() {
    final l10n = AppLocalizations.of(context);
    final floors = _floorsController.text.trim();
    final surface = _surfaceController.text.trim();
    final orientation = _selectedOrientation.trim();

    if (floors.isEmpty) {
      return l10n.buildingFormFloorsRequired;
    }

    final parsedFloors = int.tryParse(floors);
    if (parsedFloors == null || parsedFloors <= 0) {
      return l10n.buildingFormFloorsPositive;
    }

    if (surface.isEmpty) {
      return l10n.buildingFormSurfaceRequired;
    }

    final parsedSurface = double.tryParse(surface.replaceAll(',', '.'));
    if (parsedSurface == null || parsedSurface <= 0) {
      return l10n.buildingFormSurfacePositive;
    }

    if (orientation.isEmpty) {
      return l10n.buildingFormOrientationRequired;
    }

    return null;
  }

  String? _validateStep4() {
    if (_verificationDocuments.isEmpty) {
      return AppLocalizations.of(context).buildingFormDocumentsRequired;
    }

    return null;
  }

  void _goToStep2() {
    final error = _validateStep1();

    if (error != null) {
      _showMessage(error);
      return;
    }

    setState(() {
      _currentStep = 2;
    });
  }

  void _goToStep3() {
    final error = _validateStep2();

    if (error != null) {
      _showMessage(error);
      return;
    }

    setState(() {
      _currentStep = 3;
    });
  }

  void _goToStep4() {
    final error = _validateStep3();

    if (error != null) {
      _showMessage(error);
      return;
    }

    setState(() {
      _currentStep = 4;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final error = _validateStep4();

    if (error != null) {
      _showMessage(error);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final createdBuilding = await _buildingService.createBuildingWithLocation(
        localitzacioPayload: _formData.toLocalitzacioJson(),
        edificiPayload: _formData.toEdificiJson(),
      );

      final idEdifici = _extractCreatedBuildingId(createdBuilding);

      if (idEdifici == null) {
        throw BuildingApiException(l10n.buildingFormCreatedMissingId);
      }

      await _verificationService.createVerification(
        idEdifici: idEdifici,
        documents: _verificationDocuments,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.buildingFormSubmitSuccess)));

      Navigator.pop(context, createdBuilding);
    } on BuildingApiException catch (e) {
      if (!mounted) return;
      _showMessage(e.message);
    } catch (_) {
      if (!mounted) return;
      _showMessage(l10n.buildingFormUnexpectedSaveError);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _goBack() {
    if (_currentStep == 1) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentStep -= 1;
    });
  }

  int? _extractCreatedBuildingId(Map<String, dynamic> json) {
    final value =
        json['idEdifici'] ?? json['id'] ?? json['edifici_id'] ?? json['pk'];

    if (value is int) return value;
    if (value is String) return int.tryParse(value);

    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _buildingTypeTitle(String id, AppLocalizations l10n) {
    switch (id) {
      case 'Residencial':
        return l10n.buildingFormTypeResidential;
      case 'Comercial':
        return l10n.buildingFormTypeCommercial;
      case 'Educatiu':
        return l10n.buildingFormTypeEducational;
      case 'Sanitari':
        return l10n.buildingFormTypeHealthcare;
      case 'Mixt':
        return l10n.buildingFormTypeMixed;
      default:
        return id;
    }
  }

  String _buildingTypeSubtitle(String id, AppLocalizations l10n) {
    switch (id) {
      case 'Residencial':
        return l10n.buildingFormTypeResidentialSubtitle;
      case 'Comercial':
        return l10n.buildingFormTypeCommercialSubtitle;
      case 'Educatiu':
        return l10n.buildingFormTypeEducationalSubtitle;
      case 'Sanitari':
        return l10n.buildingFormTypeHealthcareSubtitle;
      case 'Mixt':
        return l10n.buildingFormTypeMixedSubtitle;
      default:
        return '';
    }
  }

  String _orientationLabel(String value, AppLocalizations l10n) {
    switch (value) {
      case 'Nord':
        return l10n.orientationNorth;
      case 'Sud':
        return l10n.orientationSouth;
      case 'Est':
        return l10n.orientationEast;
      case 'Oest':
        return l10n.orientationWest;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locationDescription = [
      _streetController.text.trim(),
      _numberController.text.trim(),
    ].where((value) => value.isNotEmpty).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        centerTitle: true,
        leadingWidth: 110,
        leading: TextButton.icon(
          onPressed: _isSubmitting ? null : _goBack,
          icon: const Icon(Icons.arrow_back),
          label: Text(l10n.commonBack),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 6),
          Chip(
            label: Text(l10n.buildingFormNewBuildingChip),
            backgroundColor: Color(0xFFE4F6EA),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.buildingFormTitle,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _currentStep == 1
                ? l10n.buildingFormStep1Subtitle
                : _currentStep == 2
                ? l10n.buildingFormStep2Subtitle
                : _currentStep == 3
                ? l10n.buildingFormStep3Subtitle
                : l10n.buildingFormStep4Subtitle,
            style: const TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 24),
          _StepIndicator(currentStep: _currentStep),
          const SizedBox(height: 24),

          if (_currentStep == 1) ...[
            _SectionTitle(title: l10n.buildingFormLocationSection),
            const SizedBox(height: 12),

            Text(l10n.buildingFormPostalCodeLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormPostalCodeHint,
                icon: Icons.markunread_mailbox_outlined,
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                l10n.buildingFormOr,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(l10n.buildingFormNeighborhoodLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _barriController,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormNeighborhoodHint,
                icon: Icons.location_city_outlined,
              ),
            ),

            const SizedBox(height: 20),

            Text(l10n.buildingFormStreetLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _streetController,
              focusNode: _streetFocusNode,
              enabled: !_isSubmitting,
              onChanged: _onStreetChanged,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormStreetHint,
                icon: Icons.search,
                suffixIcon: _isLoadingStreetSuggestions
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
            ),

            if (_streetSuggestions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE4E7E2)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: _streetSuggestions.map((suggestion) {
                    final displayName = _streetDisplayName(suggestion);
                    final isSelected =
                        _streetDisplayName(_selectedStreetSuggestion ?? {}) ==
                        displayName;

                    final minNumber = _asInt(suggestion['nre_min']);
                    final maxNumber = _asInt(suggestion['nre_max']);

                    final rangeText = minNumber != null && maxNumber != null
                        ? l10n.buildingFormStreetNumberRange(
                            minNumber,
                            maxNumber,
                          )
                        : null;

                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: isSelected ? Colors.green : Colors.black54,
                      ),
                      title: Text(displayName),
                      subtitle: rangeText != null
                          ? Text(rangeText)
                          : Text(l10n.buildingFormStreetRangeUnknown),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.chevron_right),
                      onTap: () => _selectStreetSuggestion(suggestion),
                    );
                  }).toList(),
                ),
              ),
            ],

            if (_streetSuggestionsMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.orange.shade800,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _streetSuggestionsMessage!,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            Text(l10n.buildingFormNumberLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormNumberHint,
                icon: Icons.pin_outlined,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5ED),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.buildingFormLocationInfo,
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _goToStep2,
              style: _primaryButtonStyle(),
              child: Text(
                l10n.commonContinue,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],

          if (_currentStep == 2) ...[
            _SectionTitle(title: l10n.buildingFormGeneralSection),
            const SizedBox(height: 12),

            _SummaryCard(
              title: l10n.buildingFormRegisteredLocation,
              rows: [
                _SummaryRowData(
                  icon: Icons.location_on_outlined,
                  label: l10n.buildingFormAddressLabel,
                  value: locationDescription.isEmpty
                      ? '-'
                      : locationDescription,
                ),
                _SummaryRowData(
                  icon: Icons.markunread_mailbox_outlined,
                  label: l10n.buildingFormPostalCodeLabel,
                  value: _postalCodeController.text.trim().isEmpty
                      ? '-'
                      : _postalCodeController.text.trim(),
                ),
                _SummaryRowData(
                  icon: Icons.location_city_outlined,
                  label: l10n.buildingFormNeighborhoodLabel,
                  value: _barriController.text.trim().isEmpty
                      ? '-'
                      : _barriController.text.trim(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              l10n.buildingFormTypeLabel,
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
                      icon: type['icon'] as IconData,
                      title: _buildingTypeTitle(type['id'] as String, l10n),
                      subtitle: _buildingTypeSubtitle(
                        type['id'] as String,
                        l10n,
                      ),
                      selected: _selectedBuildingType == type['id'],
                      onTap: () {
                        if (_isSubmitting) return;
                        setState(() {
                          _selectedBuildingType = type['id'] as String;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(l10n.buildingFormConstructionYearLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _constructionYearController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormConstructionYearHint,
                icon: Icons.calendar_today_outlined,
              ),
            ),

            const SizedBox(height: 20),

            Text(l10n.buildingFormRegulationLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _regulationController,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormRegulationHint,
                icon: Icons.rule_folder_outlined,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _goToStep3,
              style: _primaryButtonStyle(),
              child: Text(
                l10n.commonContinue,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],

          if (_currentStep == 3) ...[
            _SectionTitle(title: l10n.buildingFormTechnicalSection),
            const SizedBox(height: 12),

            _SummaryCard(
              title: l10n.buildingFormBuildingSummary,
              rows: [
                _SummaryRowData(
                  icon: Icons.apartment_outlined,
                  label: l10n.buildingCardTypology,
                  value: _buildingTypeTitle(_selectedBuildingType, l10n),
                ),
                _SummaryRowData(
                  icon: Icons.calendar_today_outlined,
                  label: l10n.buildingFormConstructionYearSummaryLabel,
                  value: _constructionYearController.text.trim().isEmpty
                      ? '-'
                      : _constructionYearController.text.trim(),
                ),
                _SummaryRowData(
                  icon: Icons.rule_folder_outlined,
                  label: l10n.buildingFormRegulationSummaryLabel,
                  value: _regulationController.text.trim().isEmpty
                      ? '-'
                      : _regulationController.text.trim(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(l10n.buildingFormFloorsLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _floorsController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormFloorsHint,
                icon: Icons.layers_outlined,
              ),
            ),

            const SizedBox(height: 20),

            Text(l10n.buildingFormSurfaceLabel),
            const SizedBox(height: 6),
            TextField(
              controller: _surfaceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: l10n.buildingFormSurfaceHint,
                icon: Icons.square_foot_outlined,
              ),
            ),

            const SizedBox(height: 20),

            Text(l10n.buildingFormOrientationLabel),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedOrientation.isEmpty
                  ? null
                  : _selectedOrientation,
              items: _orientationOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(_orientationLabel(item, l10n)),
                    ),
                  )
                  .toList(),
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      setState(() {
                        _selectedOrientation = value ?? '';
                      });
                    },
              decoration: _inputDecoration(
                hintText: l10n.buildingFormOrientationHint,
                icon: Icons.explore_outlined,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _goToStep4,
              style: _primaryButtonStyle(),
              child: Text(
                l10n.commonContinue,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],

          if (_currentStep == 4) ...[
            _SectionTitle(title: l10n.buildingFormDocumentationSection),
            const SizedBox(height: 12),

            _SummaryCard(
              title: l10n.buildingFormBuildingToVerify,
              rows: [
                _SummaryRowData(
                  icon: Icons.location_on_outlined,
                  label: l10n.buildingFormAddressLabel,
                  value: locationDescription.isEmpty
                      ? '-'
                      : locationDescription,
                ),
                _SummaryRowData(
                  icon: Icons.apartment_outlined,
                  label: l10n.buildingCardTypology,
                  value: _buildingTypeTitle(_selectedBuildingType, l10n),
                ),
                _SummaryRowData(
                  icon: Icons.square_foot_outlined,
                  label: l10n.buildingCardSurface,
                  value: _surfaceController.text.trim().isEmpty
                      ? '-'
                      : '${_surfaceController.text.trim()} m²',
                ),
              ],
            ),

            const SizedBox(height: 20),

            AdminVerificationDocumentsSection(
              documents: _verificationDocuments,
              enabled: !_isSubmitting,
              onChanged: (documents) {
                setState(() {
                  _verificationDocuments = documents;
                });
              },
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: _primaryButtonStyle(),
              child: Text(
                _isSubmitting
                    ? l10n.buildingFormSubmittingDocuments
                    : l10n.buildingFormSubmit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: const Color(0xFF25C05A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepCircle(
          number: 1,
          active: currentStep == 1,
          completed: currentStep > 1,
        ),
        Expanded(
          child: Divider(
            color: currentStep > 1 ? Colors.green : Colors.grey.shade300,
          ),
        ),
        _StepCircle(
          number: 2,
          active: currentStep == 2,
          completed: currentStep > 2,
        ),
        Expanded(
          child: Divider(
            color: currentStep > 2 ? Colors.green : Colors.grey.shade300,
          ),
        ),
        _StepCircle(
          number: 3,
          active: currentStep == 3,
          completed: currentStep > 3,
        ),
        Expanded(
          child: Divider(
            color: currentStep > 3 ? Colors.green : Colors.grey.shade300,
          ),
        ),
        _StepCircle(number: 4, active: currentStep == 4, completed: false),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int number;
  final bool active;
  final bool completed;

  const _StepCircle({
    required this.number,
    this.active = false,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final highlighted = active || completed;

    return CircleAvatar(
      radius: 14,
      backgroundColor: highlighted ? Colors.green : Colors.grey.shade300,
      child: completed
          ? const Icon(Icons.check, color: Colors.white, size: 14)
          : Text(
              number.toString(),
              style: TextStyle(
                color: highlighted ? Colors.white : Colors.black54,
                fontSize: 12,
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.green,
        letterSpacing: 1,
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
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF5ED) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.green : const Color(0xFFE4E7E2),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: selected ? Colors.green : Colors.black54),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRowData {
  final IconData icon;
  final String label;
  final String value;

  _SummaryRowData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final List<_SummaryRowData> rows;

  const _SummaryCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SummaryRow(
                icon: row.icon,
                label: row.label,
                value: row.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }
}
