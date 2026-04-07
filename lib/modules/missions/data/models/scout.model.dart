import 'package:unseen/modules/missions/domain/entities/scout.entity.dart';

class ScoutModel extends ScoutEntity {
  ScoutModel({
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
    required super.scoutStatus,
    required super.distanceMeters,
    super.avatarEmoji,
    super.radarX,
    super.radarY,
  });

  factory ScoutModel.fromMap(
    Map<String, dynamic> data, {
    double radarX = 0.0,
    double radarY = 0.0,
    ScoutStatus scoutStatus = ScoutStatus.available,
    String avatarEmoji = '🧑🏾',
  }) =>
      ScoutModel(
        id: data['id']?.toString(),
        createdAt: data['created_at']?.toString(),
        updatedAt: data['updated_at']?.toString(),
        email: data['email']?.toString(),
        firstName: data['first_name']?.toString(),
        lastName: data['last_name']?.toString(),
        phone: data['phone']?.toString(),
        rating: (data['rating'] as num?)?.toDouble(),
        totalReviews: data['total_reviews'] as int?,
        isOnline: data['is_online'] as bool?,
        fcmToken: data['fcm_token']?.toString(),
        distanceMeters: (data['distance_meters'] as num?)?.toDouble() ?? 0,
        scoutStatus: scoutStatus,
        avatarEmoji: avatarEmoji,
        radarX: radarX,
        radarY: radarY,
      );
}
