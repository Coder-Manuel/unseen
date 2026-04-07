import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:unseen/modules/missions/domain/entities/scout.entity.dart';

class FindingScoutsController extends GetxController {
  final RxInt scoutsNotified = 0.obs;
  final RxList<ScoutEntity> scouts = <ScoutEntity>[].obs;

  // Radar dot positions for each scout (visible on radar when discovered)
  final RxList<RadarDot> radarDots = <RadarDot>[].obs;

  Timer? _notifyTimer;
  Timer? _scoutTimer;

  // Mock scout pool matching the design
  static final _mockScouts = [
    ScoutEntity(
      id: '1',
      firstName: 'James',
      lastName: 'M',
      avatarEmoji: '🧑🏾',
      distanceMeters: 380,
      totalReviews: 28,
      rating: 4.9,
      scoutStatus: ScoutStatus.enRoute,
      radarX: 0.15,
      radarY: -0.25,
    ),
    ScoutEntity(
      id: '2',
      firstName: 'Aisha',
      lastName: 'K',
      avatarEmoji: '👩🏾',
      distanceMeters: 520,
      totalReviews: 41,
      rating: 4.7,
      scoutStatus: ScoutStatus.accepting,
      radarX: -0.3,
      radarY: 0.1,
    ),
    ScoutEntity(
      id: '3',
      firstName: 'Brian',
      lastName: 'O',
      avatarEmoji: '🧔🏾',
      distanceMeters: 740,
      totalReviews: 15,
      rating: 4.5,
      scoutStatus: ScoutStatus.available,
      radarX: 0.45,
      radarY: 0.35,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _startSimulation();
  }

  void _startSimulation() {
    // Increment scout count rapidly
    _notifyTimer = Timer.periodic(const Duration(milliseconds: 400), (t) {
      if (scoutsNotified.value >= 48) {
        t.cancel();
        return;
      }
      scoutsNotified.value =
          (scoutsNotified.value + Random().nextInt(5) + 2).clamp(0, 48);
    });

    // Reveal scouts one by one with stagger
    int index = 0;
    _scoutTimer = Timer.periodic(const Duration(milliseconds: 2200), (t) {
      if (index >= _mockScouts.length) {
        t.cancel();
        return;
      }
      scouts.add(_mockScouts[index]);
      radarDots.add(RadarDot(
        x: _mockScouts[index].radarX,
        y: _mockScouts[index].radarY,
      ));
      index++;
    });
  }

  @override
  void onClose() {
    _notifyTimer?.cancel();
    _scoutTimer?.cancel();
    super.onClose();
  }
}

class RadarDot {
  final double x;
  final double y;
  RadarDot({required this.x, required this.y});
}
