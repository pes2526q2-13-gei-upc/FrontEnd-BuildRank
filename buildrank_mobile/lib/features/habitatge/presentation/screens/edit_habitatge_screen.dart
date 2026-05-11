import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/habitatge/data/habitatge_form_data.dart';
import 'package:buildrank_mobile/features/habitatge/data/habitatge_service.dart';

class EditHabitatgeScreen extends StatefulWidget {
  final int idEdifici;
  final String buildingTitle;
  final Map<String, dynamic>? initialHabitatge;

  const EditHabitatgeScreen({
    super.key,
    required this.idEdifici,
    required this.buildingTitle,
    this.initialHabitatge,
  });

  @override
  State<EditHabitatgeScreen> createState() => _EditHabitatgeScreenState();
}

class _EditHabitatgeScreenState extends State<EditHabitatgeScreen> {
  final _formKey = GlobalKey<FormState>();
  final HabitatgeService _habitatgeService = HabitatgeService();

  final _referenciaCadastralController = TextEditingController();
  final _plantaController = TextEditingController();
  final _portaController = TextEditingController();
  final _superficieController = TextEditingController();
  final _anyReformaController = TextEditingController();

  final _consumEnergiaPrimariaController = TextEditingController();
  final _consumEnergiaFinalController = TextEditingController();
  final _emissionsCO2Controller = TextEditingController();
  final _costAnualEnergiaController = TextEditingController();

  final _energiaCalefaccioController = TextEditingController();
  final _energiaRefrigeracioController = TextEditingController();
  final _energiaACSController = TextEditingController();
  final _energiaEnllumenamentController = TextEditingController();

  final _emissionsCalefaccioController = TextEditingController();
  final _emissionsRefrigeracioController = TextEditingController();
  final _emissionsACSController = TextEditingController();
  final _emissionsEnllumenamentController = TextEditingController();

  final _aillamentTermicController = TextEditingController();
  final _valorFinestresController = TextEditingController();
  final _normativaController = TextEditingController();
  final _einaCertificacioController = TextEditingController();
  final _motiuCertificacioController = TextEditingController();

  String? _qualificacioGlobal;
  bool _rehabilitacioEnergetica = false;
  DateTime? _dataEntrada;

  bool _isSaving = false;
  bool _isLoading = true;
  String? _loadError;

  static const _grades = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

  @override
  void initState() {
    super.initState();
    _loadHabitatge();
  }

  Future<void> _loadHabitatge() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      Map<String, dynamic>? habitatge = widget.initialHabitatge;

      habitatge ??= await _habitatgeService.getMyHabitatgeForBuilding(
        widget.idEdifici,
      );

      if (!mounted) return;

      if (habitatge == null) {
        setState(() {
          _loadError =
              'No s’ha trobat cap habitatge vinculat al teu usuari en aquest edifici.';
          _isLoading = false;
        });
        return;
      }

      _fillControllersFromHabitatge(habitatge);

