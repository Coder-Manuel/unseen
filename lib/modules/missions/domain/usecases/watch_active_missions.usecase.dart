import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/repository/missions_repository.dart';

/// Returns a live [Stream] of the current user's [accepted] and [live] missions.
///
/// This is a streaming use case — it does not implement the standard
/// [UseCase<T, Params>] interface because it emits multiple values over time
/// rather than a single [RepoResponse]. The stream itself never errors;
/// failures are swallowed by the Supabase client and surface as empty lists.
class WatchActiveMissionsUseCase {
  final MissionsRepository repo;
  WatchActiveMissionsUseCase({required this.repo});

  Stream<List<MissionEntity>> call() => repo.watchActiveMissions();
}
