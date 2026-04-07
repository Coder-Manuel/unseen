import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/utils/error_wrapper.dart';
import 'package:unseen/modules/missions/data/models/mission.inputs.dart';
import 'package:unseen/modules/missions/data/models/mission.model.dart';
import 'package:unseen/modules/missions/data/sources/remote_missions_datasource.dart';
import 'package:unseen/modules/missions/domain/entities/mission.entity.dart';
import 'package:unseen/modules/missions/domain/repository/missions_repository.dart';

class MissionsRepositoryImpl extends MissionsRepository {
  final _library = 'Missions Repository';
  final RemoteMissionsDatasource remoteDatasource;

  MissionsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<RepoResponse<MissionEntity>> postMission(
    PostMissionInput input,
  ) async {
    final response = await ErrorWrapper.async<RepoResponse<MissionEntity>>(
      () async {
        final data = await remoteDatasource.postMission(input.toMap());
        return SuccessResponse(MissionModel.fromMap(data));
      },
      onError: (_) => FailureResponse('Failed to post mission, kindly retry'),
      library: _library,
      description: 'while posting mission',
    );
    return response!;
  }

  @override
  Future<RepoResponse<List<MissionEntity>>> getMyMissions() async {
    final response =
        await ErrorWrapper.async<RepoResponse<List<MissionEntity>>>(
      () async {
        final data = await remoteDatasource.getMyMissions();
        return SuccessResponse(data.map(MissionModel.fromMap).toList());
      },
      onError: (_) => FailureResponse('Failed to load missions, kindly retry'),
      library: _library,
      description: 'while loading missions',
    );
    return response!;
  }

}
