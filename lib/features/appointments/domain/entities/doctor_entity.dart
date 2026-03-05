/// Doctor Entity
///
/// Core business entity representing a doctor in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// Doctor entity representing the core doctor data
class DoctorEntity extends Equatable {
  /// First name
  final String firstName;

  /// Last name
  final String lastName;

  /// Salutation
  final String salutation;

  /// Gender code
  final String genderCode;

  /// Specialization
  final String specialization;

  /// Sub specialization
  final String subSpecialization;

  /// Qualifications
  final String qualifications;

  /// Profile photo url
  final String profilePhotoUrl;

  /// Mci registration number
  final String mciRegistrationNumber;

  /// Experience years
  final int experienceYears;

  /// Max patients per day
  final int maxPatientsPerDay;

  /// Avg consultation min
  final int avgConsultationMin;

  /// Consultation fee
  final double consultationFee;

  /// Follow up fee
  final double followUpFee;

  /// Is available online
  final bool isAvailableOnline;

  const DoctorEntity({
    required this.firstName,
    required this.lastName,
    required this.salutation,
    required this.genderCode,
    required this.specialization,
    required this.subSpecialization,
    required this.qualifications,
    required this.profilePhotoUrl,
    required this.mciRegistrationNumber,
    required this.experienceYears,
    required this.maxPatientsPerDay,
    required this.avgConsultationMin,
    required this.consultationFee,
    required this.followUpFee,
    required this.isAvailableOnline,
  });

  /// Creates a copy with updated fields
  DoctorEntity copyWith({
    String? firstName,
    String? lastName,
    String? salutation,
    String? genderCode,
    String? specialization,
    String? subSpecialization,
    String? qualifications,
    String? profilePhotoUrl,
    String? mciRegistrationNumber,
    int? experienceYears,
    int? maxPatientsPerDay,
    int? avgConsultationMin,
    double? consultationFee,
    double? followUpFee,
    bool? isAvailableOnline,
  }) {
    return DoctorEntity(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      salutation: salutation ?? this.salutation,
      genderCode: genderCode ?? this.genderCode,
      specialization: specialization ?? this.specialization,
      subSpecialization: subSpecialization ?? this.subSpecialization,
      qualifications: qualifications ?? this.qualifications,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      mciRegistrationNumber: mciRegistrationNumber ?? this.mciRegistrationNumber,
      experienceYears: experienceYears ?? this.experienceYears,
      maxPatientsPerDay: maxPatientsPerDay ?? this.maxPatientsPerDay,
      avgConsultationMin: avgConsultationMin ?? this.avgConsultationMin,
      consultationFee: consultationFee ?? this.consultationFee,
      followUpFee: followUpFee ?? this.followUpFee,
      isAvailableOnline: isAvailableOnline ?? this.isAvailableOnline,
    );
  }

  /// Creates an empty Doctor
  factory DoctorEntity.empty() {
    return DoctorEntity(
      firstName: '',
      lastName: '',
      salutation: '',
      genderCode: '',
      specialization: '',
      subSpecialization: '',
      qualifications: '',
      profilePhotoUrl: '',
      mciRegistrationNumber: '',
      experienceYears: 0,
      maxPatientsPerDay: 0,
      avgConsultationMin: 0,
      consultationFee: 0.0,
      followUpFee: 0.0,
      isAvailableOnline: false,
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => firstName.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => firstName.isNotEmpty;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        salutation,
        genderCode,
        specialization,
        subSpecialization,
        qualifications,
        profilePhotoUrl,
        mciRegistrationNumber,
        experienceYears,
        maxPatientsPerDay,
        avgConsultationMin,
        consultationFee,
        followUpFee,
        isAvailableOnline,
      ];

  @override
  String toString() {
    return 'DoctorEntity(firstName: $firstName, lastName: $lastName, salutation: $salutation)';
  }
}
