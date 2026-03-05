/// Appointments BLoC Events
///
/// Events that trigger state changes in the AppointmentsBloc.
library;

import 'package:equatable/equatable.dart';

/// Base class for all appointments events
sealed class AppointmentsEvent extends Equatable {
  const AppointmentsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load a single appointments
class AppointmentsLoadRequested extends AppointmentsEvent {
  final String id;

  const AppointmentsLoadRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to load all appointmentss
class AppointmentsListLoadRequested extends AppointmentsEvent {
  const AppointmentsListLoadRequested();
}

/// Event to create a new appointments
class AppointmentsCreateRequested extends AppointmentsEvent {
  final String name;
  final String? description;

  const AppointmentsCreateRequested({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// Event to update an existing appointments
class AppointmentsUpdateRequested extends AppointmentsEvent {
  final String id;
  final String? name;
  final String? description;
  final bool? isActive;

  const AppointmentsUpdateRequested({
    required this.id,
    this.name,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

/// Event to delete a appointments
class AppointmentsDeleteRequested extends AppointmentsEvent {
  final String id;

  const AppointmentsDeleteRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to refresh appointmentss
class AppointmentsRefreshRequested extends AppointmentsEvent {
  const AppointmentsRefreshRequested();
}

/// Event to clear error state
class AppointmentsErrorCleared extends AppointmentsEvent {
  const AppointmentsErrorCleared();
}

/// Event to GetDoctors
class AppointmentsGetDoctorsRequested extends AppointmentsEvent {
  const AppointmentsGetDoctorsRequested();
}

/// Event to GetDoctorDetail
class AppointmentsGetDoctorDetailRequested extends AppointmentsEvent {
  final String doctorId;

  const AppointmentsGetDoctorDetailRequested({
    required this.doctorId,
  });

  @override
  List<Object?> get props => [doctorId];
}

/// Event to GetDepartments
class AppointmentsGetDepartmentsRequested extends AppointmentsEvent {
  const AppointmentsGetDepartmentsRequested();
}

/// Event to GetHospitalBranches
class AppointmentsGetHospitalBranchesRequested extends AppointmentsEvent {
  const AppointmentsGetHospitalBranchesRequested();
}

/// Event to GetDoctorSchedule
class AppointmentsGetDoctorScheduleRequested extends AppointmentsEvent {
  final String doctorId;

  const AppointmentsGetDoctorScheduleRequested({
    required this.doctorId,
  });

  @override
  List<Object?> get props => [doctorId];
}

/// Event to GetQueueStatus
class AppointmentsGetQueueStatusRequested extends AppointmentsEvent {
  final String doctorId;

  const AppointmentsGetQueueStatusRequested({
    required this.doctorId,
  });

  @override
  List<Object?> get props => [doctorId];
}

/// Event to GetUpcomingAppointments
class AppointmentsGetUpcomingAppointmentsRequested extends AppointmentsEvent {
  const AppointmentsGetUpcomingAppointmentsRequested();
}

/// Event to GetPastAppointments
class AppointmentsGetPastAppointmentsRequested extends AppointmentsEvent {
  const AppointmentsGetPastAppointmentsRequested();
}

/// Event to GetAppointmentDetail
class AppointmentsGetAppointmentDetailRequested extends AppointmentsEvent {
  final String appointmentId;

  const AppointmentsGetAppointmentDetailRequested({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}

/// Event to CreateAppointment
class AppointmentsCreateAppointmentRequested extends AppointmentsEvent {
  final String name;
  final String? description;

  const AppointmentsCreateAppointmentRequested({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// Event to CancelAppointment
class AppointmentsCancelAppointmentRequested extends AppointmentsEvent {
  final String appointmentId;

  const AppointmentsCancelAppointmentRequested({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}

/// Event to RescheduleAppointment
class AppointmentsRescheduleAppointmentRequested extends AppointmentsEvent {
  final String appointmentId;

  const AppointmentsRescheduleAppointmentRequested({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}
