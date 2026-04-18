import 'package:unseen/core/entities/base.entity.dart';
import 'package:unseen/core/entities/user.entity.dart';
import 'package:unseen/modules/missions/data/models/enum.dart';

class MissionEntity extends BaseEntity {
  final String? clientId;
  final String? scoutId;
  final User? scout;
  final String? sessionId;

  /// Free-text instructions sent to the scout.
  final String description;

  final String currency;

  /// Price offered for this mission.
  final double price;

  /// Requested duration in seconds.
  final int durationInSec;

  /// Human-readable address shown in the UI.
  final String address;

  /// Decimal latitude derived from the PostGIS geography field.
  final double? latitude;

  /// Decimal longitude derived from the PostGIS geography field.
  final double? longitude;

  final MissionStatus status;

  final MissionType? type;

  final String? acceptedAt;
  final String? completedAt;

  MissionEntity({
    super.id,
    super.createdAt,
    super.updatedAt,
    this.scout,
    this.clientId,
    this.scoutId,
    this.sessionId,
    required this.description,
    required this.currency,
    required this.price,
    required this.durationInSec,
    required this.address,
    this.latitude,
    this.longitude,
    this.status = MissionStatus.open,
    this.type,
    this.acceptedAt,
    this.completedAt,
  });

  /// Friendly duration string, e.g. "5 min" or "1 hr 30 min".
  String get durationLabel {
    final minutes = durationInSec ~/ 60;
    if (minutes < 60) return '$minutes min';
    final hrs = minutes ~/ 60;
    final rem = minutes % 60;
    return rem > 0 ? '$hrs hr $rem min' : '$hrs hr';
  }
}
