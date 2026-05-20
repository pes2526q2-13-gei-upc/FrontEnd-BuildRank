import 'package:flutter/material.dart';

enum LegalDocumentType { terms, privacy }

class LegalDocumentScreen extends StatelessWidget {
  final LegalDocumentType type;

  const LegalDocumentScreen({super.key, required this.type});

  bool get _isTerms => type == LegalDocumentType.terms;

  String get _title =>
      _isTerms ? 'Termes del Servei' : 'Política de Privacitat';

  String get _subtitle => _isTerms
      ? 'Condicions bàsiques d’ús de BuildRank'
      : 'Com BuildRank tracta les dades dins del MVP';

  @override
  Widget build(BuildContext context) {
    final sections = _isTerms ? _termsSections : _privacySections;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              _title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              _subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            _InfoNotice(
              text:
                  'BuildRank és un projecte acadèmic en fase MVP. Aquest text resumeix les condicions i criteris de privacitat aplicables a la demo i a l’ús del prototip.',
            ),
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

  static const List<_LegalSectionData> _termsSections = [
    _LegalSectionData(
      title: '1. Finalitat del servei',
      body:
          'BuildRank és una aplicació orientada a promoure un ús més responsable i sostenible de l’energia en edificis residencials. Permet consultar informació d’edificis, visualitzar indicadors, comparar resultats, simular millores i participar en funcionalitats comunitàries segons el rol de l’usuari.',
    ),
    _LegalSectionData(
      title: '2. Caràcter orientatiu de la informació',
      body:
          'Les puntuacions, rànquings, classificacions energètiques estimades, simulacions, Heat Risk Index i insígnies tenen finalitat informativa i orientativa. No constitueixen certificacions energètiques oficials, informes tècnics professionals ni recomanacions d’enginyeria concloents.',
    ),
    _LegalSectionData(
      title: '3. Ús responsable de l’aplicació',
      body:
          'L’usuari es compromet a utilitzar BuildRank de manera responsable, a no introduir dades falses o de tercers sense autorització i a respectar les normes de convivència en votacions, xats i espais comunitaris.',
    ),
    _LegalSectionData(
      title: '4. Rols i permisos',
      body:
          'Les accions disponibles poden variar segons el rol de l’usuari i la seva relació amb un edifici. Algunes accions, com gestionar edificis, validar sol·licituds, recalcular insígnies o administrar votacions, poden estar limitades a administradors autoritzats.',
    ),
    _LegalSectionData(
      title: '5. Dades obertes, dades manuals i estimacions',
      body:
          'BuildRank pot combinar dades obertes, dades introduïdes manualment i resultats estimats. Quan una dada sigui incompleta, estimada o pendent de verificació, l’aplicació intentarà indicar-ho de manera clara perquè l’usuari pugui interpretar-la correctament.',
    ),
    _LegalSectionData(
      title: '6. Revisió humana i fonts oficials',
      body:
          'En cas de discrepància sobre dades energètiques, documentació, titularitat o permisos, la revisió humana i les fonts oficials prevalen sobre qualsevol resultat automàtic o estimat mostrat pel sistema.',
    ),
  ];

  static const List<_LegalSectionData> _privacySections = [
    _LegalSectionData(
      title: '1. Dades tractades',
      body:
          'BuildRank pot tractar dades de compte, rol d’usuari, edificis associats, habitatges vinculats, sol·licituds, votacions, simulacions, notificacions i accions de validació o administració.',
    ),
    _LegalSectionData(
      title: '2. Finalitat del tractament',
      body:
          'Les dades es fan servir per autenticar usuaris, gestionar edificis, aplicar permisos, mostrar indicadors, facilitar participació comunitària, registrar accions sensibles i millorar la qualitat de les dades del sistema.',
    ),
    _LegalSectionData(
      title: '3. Minimització de dades',
      body:
          'BuildRank intenta mostrar només la informació necessària per a cada funcionalitat. Per exemple, les vistes generals com el mapa no haurien d’exposar emails, documents, habitatges o dades personals innecessàries.',
    ),
    _LegalSectionData(
      title: '4. Documents i verificacions',
      body:
          'En processos de verificació, els documents aportats poden contenir informació sensible. Aquests fitxers s’han d’utilitzar només per revisar l’evidència necessària i no per a finalitats alienes al procés de validació.',
    ),
    _LegalSectionData(
      title: '5. Traçabilitat i auditoria',
      body:
          'Les accions sensibles poden quedar registrades amb finalitats de seguretat, auditoria i integritat del sistema. Aquesta traçabilitat ajuda a explicar canvis rellevants sobre permisos, validacions, edificis, votacions o puntuacions.',
    ),
    _LegalSectionData(
      title: '6. Ús d’IA i decisions automàtiques',
      body:
          'Qualsevol suport automatitzat o basat en IA, si existeix, s’ha d’entendre com una ajuda per detectar incoherències o punts de revisió. No substitueix la revisió humana ni hauria d’aprovar documents, assignar rols o modificar puntuacions de manera autònoma.',
    ),
    _LegalSectionData(
      title: '7. Responsabilitat de l’usuari',
      body:
          'L’usuari ha d’evitar pujar informació innecessària o documents de tercers sense autorització. Les claus, tokens i credencials no s’han de compartir ni introduir fora dels formularis previstos per l’aplicació.',
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
