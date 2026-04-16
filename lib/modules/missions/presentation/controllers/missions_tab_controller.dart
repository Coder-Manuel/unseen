import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:unseen/core/utils/toast.dart';
import 'package:unseen/modules/missions/data/models/session.model.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/entities/session.entity.dart';
import 'package:unseen/modules/missions/domain/usecases/get_my_missions.usecase.dart';
import 'package:unseen/modules/stream/presentation/pages/join_stream_page.dart';
import 'package:unseen/modules/stream/presentation/widgets/join_stream_dialog.dart';

enum MissionFilter { all, active, pending, completed }

class MissionsTabController extends GetxController {
  final _getMyMissionsUseCase = Get.find<GetMyMissionsUseCase>();
  final _supabase = Get.find<SupabaseClient>();

  // ── State ─────────────────────────────────────────────────────────────────
  final RxList<MissionEntity> _missions = <MissionEntity>[].obs;
  final Rx<MissionFilter> activeFilter = MissionFilter.all.obs;
  final RxBool isLoading = true.obs;
  final RxMap<String, SessionEntity> activeSessions =
      <String, SessionEntity>{}.obs;

  RealtimeChannel? _sessionChannel;
  final _shownDialogMissions = <String>{};

  // ── Derived ───────────────────────────────────────────────────────────────

  List<MissionEntity> get filteredMissions {
    final filter = activeFilter.value;
    return switch (filter) {
      MissionFilter.all => _missions.toList(),
      MissionFilter.active =>
        _missions
            .where(
              (m) =>
                  m.status == MissionStatus.live ||
                  m.status == MissionStatus.accepted,
            )
            .toList(),
      MissionFilter.pending =>
        _missions.where((m) => m.status == MissionStatus.open).toList(),
      MissionFilter.completed =>
        _missions
            .where(
              (m) =>
                  m.status == MissionStatus.completed ||
                  m.status == MissionStatus.cancelled,
            )
            .toList(),
    };
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onReady() {
    super.onReady();
    fetchMissions();
  }

  @override
  void onClose() {
    _sessionChannel?.unsubscribe();
    super.onClose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void setFilter(MissionFilter filter) => activeFilter.value = filter;

  Future<void> fetchMissions() async {
    isLoading.value = true;
    final response = await _getMyMissionsUseCase(null);
    isLoading.value = false;

    response.fold((err) => Toast.error(err.message), (data) {
      _missions.assignAll(data);
      _subscribeToSessions();
    });
  }

  void onJoinStream(MissionEntity mission) {
    Get.toNamed(JoinStreamPage.route, arguments: mission);
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _subscribeToSessions() {
    _sessionChannel?.unsubscribe();
    _sessionChannel = _supabase
        .channel('client-sessions')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'sessions',
          callback: _onSessionChange,
        )
        .subscribe();
  }

  void _onSessionChange(PostgresChangePayload payload) {
    final data = payload.newRecord;
    if (data.isEmpty) return;

    final session = SessionModel.fromMap(data);
    if (session.missionId == null || session.clientToken == null) return;

    // Store in activeSessions map.
    activeSessions[session.missionId!] = session;

    // Find the matching mission.
    final mission = _missions
        .where((m) => m.id == session.missionId)
        .firstOrNull;
    if (mission == null) return;

    // Show dialog only once per mission to avoid duplicates.
    if (_shownDialogMissions.contains(session.missionId)) return;
    _shownDialogMissions.add(session.missionId!);

    Get.dialog(JoinStreamDialog(mission: mission), barrierDismissible: true);
  }
}
