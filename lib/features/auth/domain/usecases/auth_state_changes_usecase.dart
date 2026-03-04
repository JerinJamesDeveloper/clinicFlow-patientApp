/// Auth State Changes Use Case
/// 
/// Provides a stream of authentication state changes.
/// Used for reactive UI updates when auth state changes.
library;

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Auth state changes use case - streams auth state updates
class AuthStateChangesUseCase implements StreamUseCaseNoParams<UserEntity?> {
  final AuthRepository _repository;

  AuthStateChangesUseCase(this._repository);

  @override
  Stream<UserEntity?> call() {
    return _repository.authStateChanges;
  }
}