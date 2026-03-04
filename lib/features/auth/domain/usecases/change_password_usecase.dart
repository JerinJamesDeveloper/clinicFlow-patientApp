/// Change Password Use Case
/// 
/// Changes password for authenticated user.
/// Requires current password for verification.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Parameters for change password use case
class ChangePasswordParams extends Equatable {
  /// Current password for verification
  final String currentPassword;
  
  /// New password
  final String newPassword;
  
  /// New password confirmation
  final String confirmPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

/// Change password use case - changes password for authenticated user
class ChangePasswordUseCase implements UseCase<Unit, ChangePasswordParams> {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ChangePasswordParams params) async {
    final errors = <String, List<String>>{};

    // Validate current password is provided
    if (params.currentPassword.isEmpty) {
      errors['currentPassword'] = ['Current password is required'];
    }

    // Validate new password
    final passwordError = Validators.password(params.newPassword);
    if (passwordError != null) {
      errors['newPassword'] = [passwordError];
    }

    // Check new password is different from current
    if (params.newPassword == params.currentPassword) {
      errors['newPassword'] = ['New password must be different from current password'];
    }

    // Validate password confirmation
    final confirmError = Validators.confirmPassword(
      params.confirmPassword,
      params.newPassword,
    );
    if (confirmError != null) {
      errors['confirmPassword'] = [confirmError];
    }

    // Return validation errors if any
    if (errors.isNotEmpty) {
      return Left(ValidationFailure(
        message: 'Please fix the errors below',
        fieldErrors: errors,
      ));
    }

    // Call repository to change password
    return await _repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}