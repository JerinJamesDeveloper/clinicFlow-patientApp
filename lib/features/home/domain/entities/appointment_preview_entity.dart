/// AppointmentPreview Entity
///
/// Core business entity representing a appointment_preview in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// AppointmentPreview entity representing the core appointment_preview data
class AppointmentPreviewEntity extends Equatable {
  /// Appointment id
  final String appointmentId;

  /// Doctor name
  final String doctorName;

  /// Department name
  final String departmentName;

  /// Hospital branch
  final String hospitalBranch;

  /// Appointment date
  final String appointmentDate;

  /// Slot time
  final String slotTime;

  /// Status
  final String status;

  /// Token number
  final int tokenNumber;

  const AppointmentPreviewEntity({
    required this.appointmentId,
    required this.doctorName,
    required this.departmentName,
    required this.hospitalBranch,
    required this.appointmentDate,
    required this.slotTime,
    required this.status,
    required this.tokenNumber,
  });

  /// Creates a copy with updated fields
  AppointmentPreviewEntity copyWith({
    String? appointmentId,
    String? doctorName,
    String? departmentName,
    String? hospitalBranch,
    String? appointmentDate,
    String? slotTime,
    String? status,
    int? tokenNumber,
  }) {
    return AppointmentPreviewEntity(
      appointmentId: appointmentId ?? this.appointmentId,
      doctorName: doctorName ?? this.doctorName,
      departmentName: departmentName ?? this.departmentName,
      hospitalBranch: hospitalBranch ?? this.hospitalBranch,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      slotTime: slotTime ?? this.slotTime,
      status: status ?? this.status,
      tokenNumber: tokenNumber ?? this.tokenNumber,
    );
  }

  /// Creates an empty AppointmentPreview
  factory AppointmentPreviewEntity.empty() {
    return AppointmentPreviewEntity(
      appointmentId: '',
      doctorName: '',
      departmentName: '',
      hospitalBranch: '',
      appointmentDate: '',
      slotTime: '',
      status: '',
      tokenNumber: 0,
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => appointmentId.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => appointmentId.isNotEmpty;

  @override
  List<Object?> get props => [
        appointmentId,
        doctorName,
        departmentName,
        hospitalBranch,
        appointmentDate,
        slotTime,
        status,
        tokenNumber,
      ];

  @override
  String toString() {
    return 'AppointmentPreviewEntity(appointmentId: $appointmentId, doctorName: $doctorName, departmentName: $departmentName)';
  }
}
