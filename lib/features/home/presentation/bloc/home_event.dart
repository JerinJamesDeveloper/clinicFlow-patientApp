/// Home BLoC Events
///
/// Events that trigger state changes in the HomeBloc.
library;

import 'package:equatable/equatable.dart';

/// Base class for all home events
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load a single home
class HomeLoadRequested extends HomeEvent {
  final String id;

  const HomeLoadRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to load all homes
class HomeListLoadRequested extends HomeEvent {
  const HomeListLoadRequested();
}

/// Event to create a new home
class HomeCreateRequested extends HomeEvent {
  final String name;
  final String? description;

  const HomeCreateRequested({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// Event to update an existing home
class HomeUpdateRequested extends HomeEvent {
  final String id;
  final String? name;
  final String? description;
  final bool? isActive;

  const HomeUpdateRequested({
    required this.id,
    this.name,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

/// Event to delete a home
class HomeDeleteRequested extends HomeEvent {
  final String id;

  const HomeDeleteRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh homes
class HomeRefreshRequested extends HomeEvent {
  const HomeRefreshRequested();
}

/// Event to clear error state
class HomeErrorCleared extends HomeEvent {
  const HomeErrorCleared();
}

/// Event to GetHomeSummary
class HomeGetHomeSummaryRequested extends HomeEvent {
  final String id;

  const HomeGetHomeSummaryRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to GetHealthAlerts
class HomeGetHealthAlertsRequested extends HomeEvent {
  const HomeGetHealthAlertsRequested();
}

/// Event to GetUpcomingAppointments
class HomeGetUpcomingAppointmentsRequested extends HomeEvent {
  const HomeGetUpcomingAppointmentsRequested();
}
