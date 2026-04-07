import 'package:flutter/material.dart';
import 'package:unseen/config/colors.dart';

class MapsTab extends StatelessWidget {
  const MapsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.background,
            child: CustomPaint(
              size: Size.infinite,
              painter: _GridPainter(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textSecondary,
                            size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Search location...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(100),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.my_location,
                      color: Colors.black, size: 22),
                ),
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 40,
            child: Column(
              children: [
                _MapButton(icon: Icons.add),
                const SizedBox(height: 8),
                _MapButton(icon: Icons.remove),
                const SizedBox(height: 16),
                _MapButton(icon: Icons.my_location, isPrimary: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;

  const _MapButton({required this.icon, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: isPrimary ? Colors.black : AppColors.textPrimary,
        size: 20,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withAlpha(80)
      ..strokeWidth = 0.5;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
