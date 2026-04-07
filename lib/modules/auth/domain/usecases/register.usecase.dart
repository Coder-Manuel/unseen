import 'dart:async';

import 'package:unseen/core/entities/user.entity.dart';
import 'package:unseen/core/types/repo_reponse.type.dart';
import 'package:unseen/core/types/usecase.dart';
import 'package:unseen/modules/auth/data/models/auth.inputs.dart';
import 'package:unseen/modules/auth/domain/repository/auth_repository.dart';

/// Alias for [SignupInput] — registers/signs-up a new user with email + password.
class RegisterUsecase implements UseCase<User, SignupInput> {
  final AuthRepository repo;
  RegisterUsecase({required this.repo});

  @override
  FutureOr<RepoResponse<User>> call(SignupInput params) => repo.signup(params);
}
