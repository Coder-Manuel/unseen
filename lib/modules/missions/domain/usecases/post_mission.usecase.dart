import 'dart:async';

import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/types/usecase.dart';
import 'package:unseen/modules/missions/data/models/mission.inputs.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/repository/missions_repository.dart';

class PostMissionUseCase implements UseCase<MissionEntity, PostMissionInput> {
  final MissionsRepository repo;
  PostMissionUseCase({required this.repo});

  @override
  FutureOr<RepoResponse<MissionEntity>> call(PostMissionInput params) =>
      repo.postMission(params);
}
