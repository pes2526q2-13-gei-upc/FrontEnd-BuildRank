import 'package:flutter/material.dart';

import '../../data/votacions_service.dart';

class CrearVotacioScreen extends StatefulWidget {
  final int idEdifici;
  final VotacionsService service;

  const CrearVotacioScreen({
    super.key,
    required this.idEdifici,
    required this.service,
  });

  @override
  State<CrearVotacioScreen> createState() => _CrearVotacioScreenState();
}

class _CrearVotacioScreenState extends State<CrearVotacioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titolController = TextEditingController();
  final _descripcioController = TextEditingController();
  final List<TextEditingController> _opcionsControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  DateTime? _dataLimit;
  bool _isSubmitting = false;

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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(
        () => _dataLimit = DateTime(
          picked.year,
          picked.month,
          picked.day,
          23,
          59,
        ),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final opcions = _opcionsControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final duplicats = opcions.toSet().length != opcions.length;
    if (duplicats) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hi ha opcions duplicades. Revisa\'ls.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final nova = await widget.service.crearVotacio(
        idEdifici: widget.idEdifici,
        titol: _titolController.text.trim(),
        descripcio: _descripcioController.text.trim().isNotEmpty
            ? _descripcioController.text.trim()
            : null,
        dataLimit: _dataLimit,
        opcions: opcions,
      );
      if (mounted) {
        Navigator.of(context).pop(nova);
      }
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
        title: const Text(
          'Nova votació',
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
              'Crear',
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
              'Títol',
              TextFormField(
                controller: _titolController,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration('Escriu el títol de la votació'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El títol és obligatori.';
                  }
                  if (v.trim().length < 4) {
                    return 'El títol ha de tenir almenys 4 caràcters.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildSection(
              'Descripció (opcional)',
              TextFormField(
                controller: _descripcioController,
                maxLines: 3,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  'Explica el context de la votació...',
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildSection(
              'Data límit (opcional)',
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
                        _dataLimit != null
                            ? '${_dataLimit!.day.toString().padLeft(2, '0')}/${_dataLimit!.month.toString().padLeft(2, '0')}/${_dataLimit!.year}'
                            : 'Sense data límit',
                        style: TextStyle(
                          fontSize: 15,
                          color: _dataLimit != null
                              ? Colors.black87
                              : Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      if (_dataLimit != null)
                        GestureDetector(
                          onTap: () => setState(() => _dataLimit = null),
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
                const Text(
                  'Opcions',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  'Mínim 2 · Màxim 8',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _opcionsControllers.length,
              (i) => _buildOpcioField(i),
            ),
            if (_opcionsControllers.length < 8)
              TextButton.icon(
                onPressed: _addOpcio,
                icon: Icon(Icons.add, color: Colors.green[700]),
                label: Text(
                  'Afegir opció',
                  style: TextStyle(color: Colors.green[700]),
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
                    : const Text(
                        'Crear votació',
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

  Widget _buildOpcioField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _opcionsControllers[index],
              textCapitalization: TextCapitalization.sentences,
              decoration: _inputDecoration('Opció ${index + 1}'),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Aquesta opció no pot estar buida.';
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
