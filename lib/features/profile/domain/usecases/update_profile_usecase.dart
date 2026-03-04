/// Update Profile Use Case
/// 
/// Updates the current user's profile information.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

/// Parameters for update profile use case
class UpdateProfileParams extends Equatable {
  /// Updated first name
  final String? firstName;
  
  /// Updated last name
  final String? lastName;
  
  /// Updated phone number
  final String? phoneNumber;

  const UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  /// Check if any field is being updated
  bool get hasChanges =>
      firstName != null || lastName != null || phoneNumber != null;

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber];
}

/// Update profile use case
class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    // Validate that there are changes
    if (!params.hasChanges) {
      return const Left(ValidationFailure(
        message: 'No changes to update',
      ));
    }

    // Validate fields
    final errors = <String, List<String>>{};

    if (params.firstName != null) {
      final error = Validators.name(params.firstName, fieldName: 'First name');
      if (error != null) {
        errors['firstName'] = [error];
      }
    }

    if (params.lastName != null) {
      final error = Validators.name(params.lastName, fieldName: 'Last name');
      if (error != null) {
        errors['lastName'] = [error];
      }
    }

    if (params.phoneNumber != null && params.phoneNumber!.isNotEmpty) {
      final error = Validators.phoneOptional(params.phoneNumber);
      if (error != null) {
        errors['phoneNumber'] = [error];
      }
    }

    if (errors.isNotEmpty) {
      return Left(ValidationFailure(
        message: 'Please fix the errors below',
        fieldErrors: errors,
      ));
    }

    return await _repository.updateProfile(
      firstName: params.firstName?.trim(),
      lastName: params.lastName?.trim(),
      phoneNumber: params.phoneNumber?.trim(),
    );
  }
}

/// Parameters for update avatar use case
class UpdateAvatarParams extends Equatable {
  /// Local path to the image file
  final String imagePath;

  const UpdateAvatarParams({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Update avatar use case
class UpdateAvatarUseCase implements UseCase<UserEntity, UpdateAvatarParams> {
  final ProfileRepository _repository;

  UpdateAvatarUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateAvatarParams params) async {
    if (params.imagePath.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Please select an image',
      ));
    }

    return await _repository.updateAvatar(params.imagePath);
  }
}

/// Remove avatar use case
class RemoveAvatarUseCase implements UseCaseNoParams<UserEntity> {
  final ProfileRepository _repository;

  RemoveAvatarUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.removeAvatar();
  }
}

/// Parameters for delete account use case
class DeleteAccountParams extends Equatable {
  /// Password for verification
  final String password;

  const DeleteAccountParams({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Delete account use case
class DeleteAccountUseCase implements UseCase<Unit, DeleteAccountParams> {
  final ProfileRepository _repository;

  DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteAccountParams params) async {
    if (params.password.isEmpty) {
      return const Left(ValidationFailure(
        message: 'Password is required to delete account',
      ));
    }

    return await _repository.deleteAccount(params.password);
  }
}