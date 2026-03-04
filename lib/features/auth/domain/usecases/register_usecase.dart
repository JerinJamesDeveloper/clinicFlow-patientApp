/// Register Use Case
/// 
/// Handles new user registration with validation.
/// Creates a new user account and returns authenticated session.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/usecases/usecase.dart';

/// Parameters for register use case
class RegisterParams extends Equatable {
  /// User's email address
  final String email;
  
  /// User's password
  final String password;
  
  /// Password confirmation
  final String confirmPassword;
  
  /// User's first name
  final String firstName;
  
  /// User's last name
  final String lastName;
  
  /// Whether user accepted terms and conditions
  final bool acceptedTerms;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    this.acceptedTerms = false,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        firstName,
        lastName,
        acceptedTerms,
      ];
}

/// Register use case - creates a new user account
class RegisterUseCase implements UseCase<AuthSessionEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, AuthSessionEntity>> call(RegisterParams params) async {
    // Collect all validation errors
    final errors = <String, List<String>>{};

    // Validate first name
    final firstNameError = Validators.name(params.firstName, fieldName: 'First name');
    if (firstNameError != null) {
      errors['firstName'] = [firstNameError];
    }

    // Validate last name
    final lastNameError = Validators.name(params.lastName, fieldName: 'Last name');
    if (lastNameError != null) {
      errors['lastName'] = [lastNameError];
    }

    // Validate email
    final emailError = Validators.email(params.email);
    if (emailError != null) {
      errors['email'] = [emailError];
    }

    // Validate password
    final passwordError = Validators.password(params.password);
    if (passwordError != null) {
      errors['password'] = [passwordError];
    }

    // Validate password confirmation
    final confirmPasswordError = Validators.confirmPassword(
      params.confirmPassword,
      params.password,
    );
    if (confirmPasswordError != null) {
      errors['confirmPassword'] = [confirmPasswordError];
    }

    // Check terms acceptance
    if (!params.acceptedTerms) {
      errors['acceptedTerms'] = ['You must accept the terms and conditions'];
    }

    // Return validation errors if any
    if (errors.isNotEmpty) {
      return Left(ValidationFailure(
        message: 'Please fix the errors below',
        fieldErrors: errors,
      ));
    }

    // Call repository to perform registration
    return await _repository.register(
      email: params.email.trim().toLowerCase(),
      password: params.password,
      firstName: params.firstName.trim(),
      lastName: params.lastName.trim(),
    );
  }
}