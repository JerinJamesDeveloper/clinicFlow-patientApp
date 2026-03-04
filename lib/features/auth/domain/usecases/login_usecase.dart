/// Login Use Case
/// 
/// Handles user authentication with email and password.
/// Validates input, calls repository, and returns authenticated user.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Parameters for login use case
class LoginParams extends Equatable {
  /// User's email address
  final String email;
  
  /// User's password
  final String password;
  
  /// Whether to remember the user (extended session)
  final bool rememberMe;

  const LoginParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Login use case - authenticates user with email and password
class LoginUseCase implements UseCase<AuthSessionEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, AuthSessionEntity>> call(LoginParams params) async {
    // Validate email
    final emailError = Validators.email(params.email);
    if (emailError != null) {
      return Left(ValidationFailure(
        message: emailError,
        fieldErrors: {'email': [emailError]},
      ));
    }

    // Validate password (basic validation for login)
    final passwordError = Validators.password(params.password);
    if (passwordError != null) {
      return Left(ValidationFailure(
        message: passwordError,
        fieldErrors: {'password': [passwordError]},
      ));
    }

    // Call repository to perform login
    return await _repository.login(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }
}