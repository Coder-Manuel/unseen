import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/entities/session.entity.dart';
import 'package:unseen/modules/missions/domain/usecases/watch_active_missions.usecase.dart';
import 'package:unseen/modules/missions/domain/usecases/watch_active_session.usecase.dart';
import 'package:unseen/modules/stream/presentation/widgets/join_stream_dialog.dart';

class MapsTabController extends GetxController {
  final _watchActiveMissionsUseCase = Get.find<WatchActiveMissionsUseCase>();
  final _watchActiveSessionUseCase = Get.find<WatchActiveSessionUseCase>();

  // ── State ─────────────────────────────────────────────────────────────────
  final RxList<MissionEntity> activeMissions = <MissionEntity>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<dynamic>? _missionSubscription;
  StreamSubscription<dynamic>? _sessionSubscription;

  @override
  void onReady() {
    _startActiveMissionsStream();
    super.onReady();
  }

  void _startActiveMissionsStream() {
    isLoading.value = true;
    _missionSubscription?.cancel();

    _missionSubscription = _watchActiveMissionsUseCase().listen(
      (response) {
        response.fold((error) => Toast.error(error.message), (data) {
          activeMissions.value = data;
          _startLiveSessionStream();
        });
        isLoading.value = false;
      },
      onError: (_) {
        isLoading.value = false;
        Toast.error('Failed to load missions. Kindly retry.');
      },
    );
  }

  void _startLiveSessionStream() {
    _sessionSubscription?.cancel();
    final missions = activeMissions.map((m) => m.id ?? '').toList();
    _sessionSubscription = _watchActiveSessionUseCase(missions).listen(
      (response) {
        response.fold((_) => null, _onSession);
      },
      onError: (e) {
        log('===== ACTIVE-SESSION-ERROR: $e');
      },
    );
  }

  void _onSession(SessionEntity session) {
    if (session.roomName == null || session.hostToken == null) return;
    if (session.status == SessionStatus.ended) return;

    // Find the matching mission.
    final mission = activeMissions
        .where((m) => m.id == session.missionId)
        .firstOrNull;
    if (mission == null) return;

    // Show dialog.
    Get.dialog(JoinStreamDialog(mission: mission), barrierDismissible: true);
  }

  @override
  void onClose() {
    _sessionSubscription?.cancel();
    _missionSubscription?.cancel();
    super.onClose();
  }
}
