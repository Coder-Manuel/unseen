import 'dart:async';

import 'package:unseen/core/entities/user.entity.dart';
import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/types/usecase.dart';
import 'package:unseen/modules/auth/data/models/auth.inputs.dart';
import 'package:unseen/modules/auth/domain/repository/auth_repository.dart';

class VerifyEmailOtpUseCase implements UseCase<User, VerifyOtpInput> {
  final AuthRepository repo;
  VerifyEmailOtpUseCase({required this.repo});

  @override
  FutureOr<RepoResponse<User>> call(VerifyOtpInput params) =>
      repo.verifyEmailOtp(params);
}
