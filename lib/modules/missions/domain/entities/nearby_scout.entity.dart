import 'package:unseen/core/entities/user.entity.dart';

/// A [User] with [UserRole.scout] enriched with the straight-line distance
/// computed server-side by the `get_nearby_scouts` RPC.
///
/// This is a domain value object — it does NOT duplicate any [User] fields;
/// it simply composes one.
class NearbyScout {
  final User user;

  /// Straight-line distance in metres from the mission location.
  final double distanceMeters;

  const NearbyScout({required this.user, required this.distanceMeters});

  /// e.g. "380m away" or "1.5km away"
  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)}km away';
    }
    return '${distanceMeters.toInt()}m away';
  }
}
