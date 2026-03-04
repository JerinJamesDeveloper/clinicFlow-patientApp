/// Reset Password Use Case
/// 
/// Resets user password using token from email.
/// Validates new password and updates it.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Parameters for reset password use case
class ResetPasswordParams extends Equatable {
  /// Reset token from email
  final String token;
  
  /// New password
  final String newPassword;
  
  /// New password confirmation
  final String confirmPassword;

  const ResetPasswordParams({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [token, newPassword, confirmPassword];
}

/// Reset password use case - resets password with token
class ResetPasswordUseCase implements UseCase<Unit, ResetPasswordParams> {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ResetPasswordParams params) async {
    final errors = <String, List<String>>{};

    // Validate token
    if (params.token.isEmpty) {
      errors['token'] = ['Invalid reset token'];
    }

    // Validate new password
    final passwordError = Validators.password(params.newPassword);
    if (passwordError != null) {
      errors['newPassword'] = [passwordError];
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

    // Call repository to reset password
    return await _repository.resetPassword(
      token: params.token,
      newPassword: params.newPassword,
    );
  }
}