import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum LegalDocumentType { terms, privacy }

class LegalDocumentScreen extends StatelessWidget {
  final LegalDocumentType type;

  const LegalDocumentScreen({super.key, required this.type});

  bool get _isTerms => type == LegalDocumentType.terms;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = _isTerms ? l10n.legalTermsTitle : l10n.legalPrivacyTitle;
    final subtitle = _isTerms
        ? l10n.legalTermsSubtitle
        : l10n.legalPrivacySubtitle;
    final sections = _isTerms ? _termsSections(l10n) : _privacySections(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            _InfoNotice(text: l10n.legalInfoNotice),
            const SizedBox(height: 20),
            for (final section in sections) ...[
              _LegalSection(section: section),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }

  static List<_LegalSectionData> _termsSections(AppLocalizations l10n) => [
    _LegalSectionData(
      title: l10n.legalTermsSection1Title,
      body: l10n.legalTermsSection1Body,
    ),
    _LegalSectionData(
      title: l10n.legalTermsSection2Title,
      body: l10n.legalTermsSection2Body,
    ),
    _LegalSectionData(
      title: l10n.legalTermsSection3Title,
      body: l10n.legalTermsSection3Body,
    ),
    _LegalSectionData(
      title: l10n.legalTermsSection4Title,
      body: l10n.legalTermsSection4Body,
    ),
    _LegalSectionData(
      title: l10n.legalTermsSection5Title,
      body: l10n.legalTermsSection5Body,
    ),
    _LegalSectionData(
      title: l10n.legalTermsSection6Title,
      body: l10n.legalTermsSection6Body,
    ),
  ];

  static List<_LegalSectionData> _privacySections(AppLocalizations l10n) => [
    _LegalSectionData(
      title: l10n.legalPrivacySection1Title,
      body: l10n.legalPrivacySection1Body,
    ),
    _LegalSectionData(
      title: l10n.legalPrivacySection2Title,
      body: l10n.legalPrivacySection2Body,
    ),
    _LegalSectionData(
      title: l10n.legalPrivacySection3Title,
      body: l10n.legalPrivacySection3Body,
    ),
    _LegalSectionData(
      title: l10n.legalPrivacySection4Title,
      body: l10n.legalPrivacySection4Body,
    ),
    _LegalSectionData(
      title: l10n.legalPrivacySection5Title,
      body: l10n.legalPrivacySection5Body,
    ),
    _LegalSectionData(
      title: l10n.legalPrivacySection6Title,
      body: l10n.legalPrivacySection6Body,
    ),
    _LegalSectionData(
      title: l10n.legalPrivacySection7Title,
      body: l10n.legalPrivacySection7Body,
    ),
  ];
}

class _LegalSectionData {
  final String title;
  final String body;

  const _LegalSectionData({required this.title, required this.body});
}

class _LegalSection extends StatelessWidget {
  final _LegalSectionData section;

  const _LegalSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            section.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            section.body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoNotice extends StatelessWidget {
  final String text;

  const _InfoNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.green.shade700),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
        ],
      ),
    );
  }
}
