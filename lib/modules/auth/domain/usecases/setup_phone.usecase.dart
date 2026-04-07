import 'dart:async';

import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/types/usecase.dart';
import 'package:unseen/modules/auth/data/models/auth.inputs.dart';
import 'package:unseen/modules/auth/domain/repository/auth_repository.dart';

class SetupPhoneUseCase implements UseCase<bool, PhoneSetupInput> {
  final AuthRepository repo;
  SetupPhoneUseCase({required this.repo});

  @override
  FutureOr<RepoResponse<bool>> call(PhoneSetupInput params) =>
      repo.setupPhone(params);
}
