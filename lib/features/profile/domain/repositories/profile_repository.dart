/// Profile Repository Interface
/// 
/// Abstract repository defining the contract for profile operations.
/// Implemented by the data layer.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

/// Abstract repository interface for profile operations
abstract class ProfileRepository {
  /// Gets the current user's profile
  /// 
  /// Returns [UserEntity] on success or [Failure] on error.
  Future<Either<Failure, UserEntity>> getProfile();

  /// Updates the user's profile
  /// 
  /// Returns updated [UserEntity] on success or [Failure] on error.
  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  });

  /// Updates the user's avatar
  /// 
  /// [imagePath] is the local path to the image file.
  /// Returns updated [UserEntity] with new avatar URL on success.
  Future<Either<Failure, UserEntity>> updateAvatar(String imagePath);

  /// Removes the user's avatar
  /// 
  /// Returns updated [UserEntity] on success.
  Future<Either<Failure, UserEntity>> removeAvatar();

  /// Deletes the user's account
  /// 
  /// Requires [password] for verification.
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> deleteAccount(String password);

  /// Gets profile completion percentage
  /// 
  /// Returns a value between 0 and 100.
  int getProfileCompletionPercentage(UserEntity user);
}