import 'package:buildrank_mobile/features/verification/data/admin_verification_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AdminVerificationDocumentsSection extends StatelessWidget {
  final List<AdminVerificationDocumentInput> documents;
  final ValueChanged<List<AdminVerificationDocumentInput>> onChanged;
  final bool enabled;

  const AdminVerificationDocumentsSection({
    super.key,
    required this.documents,
    required this.onChanged,
    this.enabled = true,
  });

  Future<void> _pickFiles(BuildContext context) async {
    if (!enabled) return;

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final newDocuments = [
      ...documents,
      ...result.files.map(
        (file) => AdminVerificationDocumentInput(
          file: file,
          docType: AdminVerificationDocumentType.values.first.code,
        ),
      ),
    ];

    onChanged(newDocuments);
  }

  void _updateDocType(int index, String docType) {
    final updated = [...documents];
    updated[index] = updated[index].copyWith(docType: docType);
    onChanged(updated);
  }

  void _removeDocument(int index) {
    final updated = [...documents]..removeAt(index);
    onChanged(updated);
  }

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
          const Text(
            'Documentació d’administrador',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adjunta documentació que acrediti que pots actuar com a administrador de finca d’aquest edifici. La verificació quedarà pendent de revisió.',
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: enabled ? () => _pickFiles(context) : null,
            icon: const Icon(Icons.attach_file),
            label: const Text('Adjuntar documents'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: const Color(0xFF166534),
              side: const BorderSide(color: Color(0xFF86EFAC)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Adjunta documents en format JPG.',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
          if (documents.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...List.generate(documents.length, (index) {
              final document = documents[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DocumentRow(
                  document: document,
                  enabled: enabled,
                  onTypeChanged: (value) {
                    if (value == null) return;
                    _updateDocType(index, value);
                  },
                  onRemove: () => _removeDocument(index),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  final AdminVerificationDocumentInput document;
  final bool enabled;
  final ValueChanged<String?> onTypeChanged;
  final VoidCallback onRemove;

  const _DocumentRow({
    required this.document,
    required this.enabled,
    required this.onTypeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final sizeKb = document.file.size <= 0
        ? null
        : (document.file.size / 1024).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined, color: Color(0xFF166534)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  document.file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (sizeKb != null)
                Text(
                  '$sizeKb KB',
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              IconButton(
                onPressed: enabled ? onRemove : null,
                icon: const Icon(Icons.close),
                tooltip: 'Eliminar document',
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: document.docType,
            items: AdminVerificationDocumentType.values
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type.code,
                    child: Text(type.label),
                  ),
                )
                .toList(),
            onChanged: enabled ? onTypeChanged : null,
            decoration: InputDecoration(
              labelText: 'Tipus de document',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
