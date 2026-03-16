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
        children: const [
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 20),

              SizedBox(width: 8),

              Text(
                "Propera revisió: 15 des. 2026",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          LinearProgressIndicator(
            value: 0.75,
            color: Colors.green,
            backgroundColor: Colors.white24,
          ),

          SizedBox(height: 12),

          Text(
            "Les dades de verificació estan completes al 75%.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
