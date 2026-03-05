/// Appointments BLoC States
///
/// States representing the current appointments status.
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointments_entity.dart';
import '../../domain/entities/queue_status_entity.dart';

/// Base class for all appointments states
sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

/// Loading state
class AppointmentsLoading extends AppointmentsState {
  final String? message;

  const AppointmentsLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Single appointments loaded successfully
class AppointmentsLoaded extends AppointmentsState {
  final AppointmentsEntity appointments;

  const AppointmentsLoaded({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

/// List of appointmentss loaded successfully
class AppointmentsListLoaded extends AppointmentsState {
  final List<AppointmentsEntity> appointmentss;

  const AppointmentsListLoaded({required this.appointmentss});

  @override
  List<Object?> get props => [appointmentss];
}

/// Operation in progress
class AppointmentsOperating extends AppointmentsState {
  final List<AppointmentsEntity> appointmentss;
  final AppointmentsOperation operation;

  const AppointmentsOperating({
    required this.appointmentss,
    required this.operation,
  });

  @override
  List<Object?> get props => [appointmentss, operation];
}

/// Operation completed successfully
class AppointmentsOperationSuccess extends AppointmentsState {
  final List<AppointmentsEntity> appointmentss;
  final String message;

  const AppointmentsOperationSuccess({
    required this.appointmentss,
    this.message = 'Operation completed successfully',
  });

  @override
  List<Object?> get props => [appointmentss, message];
}

/// Error state
class AppointmentsError extends AppointmentsState {
  final String message;
  final Map<String, List<String>>? fieldErrors;
  final List<AppointmentsEntity>? appointmentss;

  const AppointmentsError({
    required this.message,
    this.fieldErrors,
    this.appointmentss,
  });

  String? getFieldError(String field) {
    return fieldErrors?[field]?.first;
  }

  bool get hasFieldErrors => fieldErrors != null && fieldErrors!.isNotEmpty;

  @override
  List<Object?> get props => [message, fieldErrors, appointmentss];
}

/// Operation types
enum AppointmentsOperation {
  getDoctorDetail,
  getDoctorSchedule,
  getQueueStatus,
  getAppointmentDetail,
  rescheduleAppointment,
  cancelAppointment,
  createAppointment,
  create,
  update,
  delete,
}

// -------------------- Appointment States --------------------

class AppointmentInitial extends AppointmentsState {}

class AppointmentLoading extends AppointmentsState {}

class AppointmentLoaded extends AppointmentsState {
  final AppointmentEntity appointment;
  const AppointmentLoaded(this.appointment);
}

class AppointmentListLoaded extends AppointmentsState {
  final List<AppointmentEntity> appointments;
  const AppointmentListLoaded(this.appointments);
}

class AppointmentOperationSuccess extends AppointmentsState {
  final String message;
  final AppointmentEntity? appointment;
  const AppointmentOperationSuccess(this.message, {this.appointment});
}

class AppointmentError extends AppointmentsState {
  final String message;
  const AppointmentError(this.message);
}

// -------------------- QueueStatus States --------------------

class QueueStatusInitial extends AppointmentsState {}

class QueueStatusLoading extends AppointmentsState {}

class QueueStatusLoaded extends AppointmentsState {
  final QueueStatusEntity queueStatus;
  const QueueStatusLoaded(this.queueStatus);
}

class QueueStatusListLoaded extends AppointmentsState {
  final List<QueueStatusEntity> queueStatuss;
  const QueueStatusListLoaded(this.queueStatuss);
}

class QueueStatusOperationSuccess extends AppointmentsState {
  final String message;
  final QueueStatusEntity? queueStatus;
  const QueueStatusOperationSuccess(this.message, {this.queueStatus});
}

class QueueStatusError extends AppointmentsState {
  final String message;
  const QueueStatusError(this.message);
}
