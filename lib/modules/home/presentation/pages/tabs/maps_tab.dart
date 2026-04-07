import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unseen/config/colors.dart';
import 'package:unseen/modules/missions/presentation/pages/post_mission_page.dart';

// ─── Entry point ─────────────────────────────────────────────────────────────

class MapsTab extends StatelessWidget {
  const MapsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MapView();
  }
}

// ─── Map view (needs AnimationController → StatefulWidget) ────────────────────

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> with TickerProviderStateMixin {
  // Mock scouts shown on map
  static const _scouts = [
    _ScoutMarkerData(x: 0.68, y: 0.22, price: 'KES 1,800'),
    _ScoutMarkerData(x: 0.28, y: 0.35, price: 'KES 2,500'),
    _ScoutMarkerData(x: 0.60, y: 0.48, price: 'KES 3,500'),
    _ScoutMarkerData(x: 0.18, y: 0.60, price: 'KES 2,000'),
    _ScoutMarkerData(x: 0.40, y: 0.68, price: 'KES 4,000'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Map area ends where the overlay begins
    final mapHeight = size.height * 0.72;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Grid background ────────────────────────────────────────────────
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _GridPainter(),
          ),

          // ── Pulsating scout markers ────────────────────────────────────────
          ..._scouts.map(
            (s) => Positioned(
              left: s.x * size.width - 9,
              top: s.y * mapHeight - 9,
              child: _PulsatingScoutMarker(
                price: s.price,
                staggerMs: (_scouts.indexOf(s) * 400),
              ),
            ),
          ),

          // ── User location dot (teal) ───────────────────────────────────────
          Positioned(
            left: size.width * 0.52 - 7,
            top: mapHeight * 0.56 - 7,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00D4CC),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4CC).withAlpha(120),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom overlay ─────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background.withAlpha(0),
                    AppColors.background.withAlpha(220),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.3, 0.6],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'See anywhere.\nKnow everything.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tap map · Long-press to post a mission',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(PostMissionPage.route),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '+ Post a Mission',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pulsating scout marker ───────────────────────────────────────────────────

class _PulsatingScoutMarker extends StatefulWidget {
  final String price;
  final int staggerMs;

  const _PulsatingScoutMarker({
    required this.price,
    required this.staggerMs,
  });

  @override
  State<_PulsatingScoutMarker> createState() => _PulsatingScoutMarkerState();
}

class _PulsatingScoutMarkerState extends State<_PulsatingScoutMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scale = Tween<double>(begin: 1.0, end: 3.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    // Stagger start so scouts don't all pulse in sync
    Future.delayed(Duration(milliseconds: widget.staggerMs), () {
      if (mounted) _ctrl.repeat();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dot + pulse
        SizedBox(
          width: 48,
          height: 48,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Stack(
              alignment: Alignment.center,
              children: [
                // Pulse ring
                Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha(
                        (_opacity.value * 255).toInt(),
                      ),
                    ),
                  ),
                ),
                // Core dot
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(160),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Price label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surface.withAlpha(230),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.divider.withAlpha(80),
              width: 0.5,
            ),
          ),
          child: Text(
            widget.price,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _ScoutMarkerData {
  final double x; // 0..1 of screen width
  final double y; // 0..1 of map height
  final String price;

  const _ScoutMarkerData({
    required this.x,
    required this.y,
    required this.price,
  });
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withAlpha(50)
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
