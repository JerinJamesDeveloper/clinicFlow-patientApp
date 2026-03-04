/// Check Auth Status Use Case
/// 
/// Checks if user is currently authenticated.
/// Returns boolean indicating authentication status.
library;

import '../repositories/auth_repository.dart';

/// Check authentication status use case
class CheckAuthStatusUseCase {
  final AuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  /// Returns true if user is authenticated
  Future<bool> call() async {
    return await _repository.isAuthenticated();
  }
}