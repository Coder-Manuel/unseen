import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:unseen/config/colors.dart';
import 'package:unseen/core/utils/size.util.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/stream/presentation/controllers/join_stream_controller.dart';

/// Full-screen viewer page for the client watching a scout's live stream.
///
/// Pass the active [MissionEntity] as `Get.arguments`.
class JoinStreamPage extends StatefulWidget {
  static const String route = '/join-stream';

  const JoinStreamPage({super.key});

  @override
  State<JoinStreamPage> createState() => _JoinStreamPageState();
}

class _JoinStreamPageState extends State<JoinStreamPage> {
  late final JoinStreamController _ctrl;
  late final MissionEntity _mission;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _mission = Get.arguments as MissionEntity;
    _ctrl = Get.find<JoinStreamController>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ctrl.initialize(_mission),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Remote video feed — fills the whole screen.
          _RemoteFeed(ctrl: _ctrl),

          // 2. Top overlay — "Live Feed" title, watching badge, timer.
          _TopOverlay(ctrl: _ctrl),

          // 3. Bottom gradient + scout info + leave button.
          _BottomSection(ctrl: _ctrl, mission: _mission),
        ],
      ),
    );
  }
}

// ── Remote feed ───────────────────────────────────────────────────────────────

class _RemoteFeed extends StatelessWidget {
  final JoinStreamController ctrl;
  const _RemoteFeed({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ── Connecting ────────────────────────────────────────────────────────
      if (ctrl.isConnecting.value) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
                16.verticalSpace,
                const Text(
                  'Joining stream…',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // ── Error ─────────────────────────────────────────────────────────────
      if (ctrl.hasError.value) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.videocam_off_outlined,
                  color: AppColors.primary,
                  size: 52,
                ),
                20.verticalSpace,
                const Text(
                  'Failed to join stream.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                4.verticalSpace,
                const Text(
                  'Check your connection and try again.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                24.verticalSpace,
                TextButton(
                  onPressed: Get.back,
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // ── Live — render remote track if available ────────────────────────────
      final track = ctrl.remoteVideoTrack.value;
      if (track != null) {
        return SizedBox.expand(
          child: VideoTrackRenderer(track, fit: VideoViewFit.cover),
        );
      }

      // Track not yet available — black placeholder with message.
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Waiting for scout feed…',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    });
  }
}

// ── Top overlay ───────────────────────────────────────────────────────────────

class _TopOverlay extends StatelessWidget {
  final JoinStreamController ctrl;
  const _TopOverlay({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: live info ──────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Live Feed',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                8.verticalSpace,
                const _WatchingBadge(),
                6.verticalSpace,
                Text(
                  'Scout is streaming',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ── Right: elapsed timer ─────────────────────────────────────────
            Obx(() => _TimerBadge(label: ctrl.elapsedLabel)),
          ],
        ),
      ),
    );
  }
}

// ── Bottom gradient + controls ────────────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  final JoinStreamController ctrl;
  final MissionEntity mission;
  const _BottomSection({required this.ctrl, required this.mission});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0xCC000000), Colors.black],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Scout info row ───────────────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ScoutAvatar(ctrl: ctrl),
                    14.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ctrl.mission.scout?.displayName ?? 'Scout',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          6.verticalSpace,
                          _GpsBadge(address: mission.address),
                        ],
                      ),
                    ),
                  ],
                ),

                22.verticalSpace,

                // ── Leave Stream button ──────────────────────────────────────
                _LeaveStreamButton(ctrl: ctrl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Watching badge ────────────────────────────────────────────────────────────

class _WatchingBadge extends StatelessWidget {
  const _WatchingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(),
          SizedBox(width: 6),
          Text(
            'WATCHING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pulsing dot ───────────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ── Timer badge ───────────────────────────────────────────────────────────────

class _TimerBadge extends StatelessWidget {
  final String label;
  const _TimerBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Color(0xFFFFD700), size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Scout avatar ──────────────────────────────────────────────────────────────

class _ScoutAvatar extends StatelessWidget {
  final JoinStreamController ctrl;
  const _ScoutAvatar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final name = ctrl.mission.scout?.displayName ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3B82F6), width: 2.5),
      ),
      child: ClipOval(
        child: Container(
          color: AppColors.surface,
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── GPS location badge ────────────────────────────────────────────────────────

class _GpsBadge extends StatelessWidget {
  final String address;
  const _GpsBadge({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_pin, color: Colors.redAccent, size: 13),
          const SizedBox(width: 4),
          const Text(
            'GPS \u2713 ',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Flexible(
            child: Text(
              address.isNotEmpty ? address : 'On Location',
              style: const TextStyle(color: AppColors.primary, fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Leave Stream button ───────────────────────────────────────────────────────

class _LeaveStreamButton extends StatelessWidget {
  final JoinStreamController ctrl;
  const _LeaveStreamButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: ctrl.leaveStream,
      icon: const Icon(Icons.logout_rounded, size: 18),
      label: const Text(
        'LEAVE STREAM',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1D4ED8),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    );
  }
}
