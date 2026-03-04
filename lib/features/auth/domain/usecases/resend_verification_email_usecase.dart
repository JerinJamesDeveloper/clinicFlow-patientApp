library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for resending email verification link/code.
class ResendVerificationEmailUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository _repository;

  ResendVerificationEmailUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return _repository.resendVerificationEmail();
  }
}
