import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/types/usecase.dart';
import 'package:unseen/modules/stream/domain/entities/livekit_session.entity.dart';
import 'package:unseen/modules/stream/domain/repository/stream_repository.dart';

class JoinStreamUseCase extends UseCase<LiveKitSessionEntity, String> {
  final StreamRepository repo;

  JoinStreamUseCase({required this.repo});

  @override
  Future<RepoResponse<LiveKitSessionEntity>> call(String missionId) =>
      repo.joinStream(missionId);
}
