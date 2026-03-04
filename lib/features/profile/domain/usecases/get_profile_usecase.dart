/// Get Profile Use Case
/// 
/// Retrieves the current user's profile information.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Get profile use case
class GetProfileUseCase implements UseCaseNoParams<UserEntity> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getProfile();
  }
}