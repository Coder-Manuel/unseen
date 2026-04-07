import 'package:unseen/core/entities/user.entity.dart';

enum ScoutStatus { enRoute, accepting, available }

/// A Scout is a [User] with [UserRole.scout], enriched with distance
/// computed server-side (via `get_nearby_scouts` RPC) and UI-only
/// radar positioning fields.
class ScoutEntity extends User {
  final ScoutStatus scoutStatus;

  /// Straight-line distance in metres from the client's position.
  final double distanceMeters;

  /// UI-only emoji avatar used until real avatar URLs are implemented.
  final String avatarEmoji;

  /// Normalised radar position in [-1, 1] for both axes (UI-only).
  final double radarX;
  final double radarY;

  ScoutEntity({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.email,
    super.firstName,
    super.lastName,
    super.phone,
    super.rating,
    super.totalReviews,
    super.isOnline,
    super.fcmToken,
    required this.scoutStatus,
    required this.distanceMeters,
    this.avatarEmoji = '🧑🏾',
    this.radarX = 0.0,
    this.radarY = 0.0,
  }) : super(role: UserRole.scout, userStatus: UserStatus.active);

  String get distanceLabel {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)}km away';
    }
    return '${distanceMeters.toInt()}m away';
  }

  String get statusLabel => switch (scoutStatus) {
    ScoutStatus.enRoute => 'En route',
    ScoutStatus.accepting => 'Accepting',
    ScoutStatus.available => 'Available',
  };

}
