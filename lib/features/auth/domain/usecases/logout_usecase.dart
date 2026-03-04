/// Logout Use Case
/// 
/// Handles user logout process.
/// Clears local session and invalidates server tokens.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Logout use case - logs out the current user
class LogoutUseCase implements UseCaseNoParams<Unit> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call() async {
    return await _repository.logout();
  }
}