      setState(() {
        _isLoading = false;
      });
    } on HabitatgeApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _loadError = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadError = 'No s’ha pogut carregar l’habitatge.';
        _isLoading = false;
      });
    }
  }

  void _fillControllersFromHabitatge(Map<String, dynamic> data) {
    _referenciaCadastralController.text = (data['referenciaCadastral'] ?? '')
        .toString();
    _plantaController.text = (data['planta'] ?? '').toString();
    _portaController.text = (data['porta'] ?? '').toString();
    _superficieController.text = (data['superficie'] ?? '').toString();
    _anyReformaController.text = (data['anyReforma'] ?? '').toString();

    final energetiques = data['dadesEnergetiques'];
    if (energetiques is Map) {
      final energy = Map<String, dynamic>.from(energetiques);

      _qualificacioGlobal = energy['qualificacioGlobal']?.toString();

      _consumEnergiaPrimariaController.text =
          (energy['consumEnergiaPrimaria'] ?? '').toString();
      _consumEnergiaFinalController.text = (energy['consumEnergiaFinal'] ?? '')
          .toString();
      _emissionsCO2Controller.text = (energy['emissionsCO2'] ?? '').toString();
      _costAnualEnergiaController.text = (energy['costAnualEnergia'] ?? '')
          .toString();

      _energiaCalefaccioController.text = (energy['energiaCalefaccio'] ?? '')
          .toString();
      _energiaRefrigeracioController.text =
          (energy['energiaRefrigeracio'] ?? '').toString();
      _energiaACSController.text = (energy['energiaACS'] ?? '').toString();
      _energiaEnllumenamentController.text =
          (energy['energiaEnllumenament'] ?? '').toString();

      _emissionsCalefaccioController.text =
          (energy['emissionsCalefaccio'] ?? '').toString();
      _emissionsRefrigeracioController.text =
          (energy['emissionsRefrigeracio'] ?? '').toString();
      _emissionsACSController.text = (energy['emissionsACS'] ?? '').toString();
      _emissionsEnllumenamentController.text =
          (energy['emissionsEnllumenament'] ?? '').toString();

      _aillamentTermicController.text = (energy['aillamentTermic'] ?? '')
          .toString();
      _valorFinestresController.text = (energy['valorFinestres'] ?? '')
          .toString();
      _normativaController.text = (energy['normativa'] ?? '').toString();
      _einaCertificacioController.text = (energy['einaCertificacio'] ?? '')
          .toString();
      _motiuCertificacioController.text = (energy['motiuCertificacio'] ?? '')
          .toString();

      _rehabilitacioEnergetica = energy['rehabilitacioEnergetica'] == true;

      final rawDate = energy['dataEntrada']?.toString();
      if (rawDate != null && rawDate.isNotEmpty) {
        _dataEntrada = DateTime.tryParse(rawDate);
      }
    }
  }

  @override
  void dispose() {
    _referenciaCadastralController.dispose();
    _plantaController.dispose();
    _portaController.dispose();
    _superficieController.dispose();
    _anyReformaController.dispose();

    _consumEnergiaPrimariaController.dispose();
    _consumEnergiaFinalController.dispose();
    _emissionsCO2Controller.dispose();
    _costAnualEnergiaController.dispose();

    _energiaCalefaccioController.dispose();
    _energiaRefrigeracioController.dispose();
    _energiaACSController.dispose();
    _energiaEnllumenamentController.dispose();

    _emissionsCalefaccioController.dispose();
    _emissionsRefrigeracioController.dispose();
    _emissionsACSController.dispose();
    _emissionsEnllumenamentController.dispose();

    _aillamentTermicController.dispose();
    _valorFinestresController.dispose();
    _normativaController.dispose();
    _einaCertificacioController.dispose();
    _motiuCertificacioController.dispose();

    super.dispose();
  }

  Future<void> _pickDataEntrada() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _dataEntrada ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 1),
    );

    if (selected == null) return;

    setState(() {
      _dataEntrada = selected;
    });
  }

  bool get _hasAnyEnergyData {
    return _qualificacioGlobal != null ||
        _consumEnergiaPrimariaController.text.trim().isNotEmpty ||
        _consumEnergiaFinalController.text.trim().isNotEmpty ||
        _emissionsCO2Controller.text.trim().isNotEmpty ||
        _costAnualEnergiaController.text.trim().isNotEmpty ||
        _energiaCalefaccioController.text.trim().isNotEmpty ||
        _energiaRefrigeracioController.text.trim().isNotEmpty ||
        _energiaACSController.text.trim().isNotEmpty ||
        _energiaEnllumenamentController.text.trim().isNotEmpty ||
        _emissionsCalefaccioController.text.trim().isNotEmpty ||
        _emissionsRefrigeracioController.text.trim().isNotEmpty ||
        _emissionsACSController.text.trim().isNotEmpty ||
        _emissionsEnllumenamentController.text.trim().isNotEmpty ||
        _aillamentTermicController.text.trim().isNotEmpty ||
        _valorFinestresController.text.trim().isNotEmpty ||
        _normativaController.text.trim().isNotEmpty ||
        _einaCertificacioController.text.trim().isNotEmpty ||
        _motiuCertificacioController.text.trim().isNotEmpty ||
        _dataEntrada != null;
  }

  String? _requiredEnergyNumberIfNeeded(String? value) {
    if (!_hasAnyEnergyData) return null;

    final normalized = value?.trim().replaceAll(',', '.') ?? '';
    if (normalized.isEmpty) {
      return 'Camp obligatori si informes dades energètiques';
    }

    final parsed = double.tryParse(normalized);
    if (parsed == null) return 'Introdueix un número vàlid';

    return null;
  }

  String? _requiredEnergyTextIfNeeded(String? value) {
    if (!_hasAnyEnergyData) return null;

    if (value == null || value.trim().isEmpty) {
      return 'Camp obligatori si informes dades energètiques';
    }

    return null;
  }

  String? _validateEnergyDateIfNeeded() {
    if (!_hasAnyEnergyData) return null;

    if (_dataEntrada == null) {
      return 'Cal informar la data d’entrada si informes dades energètiques';
    }

    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dateError = _validateEnergyDateIfNeeded();
    if (dateError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(dateError)));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final formData = _buildFormData();

      final updated = await _habitatgeService.updateMyHabitatge(
        formData: formData,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _hasAnyEnergyData
                ? 'Dades de l’habitatge i dades energètiques actualitzades.'
                : 'Dades de l’habitatge actualitzades.',
          ),
        ),
      );

      Navigator.pop(context, updated);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  HabitatgeFormData _buildFormData() {
    return HabitatgeFormData(
      idEdifici: widget.idEdifici,
      referenciaCadastral: _referenciaCadastralController.text.trim(),
      planta: _plantaController.text.trim(),
      porta: _portaController.text.trim(),
      superficie: _parseDouble(_superficieController.text) ?? 0,
      anyReforma: _parseIntOrNull(_anyReformaController.text),
      dadesEnergetiques: _hasAnyEnergyData
          ? DadesEnergetiquesFormData(
              qualificacioGlobal: _qualificacioGlobal,
              consumEnergiaPrimaria:
                  _parseDouble(_consumEnergiaPrimariaController.text) ?? 0,
              consumEnergiaFinal:
                  _parseDouble(_consumEnergiaFinalController.text) ?? 0,
              emissionsCO2: _parseDouble(_emissionsCO2Controller.text) ?? 0,
              costAnualEnergia:
                  _parseDouble(_costAnualEnergiaController.text) ?? 0,
              energiaCalefaccio:
                  _parseDouble(_energiaCalefaccioController.text) ?? 0,
              energiaRefrigeracio:
                  _parseDouble(_energiaRefrigeracioController.text) ?? 0,
              energiaACS: _parseDouble(_energiaACSController.text) ?? 0,
              energiaEnllumenament:
                  _parseDouble(_energiaEnllumenamentController.text) ?? 0,
              emissionsCalefaccio:
                  _parseDouble(_emissionsCalefaccioController.text) ?? 0,
              emissionsRefrigeracio:
                  _parseDouble(_emissionsRefrigeracioController.text) ?? 0,
              emissionsACS: _parseDouble(_emissionsACSController.text) ?? 0,
              emissionsEnllumenament:
                  _parseDouble(_emissionsEnllumenamentController.text) ?? 0,
              aillamentTermic:
                  _parseDouble(_aillamentTermicController.text) ?? 0,
              valorFinestres: _parseDouble(_valorFinestresController.text) ?? 0,
              normativa: _normativaController.text.trim(),
              einaCertificacio: _einaCertificacioController.text.trim(),
              motiuCertificacio: _motiuCertificacioController.text.trim(),
              rehabilitacioEnergetica: _rehabilitacioEnergetica,
              dataEntrada: _dataEntrada!,
            )
          : null,
    );
  }

  int? _parseIntOrNull(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return null;
    return int.tryParse(normalized);
  }

  double? _parseDouble(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Camp obligatori';
    }
    return null;
  }

  String? _requiredPositiveNumber(String? value) {
    final normalized = value?.trim().replaceAll(',', '.') ?? '';
    if (normalized.isEmpty) return 'Camp obligatori';

    final parsed = double.tryParse(normalized);
    if (parsed == null) return 'Introdueix un número vàlid';
    if (parsed <= 0) return 'Ha de ser superior a 0';

    return null;
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        title: const Text('Editar habitatge'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Refrescar',
            onPressed: _isLoading ? null : _loadHabitatge,
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
            ? _buildLoadError()
            : _buildForm(),
      ),
    );
  }

  Widget _buildLoadError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_work_outlined,
              size: 46,
              color: Colors.black45,
            ),
            const SizedBox(height: 14),
            const Text(
              'No es pot editar l’habitatge',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _loadError ?? 'No s’ha pogut carregar l’habitatge.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, height: 1.35),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: _loadHabitatge,
              icon: const Icon(Icons.refresh),
              label: const Text('Torna-ho a provar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildIntroCard(),
          const SizedBox(height: 16),
          _buildHabitatgeSection(),
          const SizedBox(height: 16),
          _buildEnergySection(),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFBFC7C2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Guardar dades',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completa les dades del teu habitatge',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            widget.buildingTitle,
            style: const TextStyle(
              color: Color(0xFF166534),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aquestes dades ajudaran a calcular millor la classificació estimada i la puntuació BuildRank de l’edifici.',
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitatgeSection() {
    return _SectionCard(
      title: 'Dades de l’habitatge',
      subtitle: 'Informació bàsica de l’habitatge vinculat al teu compte.',
      children: [
        _BuildTextField(
          controller: _referenciaCadastralController,
          label: 'Referència cadastral',
          required: true,
          enabled: false,
          validator: _requiredText,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BuildTextField(
                controller: _plantaController,
                label: 'Planta',
                required: true,
                validator: _requiredText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BuildTextField(
                controller: _portaController,
                label: 'Porta',
                required: true,
                validator: _requiredText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _superficieController,
          label: 'Superfície (m²)',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredPositiveNumber,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _anyReformaController,
          label: 'Any reforma',
          keyboardType: TextInputType.number,
          validator: (value) {
            final normalized = value?.trim() ?? '';
            if (normalized.isEmpty) return null;

            final parsed = int.tryParse(normalized);
            if (parsed == null) return 'Introdueix un any vàlid';

            final currentYear = DateTime.now().year;
            if (parsed < 1800 || parsed > currentYear) {
              return 'L’any no és vàlid';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEnergySection() {
    return _SectionCard(
      title: 'Dades energètiques',
      subtitle:
          'Afegeix la informació disponible del certificat o estimació energètica.',
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFCD34D)),
          ),
          child: const Text(
            'Les dades energètiques són opcionals. Si informes qualsevol camp d’aquesta secció, hauràs d’omplir tots els camps obligatoris del certificat energètic.',
            style: TextStyle(
              color: Color(0xFF92400E),
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _qualificacioGlobal,
          decoration: _inputDecoration('Qualificació global'),
          items: _grades
              .map(
                (grade) => DropdownMenuItem(value: grade, child: Text(grade)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _qualificacioGlobal = value;
            });
          },
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _consumEnergiaPrimariaController,
          label: 'Consum energia primària',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _consumEnergiaFinalController,
          label: 'Consum energia final',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _emissionsCO2Controller,
          label: 'Emissions CO₂',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _costAnualEnergiaController,
          label: 'Cost anual energia (€)',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 18),
        const _SubsectionTitle('Consums per ús'),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _energiaCalefaccioController,
          label: 'Energia calefacció',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _energiaRefrigeracioController,
          label: 'Energia refrigeració',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _energiaACSController,
          label: 'Energia ACS',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _energiaEnllumenamentController,
          label: 'Energia enllumenament',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 18),
        const _SubsectionTitle('Emissions per ús'),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _emissionsCalefaccioController,
          label: 'Emissions calefacció',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _emissionsRefrigeracioController,
          label: 'Emissions refrigeració',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _emissionsACSController,
          label: 'Emissions ACS',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _emissionsEnllumenamentController,
          label: 'Emissions enllumenament',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 18),
        const _SubsectionTitle('Certificació i envolupant'),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _aillamentTermicController,
          label: 'Aïllament tèrmic',
          required: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _requiredEnergyNumberIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _normativaController,
          label: 'Normativa',
          required: true,
          validator: _requiredEnergyTextIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _einaCertificacioController,
          label: 'Eina certificació',
          required: true,
          validator: _requiredEnergyTextIfNeeded,
        ),
        const SizedBox(height: 12),
        _BuildTextField(
          controller: _motiuCertificacioController,
          label: 'Motiu certificació',
          required: true,
          maxLines: 2,
          validator: _requiredEnergyTextIfNeeded,
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          value: _rehabilitacioEnergetica,
          contentPadding: EdgeInsets.zero,
          title: const Text('Rehabilitació energètica'),
          onChanged: (value) {
            setState(() {
              _rehabilitacioEnergetica = value;
            });
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickDataEntrada,
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(
            _dataEntrada == null
                ? 'Seleccionar data d’entrada *'
                : 'Data d’entrada: ${_formatDate(_dataEntrada!)}',
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  final String text;

  const _SubsectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w800,
        fontSize: 12,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const _BuildTextField({
    required this.controller,
    required this.label,
    this.required = false,
    this.enabled = true,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: _inputDecoration(required ? '$label *' : label),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
  );
}
