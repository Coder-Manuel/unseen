import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/modules/missions/data/models/mission.inputs.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';

abstract class MissionsRepository {
  Future<RepoResponse<MissionEntity>> postMission(PostMissionInput input);
  Future<RepoResponse<List<MissionEntity>>> getMyMissions();
}
