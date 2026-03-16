import 'package:flutter/material.dart';

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
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: "Aquest edifici és actualment a la "),
                  TextSpan(
                    text: "Silver League",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ". Millora la qualificació energètica per passar a la ",
                  ),
                  TextSpan(
                    text: "Gold League",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE0A100),
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
