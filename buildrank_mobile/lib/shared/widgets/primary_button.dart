import 'package:flutter/material.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(AppLocalizations.of(context).rankingComingSoonButton),
      ),
    );
  }
}
