import 'package:flutter/material.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class LeagueInfoCard extends StatelessWidget {
  const LeagueInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE4E7E2)),
        color: const Color(0xFFF8FAF7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 22, color: Colors.black54),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              AppLocalizations.of(
                context,
              ).leagueInfoBody('Silver League', 'Gold League'),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
