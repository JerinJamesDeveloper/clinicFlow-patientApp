/// User Model
/// 
/// Data model that extends UserEntity.
/// Handles JSON serialization/deserialization for API communication.
library;

import '../../domain/entities/user_entity.dart';

/// User data model with JSON serialization
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.role = UserRole.user,
    super.status = UserStatus.active,
    super.avatarUrl,
    super.phoneNumber,
    super.isEmailVerified = false,
    super.isPhoneVerified = false,
    required super.createdAt,
    super.updatedAt,
    super.lastLoginAt,
  });

  /// Creates a UserModel from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? 
                 json['firstName'] as String? ?? '',
      lastName: json['last_name'] as String? ?? 
                json['lastName'] as String? ?? '',
      role: UserRole.fromString(json['role'] as String? ?? 'user'),
      status: UserStatus.fromString(json['status'] as String? ?? 'active'),
      avatarUrl: json['avatar_url'] as String? ?? 
                 json['avatarUrl'] as String? ??
                 json['avatar'] as String?,
      phoneNumber: json['phone_number'] as String? ?? 
                   json['phoneNumber'] as String? ??
                   json['phone'] as String?,
      isEmailVerified: json['is_email_verified'] as bool? ?? 
                       json['isEmailVerified'] as bool? ??
                       json['email_verified'] as bool? ?? false,
      isPhoneVerified: json['is_phone_verified'] as bool? ?? 
                       json['isPhoneVerified'] as bool? ??
                       json['phone_verified'] as bool? ?? false,
      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']) ?? 
                 DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
      lastLoginAt: _parseDateTime(json['last_login_at'] ?? json['lastLoginAt']),
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role.value,
      'status': status.value,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  /// Creates a UserModel from a UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      role: entity.role,
      status: entity.status,
      avatarUrl: entity.avatarUrl,
      phoneNumber: entity.phoneNumber,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  /// Converts this model to an entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      status: status,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
    );
  }

  /// Creates an empty UserModel
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      firstName: '',
      lastName: '',
      createdAt: DateTime.now(),
    );
  }

  /// Creates a copy with updated fields
  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    UserStatus? status,
    String? avatarUrl,
    String? phoneNumber,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Helper to parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }
}