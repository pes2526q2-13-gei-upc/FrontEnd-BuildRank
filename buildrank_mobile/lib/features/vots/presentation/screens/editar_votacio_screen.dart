import 'package:flutter/material.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

import '../../data/votacions_model.dart';
import '../../data/votacions_service.dart';

class EditarVotacioScreen extends StatefulWidget {
  final VotacioDetallModel votacio;
  final VotacionsService service;

  const EditarVotacioScreen({
    super.key,
    required this.votacio,
    required this.service,
  });

  @override
  State<EditarVotacioScreen> createState() => _EditarVotacioScreenState();
}

class _EditarVotacioScreenState extends State<EditarVotacioScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titolController;
  late final TextEditingController _descripcioController;
  late final List<TextEditingController> _opcionsControllers;

  DateTime? _dataLimit;
  bool _clearDataLimit = false;
  late String _estat;
  bool _isSubmitting = false;

  static const _estats = ['oberta', 'tancada', 'cancel·lada'];

  bool get _isCancelled => widget.votacio.estat == 'cancel·lada';

  String _estatLabel(String estat) {
    final l10n = AppLocalizations.of(context);
    switch (estat) {
      case 'oberta':
        return l10n.votesStatusOpen;
      case 'tancada':
        return l10n.votesStatusClosed;
      default:
        return l10n.votesStatusCancelled;
    }
  }

  @override
  void initState() {
    super.initState();
    _titolController = TextEditingController(text: widget.votacio.titol);
    _descripcioController = TextEditingController(
      text: widget.votacio.descripcio ?? '',
    );
    _opcionsControllers = widget.votacio.opcions
        .map((o) => TextEditingController(text: o.text))
        .toList();
    while (_opcionsControllers.length < 2) {
      _opcionsControllers.add(TextEditingController());
    }
    _dataLimit = widget.votacio.dataLimit;
    _estat = widget.votacio.estat;
  }

  @override
  void dispose() {
    _titolController.dispose();
    _descripcioController.dispose();
    for (final c in _opcionsControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOpcio() {
    if (_opcionsControllers.length >= 8) return;
    setState(() => _opcionsControllers.add(TextEditingController()));
  }

  void _removeOpcio(int index) {
    if (_opcionsControllers.length <= 2) return;
    final controller = _opcionsControllers.removeAt(index);
    controller.dispose();
    setState(() {});
  }

  bool _opcionsHanCanviat() {
    final original = widget.votacio.opcions.map((o) => o.text).toList();
    final current = _opcionsControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (original.length != current.length) return true;
    for (int i = 0; i < original.length; i++) {
      if (original[i] != current[i]) return true;
    }
    return false;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _dataLimit != null && _dataLimit!.isAfter(now)
        ? _dataLimit!
        : now.add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() {
        _dataLimit = DateTime(picked.year, picked.month, picked.day, 23, 59);
        _clearDataLimit = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final titol = _titolController.text.trim();
    final descripcio = _descripcioController.text.trim();

    final opcionsNoves = _opcionsControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    if (opcionsNoves.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).votesMinimumOptionsSnack),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final duplicats = opcionsNoves.toSet().length != opcionsNoves.length;
    if (duplicats) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).votesDuplicateOptionsSnack,
          ),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      final updated = await widget.service.editarVotacio(
        id: widget.votacio.id,
        titol: titol != widget.votacio.titol ? titol : null,
        descripcio: descripcio != (widget.votacio.descripcio ?? '')
            ? (descripcio.isEmpty ? '' : descripcio)
            : null,
        dataLimit: _clearDataLimit ? null : _dataLimit,
        clearDataLimit: _clearDataLimit,
        estat: _estat != widget.votacio.estat ? _estat : null,
        opcions: _opcionsHanCanviat() ? opcionsNoves : null,
      );
      if (mounted) Navigator.of(context).pop(updated);
    } on VotacionsApiException catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).votesEditTitle,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            child: Text(
              AppLocalizations.of(context).votesSave,
              style: TextStyle(
                color: _isSubmitting ? Colors.grey : Colors.green[700],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              AppLocalizations.of(context).votesTitleLabel,
              TextFormField(
                controller: _titolController,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  AppLocalizations.of(context).votesTitleHint,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return AppLocalizations.of(context).votesTitleRequired;
                  }
                  if (v.trim().length < 4) {
                    return AppLocalizations.of(context).votesTitleMinLength;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildSection(
              AppLocalizations.of(context).votesDescriptionOptional,
              TextFormField(
                controller: _descripcioController,
                maxLines: 3,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  AppLocalizations.of(context).votesDescriptionHint,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildSection(
              AppLocalizations.of(context).votesDeadline,
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _clearDataLimit || _dataLimit == null
                            ? AppLocalizations.of(context).votesNoDeadline
                            : '${_dataLimit!.day.toString().padLeft(2, '0')}/${_dataLimit!.month.toString().padLeft(2, '0')}/${_dataLimit!.year}',
                        style: TextStyle(
                          fontSize: 15,
                          color: (!_clearDataLimit && _dataLimit != null)
                              ? Colors.black87
                              : Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      if (!_clearDataLimit && _dataLimit != null)
                        GestureDetector(
                          onTap: () => setState(() {
                            _clearDataLimit = true;
                            _dataLimit = null;
                          }),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).votesOptions,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context).votesOptionsRange,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (widget.votacio.numVotsTotal > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppLocalizations.of(context).votesOptionsWarning,
                  style: TextStyle(fontSize: 12, color: Colors.orange[700]),
                ),
              ),
            ...List.generate(
              _opcionsControllers.length,
              (i) => _buildOpcioField(i),
            ),
            if (_opcionsControllers.length < 8)
              TextButton.icon(
                onPressed: _addOpcio,
                icon: Icon(Icons.add, color: Colors.green[700]),
                label: Text(
                  AppLocalizations.of(context).votesAddOption,
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            const SizedBox(height: 12),
            _buildSection(
              AppLocalizations.of(context).votesState,
              _isCancelled
                  ? _estatChip('cancel·lada', disabled: true)
                  : Column(
                      children: _estats.map((e) => _estatRadioTile(e)).toList(),
                    ),
            ),
            if (_isCancelled)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  AppLocalizations.of(context).votesCancelledLocked,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context).votesSaveChanges,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcioField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _opcionsControllers[index],
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDecoration(
                AppLocalizations.of(context).votesOptionHint(index + 1),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return AppLocalizations.of(context).votesOptionRequired;
                }
                return null;
              },
            ),
          ),
          if (_opcionsControllers.length > 2) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _removeOpcio(index),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red[400]),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _estatRadioTile(String estat) {
    final isSelected = _estat == estat;
    return GestureDetector(
      onTap: () => setState(() => _estat = estat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? Colors.green[700] : Colors.grey[400],
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(_estatLabel(estat), style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _estatChip(String estat, {bool disabled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, size: 16, color: Colors.grey[400]),
          const SizedBox(width: 10),
          Text(
            _estatLabel(estat),
            style: TextStyle(fontSize: 15, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.green[700]!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
