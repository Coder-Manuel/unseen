import 'dart:async';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/stream/domain/usecases/join_stream.usecase.dart';

class JoinStreamController extends GetxController {
  final JoinStreamUseCase _joinStreamUseCase;

  JoinStreamController({required JoinStreamUseCase joinStreamUseCase})
    : _joinStreamUseCase = joinStreamUseCase;

  late MissionEntity mission;

  final _room = Room(
    roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
  );

  // ── Observable state ───────────────────────────────────────────────────────

  final isConnecting = true.obs;
  final isLive = false.obs;
  final hasError = false.obs;
  final elapsedSeconds = 0.obs;
  final remoteVideoTrack = Rx<VideoTrack?>(null);

  Timer? _elapsedTimer;

  // ── Initialise ────────────────────────────────────────────────────────────

  Future<void> initialize(MissionEntity mission) async {
    mission = mission;

    final result = await _joinStreamUseCase(mission.id!);

    await result.fold(
      (err) async {
        isConnecting.value = false;
        hasError.value = true;
      },
      (data) async {
        try {
          await _room.connect(data.url, data.token);

          // Allow WebRTC negotiation to settle, then grab the remote track.
          await Future.delayed(const Duration(milliseconds: 400));
          _refreshRemoteVideoTrack();

          // Re-check whenever room state changes (e.g. track arrives late).
          _room.addListener(_refreshRemoteVideoTrack);

          isConnecting.value = false;
          isLive.value = true;
          _startTimer();
        } catch (_) {
          isConnecting.value = false;
          hasError.value = true;
        }
      },
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void leaveStream() {
    _elapsedTimer?.cancel();
    _room.removeListener(_refreshRemoteVideoTrack);
    _room.disconnect();
    Get.back();
  }

  // ── Computed helpers ──────────────────────────────────────────────────────

  /// Elapsed watch time formatted as `MM:SS` (or `H:MM:SS` after one hour).
  String get elapsedLabel {
    final secs = elapsedSeconds.value;
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    final s = secs % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _refreshRemoteVideoTrack() {
    for (final participant in _room.remoteParticipants.values) {
      for (final pub in participant.videoTrackPublications) {
        if (pub.subscribed && pub.track != null) {
          remoteVideoTrack.value = pub.track as VideoTrack;
          return;
        }
      }
    }
    // No track found — clear so UI shows placeholder.
    remoteVideoTrack.value = null;
  }

  void _startTimer() {
    _elapsedTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => elapsedSeconds.value++,
    );
  }

  @override
  void onClose() {
    _elapsedTimer?.cancel();
    _room.removeListener(_refreshRemoteVideoTrack);
    _room.disconnect();
    super.onClose();
  }
}
