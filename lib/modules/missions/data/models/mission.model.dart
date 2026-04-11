import 'package:unseen/core/utils/ewkb_parser.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';

class MissionModel extends MissionEntity {
  MissionModel({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.clientId,
    super.scoutId,
    required super.description,
    required super.currency,
    required super.price,
    required super.durationInSec,
    required super.address,
    super.latitude,
    super.longitude,
    super.status,
    super.acceptedAt,
    super.completedAt,
  });

  factory MissionModel.fromMap(Map<String, dynamic> m) {
    final (:latitude, :longitude) = EwkbParser.parsePoint(
      m['location']?.toString(),
    );

    return MissionModel(
      id: m['id']?.toString(),
      createdAt: m['created_at']?.toString(),
      updatedAt: m['updated_at']?.toString(),
      clientId: m['client_id']?.toString(),
      scoutId: m['scout_id']?.toString(),
      description: m['description']?.toString() ?? '',
      currency: m['currency']?.toString() ?? 'KES',
      price: (m['price'] as num?)?.toDouble() ?? 0,
      durationInSec: (m['duration_in_sec'] as int?) ?? 0,
      address: m['address']?.toString() ?? '',
      latitude: latitude,
      longitude: longitude,
      status: MissionStatus.values.firstWhere(
        (v) => v.name == m['status'],
        orElse: () => MissionStatus.open,
      ),
      acceptedAt: m['accepted_at']?.toString(),
      completedAt: m['completed_at']?.toString(),
    );
  }
}
