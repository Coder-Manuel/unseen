import 'dart:async';

import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/types/usecase.dart';
import 'package:unseen/modules/auth/domain/repository/auth_repository.dart';

class LogoutUseCase implements UseCase<bool, dynamic> {
  final AuthRepository repo;
  LogoutUseCase({required this.repo});

  @override
  FutureOr<RepoResponse<bool>> call([_]) => repo.logout();
}
