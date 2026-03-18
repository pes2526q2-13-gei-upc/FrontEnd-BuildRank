import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/main/presentation/screens/building_main_screen.dart';

class BuildingListItem extends StatelessWidget {
  final String title;
  final String address;
  final int score;
  final String status;

  const BuildingListItem({
    super.key,
    required this.title,
    required this.address,
    required this.score,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final grade = _getGrade(score);
    final color = _getColor(score);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 4),
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔹 IMAGE + GRADE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                  ),
                ),

                Positioned(
                  top: -4,
                  left: -4,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: color,
                    child: Text(
                      grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // 🔹 INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.check_circle_outline, size: 16),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "PUNTUACIÓ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$score/100",
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 HELPERS
  String _getGrade(int score) {
    if (score >= 80) return "A";
    if (score >= 65) return "B";
    if (score >= 50) return "C";
    return "D";
  }

  Color _getColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 65) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}
