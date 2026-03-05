/// DoctorSchedule Entity
///
/// Core business entity representing a doctor_schedule in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// DoctorSchedule entity representing the core doctor_schedule data
class DoctorScheduleEntity extends Equatable {
  /// Doctor id
  final String doctorId;

  /// Branch id
  final String branchId;

  /// Slot start time
  final String slotStartTime;

  /// Slot end time
  final String slotEndTime;

  /// Effective from
  final String effectiveFrom;

  /// Effective until
  final String effectiveUntil;

  /// Day of week
  final int dayOfWeek;

  /// Max tokens
  final int maxTokens;

  /// Is active
  final bool isActive;

  const DoctorScheduleEntity({
    required this.doctorId,
    required this.branchId,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.effectiveFrom,
    required this.effectiveUntil,
    required this.dayOfWeek,
    required this.maxTokens,
    required this.isActive,
  });

  /// Creates a copy with updated fields
  DoctorScheduleEntity copyWith({
    String? doctorId,
    String? branchId,
    String? slotStartTime,
    String? slotEndTime,
    String? effectiveFrom,
    String? effectiveUntil,
    int? dayOfWeek,
    int? maxTokens,
    bool? isActive,
  }) {
    return DoctorScheduleEntity(
      doctorId: doctorId ?? this.doctorId,
      branchId: branchId ?? this.branchId,
      slotStartTime: slotStartTime ?? this.slotStartTime,
      slotEndTime: slotEndTime ?? this.slotEndTime,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveUntil: effectiveUntil ?? this.effectiveUntil,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      maxTokens: maxTokens ?? this.maxTokens,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Creates an empty DoctorSchedule
  factory DoctorScheduleEntity.empty() {
    return DoctorScheduleEntity(
      doctorId: '',
      branchId: '',
      slotStartTime: '',
      slotEndTime: '',
      effectiveFrom: '',
      effectiveUntil: '',
      dayOfWeek: 0,
      maxTokens: 0,
      isActive: false,
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => doctorId.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => doctorId.isNotEmpty;

  @override
  List<Object?> get props => [
        doctorId,
        branchId,
        slotStartTime,
        slotEndTime,
        effectiveFrom,
        effectiveUntil,
        dayOfWeek,
        maxTokens,
        isActive,
      ];

  @override
  String toString() {
    return 'DoctorScheduleEntity(doctorId: $doctorId, branchId: $branchId, slotStartTime: $slotStartTime)';
  }
}
