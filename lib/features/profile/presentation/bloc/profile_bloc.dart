/// Profile BLoC
/// 
/// Business Logic Component for profile management.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Profile BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateAvatarUseCase _updateAvatarUseCase;
  final RemoveAvatarUseCase _removeAvatarUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ProfileRepository _repository;

  ProfileBloc({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required UpdateAvatarUseCase updateAvatarUseCase,
    required RemoveAvatarUseCase removeAvatarUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required ProfileRepository repository,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _updateAvatarUseCase = updateAvatarUseCase,
        _removeAvatarUseCase = removeAvatarUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _repository = repository,
        super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
    on<ProfileAvatarUpdateRequested>(_onAvatarUpdateRequested);
    on<ProfileAvatarRemoveRequested>(_onAvatarRemoveRequested);
    on<ProfileDeleteAccountRequested>(_onDeleteAccountRequested);
    on<ProfileErrorCleared>(_onErrorCleared);
    on<ProfileRefreshRequested>(_onRefreshRequested);
  }

  /// Load profile
  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading(message: 'Loading profile...'));

    final result = await _getProfileUseCase();

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileLoaded(
        user: user,
        completionPercentage: _repository.getProfileCompletionPercentage(user),
      )),
    );
  }

  /// Update profile
  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentUser = _getCurrentUser();
    
    if (currentUser != null) {
      emit(ProfileUpdating(
        user: currentUser,
        updateType: ProfileUpdateType.profile,
      ));
    } else {
      emit(const ProfileLoading(message: 'Updating profile...'));
    }

    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentUser)),
      (user) => emit(ProfileUpdateSuccess(
        user: user,
        message: 'Profile updated successfully',
      )),
    );
  }

  /// Update avatar
  Future<void> _onAvatarUpdateRequested(
    ProfileAvatarUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentUser = _getCurrentUser();
    
    if (currentUser != null) {
      emit(ProfileUpdating(
        user: currentUser,
        updateType: ProfileUpdateType.avatar,
      ));
    }

    final result = await _updateAvatarUseCase(
      UpdateAvatarParams(imagePath: event.imagePath),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentUser)),
      (user) => emit(ProfileUpdateSuccess(
        user: user,
        message: 'Avatar updated successfully',
      )),
    );
  }

  /// Remove avatar
  Future<void> _onAvatarRemoveRequested(
    ProfileAvatarRemoveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentUser = _getCurrentUser();
    
    if (currentUser != null) {
      emit(ProfileUpdating(
        user: currentUser,
        updateType: ProfileUpdateType.avatar,
      ));
    }

    final result = await _removeAvatarUseCase();

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentUser)),
      (user) => emit(ProfileUpdateSuccess(
        user: user,
        message: 'Avatar removed successfully',
      )),
    );
  }

  /// Delete account
  Future<void> _onDeleteAccountRequested(
    ProfileDeleteAccountRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentUser = _getCurrentUser();
    
    if (currentUser != null) {
      emit(ProfileUpdating(
        user: currentUser,
        updateType: ProfileUpdateType.deleteAccount,
      ));
    }

    final result = await _deleteAccountUseCase(
      DeleteAccountParams(password: event.password),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentUser)),
      (_) => emit(const ProfileAccountDeleted()),
    );
  }

  /// Clear error
  void _onErrorCleared(
    ProfileErrorCleared event,
    Emitter<ProfileState> emit,
  ) {
    final currentUser = _getCurrentUser();
    if (currentUser != null) {
      emit(ProfileLoaded(
        user: currentUser,
        completionPercentage: _repository.getProfileCompletionPercentage(currentUser),
      ));
    } else {
      emit(const ProfileInitial());
    }
  }

  /// Refresh profile
  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Don't show loading, just refresh in background
    final result = await _getProfileUseCase();

    result.fold(
      (failure) {
        // Keep current state on refresh failure
      },
      (user) => emit(ProfileLoaded(
        user: user,
        completionPercentage: _repository.getProfileCompletionPercentage(user),
      )),
    );
  }

  /// Get current user from state
  UserEntity? _getCurrentUser() {
    final currentState = state;
    if (currentState is ProfileLoaded) return currentState.user;
    if (currentState is ProfileUpdating) return currentState.user;
    if (currentState is ProfileUpdateSuccess) return currentState.user;
    if (currentState is ProfileError) return currentState.user;
    return null;
  }

  /// Map failure to error state
  ProfileError _mapFailureToState(Failure failure, UserEntity? user) {
    if (failure is ValidationFailure) {
      return ProfileError(
        message: failure.message,
        fieldErrors: failure.fieldErrors,
        user: user,
      );
    }
    return ProfileError(
      message: failure.message,
      user: user,
    );
  }
}