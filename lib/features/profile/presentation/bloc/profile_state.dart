/// Profile BLoC States
/// 
/// States representing the current profile status.
library;

import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';

/// Base class for all profile states
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state
class ProfileLoading extends ProfileState {
  /// Optional message
  final String? message;

  const ProfileLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Profile loaded successfully
class ProfileLoaded extends ProfileState {
  /// User profile data
  final UserEntity user;
  
  /// Profile completion percentage
  final int completionPercentage;

  const ProfileLoaded({
    required this.user,
    this.completionPercentage = 0,
  });

  @override
  List<Object?> get props => [user, completionPercentage];
}

/// Profile update in progress
class ProfileUpdating extends ProfileState {
  /// Current user data
  final UserEntity user;
  
  /// Update type
  final ProfileUpdateType updateType;

  const ProfileUpdating({
    required this.user,
    required this.updateType,
  });

  @override
  List<Object?> get props => [user, updateType];
}

/// Profile updated successfully
class ProfileUpdateSuccess extends ProfileState {
  /// Updated user data
  final UserEntity user;
  
  /// Success message
  final String message;

  const ProfileUpdateSuccess({
    required this.user,
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object?> get props => [user, message];
}

/// Profile error
class ProfileError extends ProfileState {
  /// Error message
  final String message;
  
  /// Field-specific errors
  final Map<String, List<String>>? fieldErrors;
  
  /// Previous user data (if any)
  final UserEntity? user;

  const ProfileError({
    required this.message,
    this.fieldErrors,
    this.user,
  });

  /// Get error for a specific field
  String? getFieldError(String field) {
    return fieldErrors?[field]?.first;
  }

  /// Check if there are field errors
  bool get hasFieldErrors => fieldErrors != null && fieldErrors!.isNotEmpty;

  @override
  List<Object?> get props => [message, fieldErrors, user];
}

/// Account deleted successfully
class ProfileAccountDeleted extends ProfileState {
  const ProfileAccountDeleted();
}

/// Profile update types
enum ProfileUpdateType {
  profile,
  avatar,
  deleteAccount,
}