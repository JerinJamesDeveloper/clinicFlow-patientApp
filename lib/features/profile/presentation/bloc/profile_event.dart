/// Profile BLoC Events
/// 
/// Events that trigger state changes in the ProfileBloc.
library;

import 'package:equatable/equatable.dart';

/// Base class for all profile events
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load profile data
class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

/// Event to update profile information
class ProfileUpdateRequested extends ProfileEvent {
  /// Updated first name
  final String? firstName;
  
  /// Updated last name
  final String? lastName;
  
  /// Updated phone number
  final String? phoneNumber;

  const ProfileUpdateRequested({
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber];
}

/// Event to update avatar
class ProfileAvatarUpdateRequested extends ProfileEvent {
  /// Local path to the image
  final String imagePath;

  const ProfileAvatarUpdateRequested({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Event to remove avatar
class ProfileAvatarRemoveRequested extends ProfileEvent {
  const ProfileAvatarRemoveRequested();
}

/// Event to delete account
class ProfileDeleteAccountRequested extends ProfileEvent {
  /// Password for verification
  final String password;

  const ProfileDeleteAccountRequested({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Event to clear error state
class ProfileErrorCleared extends ProfileEvent {
  const ProfileErrorCleared();
}

/// Event to refresh profile
class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}