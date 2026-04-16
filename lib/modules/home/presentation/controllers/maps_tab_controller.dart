import 'dart:async';

import 'package:get/get.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/usecases/watch_active_missions.usecase.dart';

class MapsTabController extends GetxController {
  final _watchActiveMissionsUseCase = Get.find<WatchActiveMissionsUseCase>();

  // ── State ─────────────────────────────────────────────────────────────────
  final RxList<MissionEntity> activeMissions = <MissionEntity>[].obs;
  final RxBool isLoading = true.obs;

  StreamSubscription<List<MissionEntity>>? _subscription;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onReady() {
    super.onReady();
    _subscription = _watchActiveMissionsUseCase().listen((missions) {
      isLoading.value = false;
      activeMissions.assignAll(missions);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
