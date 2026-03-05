/// HospitalBranch Entity
///
/// Core business entity representing a hospital_branch in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// HospitalBranch entity representing the core hospital_branch data
class HospitalBranchEntity extends Equatable {
  /// Branch name
  final String branchName;

  /// Branch code
  final String branchCode;

  /// Address line1
  final String addressLine1;

  /// City
  final String city;

  /// State
  final String state;

  /// Pincode
  final String pincode;

  /// Phone
  final String phone;

  /// Email
  final String email;

  /// Latitude
  final double latitude;

  /// Longitude
  final double longitude;

  const HospitalBranchEntity({
    required this.branchName,
    required this.branchCode,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    required this.email,
    required this.latitude,
    required this.longitude,
  });

  /// Creates a copy with updated fields
  HospitalBranchEntity copyWith({
    String? branchName,
    String? branchCode,
    String? addressLine1,
    String? city,
    String? state,
    String? pincode,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
  }) {
    return HospitalBranchEntity(
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      addressLine1: addressLine1 ?? this.addressLine1,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  /// Creates an empty HospitalBranch
  factory HospitalBranchEntity.empty() {
    return HospitalBranchEntity(
      branchName: '',
      branchCode: '',
      addressLine1: '',
      city: '',
      state: '',
      pincode: '',
      phone: '',
      email: '',
      latitude: 0.0,
      longitude: 0.0,
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => branchName.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => branchName.isNotEmpty;

  @override
  List<Object?> get props => [
        branchName,
        branchCode,
        addressLine1,
        city,
        state,
        pincode,
        phone,
        email,
        latitude,
        longitude,
      ];

  @override
  String toString() {
    return 'HospitalBranchEntity(branchName: $branchName, branchCode: $branchCode, addressLine1: $addressLine1)';
  }
}
