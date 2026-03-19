import 'package:flutter/material.dart';

class BadgeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String date;
  final Color color;

  const BadgeItem({
    super.key,
    required this.icon,
    required this.label,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600, // 🔥 jerarquia
            ),
          ),

          const SizedBox(height: 2),

          Text(
            date,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
