/// Appointment Entity
///
/// Core business entity representing a appointment in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// Appointment entity representing the core appointment data
class AppointmentEntity extends Equatable {
  /// Patient id
  final String patientId;

  /// Doctor id
  final String doctorId;

  /// Department id
  final String departmentId;

  /// Branch id
  final String branchId;

  /// Family member id
  final String familyMemberId;

  /// Appointment date
  final String appointmentDate;

  /// Slot start time
  final String slotStartTime;

  /// Slot end time
  final String slotEndTime;

  /// Booking source
  final String bookingSource;

  /// Appointment type
  final String appointmentType;

  /// Visit reason
  final String visitReason;

  /// Chief complaint
  final String chiefComplaint;

  /// Priority
  final String priority;

  /// Status
  final String status;

  /// Cancellation reason
  final String cancellationReason;

  /// Cancelled by
  final String cancelledBy;

  /// Token number
  final int tokenNumber;

  const AppointmentEntity({
    required this.patientId,
    required this.doctorId,
    required this.departmentId,
    required this.branchId,
    required this.familyMemberId,
    required this.appointmentDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.bookingSource,
    required this.appointmentType,
    required this.visitReason,
    required this.chiefComplaint,
    required this.priority,
    required this.status,
    required this.cancellationReason,
    required this.cancelledBy,
    required this.tokenNumber,
  });

  /// Creates a copy with updated fields
  AppointmentEntity copyWith({
    String? patientId,
    String? doctorId,
    String? departmentId,
    String? branchId,
    String? familyMemberId,
    String? appointmentDate,
    String? slotStartTime,
    String? slotEndTime,
    String? bookingSource,
    String? appointmentType,
    String? visitReason,
    String? chiefComplaint,
    String? priority,
    String? status,
    String? cancellationReason,
    String? cancelledBy,
    int? tokenNumber,
  }) {
    return AppointmentEntity(
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      departmentId: departmentId ?? this.departmentId,
      branchId: branchId ?? this.branchId,
      familyMemberId: familyMemberId ?? this.familyMemberId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      slotStartTime: slotStartTime ?? this.slotStartTime,
      slotEndTime: slotEndTime ?? this.slotEndTime,
      bookingSource: bookingSource ?? this.bookingSource,
      appointmentType: appointmentType ?? this.appointmentType,
      visitReason: visitReason ?? this.visitReason,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      tokenNumber: tokenNumber ?? this.tokenNumber,
    );
  }

  /// Creates an empty Appointment
  factory AppointmentEntity.empty() {
    return AppointmentEntity(
      patientId: '',
      doctorId: '',
      departmentId: '',
      branchId: '',
      familyMemberId: '',
      appointmentDate: '',
      slotStartTime: '',
      slotEndTime: '',
      bookingSource: '',
      appointmentType: '',
      visitReason: '',
      chiefComplaint: '',
      priority: '',
      status: '',
      cancellationReason: '',
      cancelledBy: '',
      tokenNumber: 0,
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => patientId.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => patientId.isNotEmpty;

  @override
  List<Object?> get props => [
        patientId,
        doctorId,
        departmentId,
        branchId,
        familyMemberId,
        appointmentDate,
        slotStartTime,
        slotEndTime,
        bookingSource,
        appointmentType,
        visitReason,
        chiefComplaint,
        priority,
        status,
        cancellationReason,
        cancelledBy,
        tokenNumber,
      ];

  @override
  String toString() {
    return 'AppointmentEntity(patientId: $patientId, doctorId: $doctorId, departmentId: $departmentId)';
  }
}
