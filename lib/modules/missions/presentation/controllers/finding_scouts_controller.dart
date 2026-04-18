import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/missions/data/models/enum.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/entities/nearby_scout.entity.dart';
import 'package:unseen/modules/missions/domain/usecases/get_nearby_scouts.usecase.dart';

class FindingScoutsController extends GetxController {
  final _getNearbyScoutsUseCase = Get.find<GetNearbyScoutsUseCase>();
  final _supabase = Get.find<SupabaseClient>();

  // ── State ─────────────────────────────────────────────────────────────────
  final RxInt scoutsNotified = 0.obs;
  final RxList<NearbyScout> scouts = <NearbyScout>[].obs;
  final RxList<RadarDot> radarDots = <RadarDot>[].obs;
  final RxBool isLoading = true.obs;

  // ── Private ───────────────────────────────────────────────────────────────
  late final MissionEntity _mission;
  StreamSubscription? _missionSubscription;
  Timer? _notifyTimer;
  Timer? _revealTimer;

  // ── Init ──────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // The created MissionEntity is passed as a GetX argument from
    // PostMissionController after a successful insert.
    _mission = Get.arguments as MissionEntity;
    _fetchNearbyScouts();
    _watchMissionAcceptance();
  }

  // ── Fetch nearby scouts (one-time snapshot) ───────────────────────────────

  Future<void> _fetchNearbyScouts() async {
    isLoading.value = true;

    final response = await _getNearbyScoutsUseCase(
      NearbyScoutsInput(
        latitude: _mission.latitude ?? 0,
        longitude: _mission.longitude ?? 0,
        radiusKm: 5.0,
      ),
    );

    isLoading.value = false;

    response.fold((error) => Toast.error(error.message), _revealProgressively);
  }

  // ── Progressive reveal (keeps the Uber-radar feel with real data) ─────────

  void _revealProgressively(List<NearbyScout> nearbyScouts) {
    if (nearbyScouts.isEmpty) return;

    // Animate the "X SCOUTS NOTIFIED" counter to ~8× the actual count,
    // capped at 50, to give a sense of broadcast reach.
    final notifyTarget = (nearbyScouts.length * 8).clamp(1, 50);
    _notifyTimer = Timer.periodic(const Duration(milliseconds: 300), (t) {
      if (scoutsNotified.value >= notifyTarget) {
        t.cancel();
        return;
      }
      scoutsNotified.value = min(
        scoutsNotified.value + Random().nextInt(4) + 1,
        notifyTarget,
      );
    });

    // Reveal each scout card one-by-one with a stagger so the radar dots
    // appear progressively rather than all at once.
    int index = 0;
    _revealTimer = Timer.periodic(const Duration(milliseconds: 1800), (t) {
      if (index >= nearbyScouts.length) {
        t.cancel();
        return;
      }
      final scout = nearbyScouts[index];
      scouts.add(scout);
      radarDots.add(_radarDotFor(scout, index));
      index++;
    });
  }

  /// Converts a [NearbyScout] into a normalised radar position.
  ///
  /// Uses the golden-angle spread so multiple scouts never overlap on the
  /// radar, and maps their real distance to the radar radius band [0.25–0.85].
  RadarDot _radarDotFor(NearbyScout scout, int index) {
    const maxDistanceM = 5000.0; // matches the 5 km RPC radius
    final r =
        0.25 + (scout.distanceMeters / maxDistanceM).clamp(0.0, 1.0) * 0.60;
    final angleRad = (index * 137.508) * (pi / 180); // golden angle ≈ 137.5°
    return RadarDot(
      x: (r * cos(angleRad)).clamp(-0.9, 0.9),
      y: (r * sin(angleRad)).clamp(-0.9, 0.9),
    );
  }

  // ── Realtime — watch for mission acceptance ────────────────────────────────
  //
  // We do NOT stream the scout list — the RPC is a point-in-time snapshot and
  // can't be subscribed to. What matters in real-time is whether a scout has
  // accepted THIS mission so we can navigate the client forward.

  void _watchMissionAcceptance() {
    final missionId = _mission.id;
    if (missionId == null) return;

    _missionSubscription = _supabase
        .from('missions')
        .stream(primaryKey: ['id'])
        .eq('id', missionId)
        .listen((rows) {
          if (rows.isEmpty) return;
          final status = rows.first['status'] as String?;
          if (status == MissionStatus.accepted.name) {
            _missionSubscription?.cancel();
            // TODO: navigate to the mission-tracker screen once it exists.
            // Get.offNamed(MissionTrackerPage.route, arguments: _mission);
            Toast.success('A scout has accepted your mission! 🎉');
          }
        });
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────

  @override
  void onClose() {
    _notifyTimer?.cancel();
    _revealTimer?.cancel();
    _missionSubscription?.cancel();
    super.onClose();
  }
}

// ── Radar dot position ────────────────────────────────────────────────────────

class RadarDot {
  final double x;
  final double y;
  const RadarDot({required this.x, required this.y});
}
