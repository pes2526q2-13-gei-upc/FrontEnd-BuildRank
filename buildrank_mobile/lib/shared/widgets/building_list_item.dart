import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/main/presentation/screens/building_main_screen.dart';

class BuildingListItem extends StatelessWidget {
  final int idEdifici;
  final String title;
  final String address;
  final int score;
  final String status;
  final String userRole;
  final Map<String, dynamic> building;

  const BuildingListItem({
    super.key,
    required this.idEdifici,
    required this.title,
    required this.address,
    required this.score,
    required this.status,
    required this.userRole,
    required this.building,
  });

  @override
  Widget build(BuildContext context) {
    final grade = _getGrade(score);
    final color = _getColor(score);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MainScreen(
              idEdifici: idEdifici,
              building: building,
              userRole: userRole,
              title: title,
              address: address,
              score: score,
            ),
          ),
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 64,
                    height: 64,
                    color: color.withValues(alpha: 0.12),
                    child: Icon(
                      Icons.apartment_outlined,
                      color: color,
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  left: -5,
                  child: CircleAvatar(
                    radius: 15,
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

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Icon(
                        status == 'Actiu'
                            ? Icons.check_circle_outline
                            : Icons.pause_circle_outline,
                        size: 17,
                        color: status == 'Actiu' ? Colors.green : Colors.grey,
                      ),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "PUNTUACIÓ BUILDRANK",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$score/100",
                        style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
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
