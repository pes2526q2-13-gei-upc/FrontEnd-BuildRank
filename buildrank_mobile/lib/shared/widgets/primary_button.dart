import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Text('Pròximament: veure el rànquing'),
      ),
    );
  }
}
