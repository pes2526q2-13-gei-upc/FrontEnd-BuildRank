import 'dart:async';

import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/formBuilding/data/building_form_data.dart';
import 'package:buildrank_mobile/features/formBuilding/data/building_service.dart';

class BuildingFormScreen extends StatefulWidget {
  const BuildingFormScreen({super.key});

  @override
  State<BuildingFormScreen> createState() => _BuildingFormScreenState();
}

class _BuildingFormScreenState extends State<BuildingFormScreen> {
  late final BuildingService _buildingService;

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
        _streetSuggestionsMessage =
            'Escriu almenys 2 caràcters per cercar el carrer.';
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
              ? 'No s’ha trobat cap carrer amb “$trimmed”.'
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
          _streetSuggestionsMessage =
              'No s’han pogut carregar els suggeriments de carrers.';
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
    final postalCode = _postalCodeController.text.trim();
    final barri = _barriController.text.trim();
    final streetName = _streetNameForSubmit;
    final streetNumber = _numberController.text.trim();

    if (postalCode.isEmpty) {
      return 'El codi postal és obligatori.';
    }

    if (!RegExp(r'^\d{5}$').hasMatch(postalCode)) {
      return 'El codi postal ha de tenir 5 dígits.';
    }

    if (barri.isEmpty) {
      return 'El camp barri és obligatori.';
    }

    if (streetName.isEmpty) {
      return 'El nom del carrer és obligatori.';
    }

    if (_selectedStreetSuggestion == null) {
      return 'Selecciona un carrer de la llista de suggeriments.';
    }

    if (_selectedStreetSuggestion == null) {
      return 'Selecciona un carrer de la llista de suggeriments perquè el backend el pugui validar.';
    }

    if (streetNumber.isEmpty) {
      return 'El número és obligatori.';
    }

    final parsedNumber = int.tryParse(streetNumber);
    if (parsedNumber == null || parsedNumber <= 0) {
      return 'El número del carrer ha de ser un enter positiu.';
    }

    final minNumber = _asInt(_selectedStreetSuggestion?['nre_min']);
    final maxNumber = _asInt(_selectedStreetSuggestion?['nre_max']);

    if (minNumber != null &&
        maxNumber != null &&
        (parsedNumber < minNumber || parsedNumber > maxNumber)) {
      return 'El número no està dins del rang permès per aquest carrer ($minNumber-$maxNumber).';
    }

