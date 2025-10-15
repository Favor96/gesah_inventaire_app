import 'package:flutter/material.dart';
import 'package:gesah_inventaire_app/utils/app_theme.dart';

// La classe a été renommée de 'AccueilPage' à 'DashboardScreen'
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec profil
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Nom et rôle
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABBEY favor',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Agent',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icône notification
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Titre Dashboard
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a2e),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cartes statistiques
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.inventory_2,
                      number: '920',
                      label: 'Inventaire de stock',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.desktop_mac,
                      number: '52',
                      label: 'Inventaire de caisse',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.bar_chart,
                      number: '50',
                      label: "Inventaire d'immo",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Graphique
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomPaint(
                    painter: ChartPainter(),
                    child: Container(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Section Mes missions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Mes missions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a2e),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Liste des missions
            _buildMissionCard(
              companyName: 'Ciclano',
              missionType: 'Inventaire d caisse',
              date: '10 jan 2025',
              status: 'En cours',
              statusColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 12),
            _buildMissionCard(
              companyName: 'Ciclano',
              missionType: 'Inventaire d caisse',
              date: '10 jan 2025',
              status: 'Terminé',
              statusColor: const Color(0xFFE53935),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard({
    required String companyName,
    required String missionType,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Logo entreprise
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.business,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Infos mission
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    missionType,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Date et statut
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Painter personnalisé pour le graphique
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paint2 = Paint()
      ..color = const Color(0xFFEF4444)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Dessiner les lignes horizontales de la grille
    for (int i = 0; i <= 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(
        Offset(30, y),
        Offset(size.width - 10, y),
        gridPaint,
      );
    }

    // Points pour la courbe violette
    final path1 = Path();
    final points1 = [
      Offset(30, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.35, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.45),
      Offset(size.width * 0.65, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width - 10, size.height * 0.3),
    ];

    path1.moveTo(points1[0].dx, points1[0].dy);
    for (int i = 1; i < points1.length; i++) {
      final prev = points1[i - 1];
      final curr = points1[i];
      final next = i < points1.length - 1 ? points1[i + 1] : curr;

      final cp1x = prev.dx + (curr.dx - prev.dx) / 2;
      final cp2x = curr.dx - (next.dx - curr.dx) / 4;

      path1.cubicTo(
        cp1x, prev.dy,
        cp2x, curr.dy,
        curr.dx, curr.dy,
      );
    }

    // Points pour la courbe rouge
    final path2 = Path();
    final points2 = [
      Offset(30, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.55),
      Offset(size.width * 0.35, size.height * 0.45),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.65, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.55),
      Offset(size.width - 10, size.height * 0.7),
    ];

    path2.moveTo(points2[0].dx, points2[0].dy);
    for (int i = 1; i < points2.length; i++) {
      final prev = points2[i - 1];
      final curr = points2[i];
      final next = i < points2.length - 1 ? points2[i + 1] : curr;

      final cp1x = prev.dx + (curr.dx - prev.dx) / 2;
      final cp2x = curr.dx - (next.dx - curr.dx) / 4;

      path2.cubicTo(
        cp1x, prev.dy,
        cp2x, curr.dy,
        curr.dx, curr.dy,
      );
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);

    // Dessiner les labels des jours
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < days.length; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          30 + (size.width - 40) * i / (days.length - 1) -
              textPainter.width / 2,
          size.height + 8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}