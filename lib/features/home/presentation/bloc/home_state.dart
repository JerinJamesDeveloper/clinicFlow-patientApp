/// Home BLoC States
///
/// States representing the current home status.
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/home_entity.dart';

/// Base class for all home states
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state
class HomeLoading extends HomeState {
  final String? message;

  const HomeLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Single home loaded successfully
class HomeLoaded extends HomeState {
  final HomeEntity home;

  const HomeLoaded({required this.home});

  @override
  List<Object?> get props => [home];
}

/// List of homes loaded successfully
class HomeListLoaded extends HomeState {
  final List<HomeEntity> homes;

  const HomeListLoaded({required this.homes});

  @override
  List<Object?> get props => [homes];
}

/// Operation in progress
class HomeOperating extends HomeState {
  final List<HomeEntity> homes;
  final HomeOperation operation;

  const HomeOperating({
    required this.homes,
    required this.operation,
  });

  @override
  List<Object?> get props => [homes, operation];
}

/// Operation completed successfully
class HomeOperationSuccess extends HomeState {
  final List<HomeEntity> homes;
  final String message;

  const HomeOperationSuccess({
    required this.homes,
    this.message = 'Operation completed successfully',
  });

  @override
  List<Object?> get props => [homes, message];
}

/// Error state
class HomeError extends HomeState {
  final String message;
  final Map<String, List<String>>? fieldErrors;
  final List<HomeEntity>? homes;

  const HomeError({
    required this.message,
    this.fieldErrors,
    this.homes,
  });

  String? getFieldError(String field) {
    return fieldErrors?[field]?.first;
  }

  bool get hasFieldErrors => fieldErrors != null && fieldErrors!.isNotEmpty;

  @override
  List<Object?> get props => [message, fieldErrors, homes];
}

/// Operation types
enum HomeOperation {
  create,
  update,
  delete,
}