    return null;
  }

  String? _validateStep2() {
    final constructionYear = _constructionYearController.text.trim();
    final regulation = _regulationController.text.trim();
    final currentYear = DateTime.now().year;

    if (_selectedBuildingType.trim().isEmpty) {
      return 'Has de seleccionar una tipologia.';
    }

    if (constructionYear.isEmpty) {
      return 'L\'any de construcció és obligatori.';
    }

    final parsedYear = int.tryParse(constructionYear);
    if (parsedYear == null) {
      return 'L\'any de construcció ha de ser un número enter.';
    }

    if (parsedYear < 1800 || parsedYear > currentYear) {
      return 'L\'any de construcció ha d\'estar entre 1800 i $currentYear.';
    }

    if (regulation.isEmpty) {
      return 'La normativa vigent és obligatòria.';
    }

    return null;
  }

  String? _validateStep3() {
    final floors = _floorsController.text.trim();
    final surface = _surfaceController.text.trim();
    final orientation = _selectedOrientation.trim();

    if (floors.isEmpty) {
      return 'El nombre de plantes és obligatori.';
    }

    final parsedFloors = int.tryParse(floors);
    if (parsedFloors == null || parsedFloors <= 0) {
      return 'El nombre de plantes ha de ser un enter positiu.';
    }

    if (surface.isEmpty) {
      return 'La superfície total és obligatòria.';
    }

    final parsedSurface = double.tryParse(surface.replaceAll(',', '.'));
    if (parsedSurface == null || parsedSurface <= 0) {
      return 'La superfície total ha de ser un número positiu.';
    }

    if (orientation.isEmpty) {
      return 'Has de seleccionar una orientació principal.';
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

  Future<void> _submit() async {
    final error = _validateStep3();

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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edifici desat correctament.')),
      );

      Navigator.pop(context, createdBuilding);
    } on BuildingApiException catch (e) {
      if (!mounted) return;
      _showMessage(e.message);
    } catch (_) {
      if (!mounted) return;
      _showMessage('S\'ha produït un error inesperat en desar l\'edifici.');
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final locationDescription = [
      _streetController.text.trim(),
      _numberController.text.trim(),
    ].where((value) => value.isNotEmpty).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('BuildRank'),
        centerTitle: true,
        leadingWidth: 110,
        leading: TextButton.icon(
          onPressed: _isSubmitting ? null : _goBack,
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
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _currentStep == 1
                ? "Comencem per la ubicació de l'edifici."
                : _currentStep == 2
                ? "Ara completa la informació general."
                : "Finalment, afegeix les dades tècniques bàsiques.",
            style: const TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 24),
          _StepIndicator(currentStep: _currentStep),
          const SizedBox(height: 24),

          if (_currentStep == 1) ...[
            const _SectionTitle(title: 'UBICACIÓ'),
            const SizedBox(height: 12),

            const Text('Codi postal'),
            const SizedBox(height: 6),
            TextField(
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., 08025',
                icon: Icons.markunread_mailbox_outlined,
              ),
            ),

            const SizedBox(height: 16),
            const Center(
              child: Text(
                'o',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Barri'),
            const SizedBox(height: 6),
            TextField(
              controller: _barriController,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., Sagrada Família',
                icon: Icons.location_city_outlined,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Nom del carrer'),
            const SizedBox(height: 6),
            TextField(
              controller: _streetController,
              focusNode: _streetFocusNode,
              enabled: !_isSubmitting,
              onChanged: _onStreetChanged,
              decoration: _inputDecoration(
                hintText: 'Comença a escriure el carrer',
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
                        ? 'Números $minNumber-$maxNumber'
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
                          : const Text('Rang de numeració no informat'),
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

            const Text('Número'),
            const SizedBox(height: 6),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., 123',
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
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Selecciona un carrer de la llista de suggeriments. En desar, BuildRank crearà primer la localització i després l’edifici vinculat al teu compte d’administrador.",
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
              child: const Text(
                'Continua →',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],

          if (_currentStep == 2) ...[
            const _SectionTitle(title: 'INFORMACIÓ GENERAL'),
            const SizedBox(height: 12),

            _SummaryCard(
              title: 'Ubicació registrada',
              rows: [
                _SummaryRowData(
                  icon: Icons.location_on_outlined,
                  label: 'Adreça',
                  value: locationDescription.isEmpty
                      ? '-'
                      : locationDescription,
                ),
                _SummaryRowData(
                  icon: Icons.markunread_mailbox_outlined,
                  label: 'Codi postal',
                  value: _postalCodeController.text.trim().isEmpty
                      ? '-'
                      : _postalCodeController.text.trim(),
                ),
                _SummaryRowData(
                  icon: Icons.location_city_outlined,
                  label: 'Barri',
                  value: _barriController.text.trim().isEmpty
                      ? '-'
                      : _barriController.text.trim(),
                ),
              ],
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
                      icon: type['icon'] as IconData,
                      title: type['title'] as String,
                      subtitle: type['subtitle'] as String,
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

            const Text('Any de construcció'),
            const SizedBox(height: 6),
            TextField(
              controller: _constructionYearController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., 1998',
                icon: Icons.calendar_today_outlined,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Normativa vigent'),
            const SizedBox(height: 6),
            TextField(
              controller: _regulationController,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., CTE',
                icon: Icons.rule_folder_outlined,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _goToStep3,
              style: _primaryButtonStyle(),
              child: const Text(
                'Continua →',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],

          if (_currentStep == 3) ...[
            const _SectionTitle(title: 'DADES TÈCNIQUES'),
            const SizedBox(height: 12),

            _SummaryCard(
              title: 'Resum de l’edifici',
              rows: [
                _SummaryRowData(
                  icon: Icons.apartment_outlined,
                  label: 'Tipologia',
                  value: _selectedBuildingType,
                ),
                _SummaryRowData(
                  icon: Icons.calendar_today_outlined,
                  label: 'Any construcció',
                  value: _constructionYearController.text.trim().isEmpty
                      ? '-'
                      : _constructionYearController.text.trim(),
                ),
                _SummaryRowData(
                  icon: Icons.rule_folder_outlined,
                  label: 'Normativa',
                  value: _regulationController.text.trim().isEmpty
                      ? '-'
                      : _regulationController.text.trim(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text('Nombre de plantes'),
            const SizedBox(height: 6),
            TextField(
              controller: _floorsController,
              keyboardType: TextInputType.number,
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., 6',
                icon: Icons.layers_outlined,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Superfície total (m²)'),
            const SizedBox(height: 6),
            TextField(
              controller: _surfaceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: !_isSubmitting,
              decoration: _inputDecoration(
                hintText: 'p. ex., 850',
                icon: Icons.square_foot_outlined,
              ),
            ),

            const SizedBox(height: 20),

            const Text('Orientació principal'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedOrientation.isEmpty
                  ? null
                  : _selectedOrientation,
              items: _orientationOptions
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
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
                hintText: 'Selecciona una orientació',
                icon: Icons.explore_outlined,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: _primaryButtonStyle(),
              child: Text(
                _isSubmitting ? 'Desant edifici...' : 'Crear edifici',
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
        _StepCircle(number: 3, active: currentStep == 3, completed: false),
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
