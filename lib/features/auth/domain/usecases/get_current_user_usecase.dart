/// Get Current User Use Case
/// 
/// Retrieves the currently authenticated user.
/// Checks local cache first, then fetches from server if needed.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Get current user use case - retrieves authenticated user
class GetCurrentUserUseCase implements UseCaseNoParams<UserEntity> {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser();
  }
}