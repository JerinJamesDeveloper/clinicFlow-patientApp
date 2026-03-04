/// Forgot Password Use Case
/// 
/// Initiates password reset process.
/// Sends reset email to the specified address.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Parameters for forgot password use case
class ForgotPasswordParams extends Equatable {
  /// User's email address
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Forgot password use case - sends password reset email
class ForgotPasswordUseCase implements UseCase<Unit, ForgotPasswordParams> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(ForgotPasswordParams params) async {
    // Validate email
    final emailError = Validators.email(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(
        message: emailError,
        fieldErrors: {'email': [emailError]},
      ));
    }

    // Call repository to send reset email
    return await _repository.forgotPassword(
      email: params.email.trim().toLowerCase(),
    );
  }
}