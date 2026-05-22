import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RevisionCard extends StatelessWidget {
  const RevisionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4B5458),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).revisionCardNextReview,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            value: 0.75,
            color: Colors.green,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).revisionCardDataComplete,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
