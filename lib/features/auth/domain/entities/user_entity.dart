/// User Entity
/// 
/// Core business entity representing a user in the system.
/// This is a pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// User roles in the system
enum UserRole {
  /// Regular user with basic access
  user('user', 'User'),
  
  /// Administrator with full access
  admin('admin', 'Administrator');

  final String value;
  final String displayName;

  const UserRole(this.value, this.displayName);

  /// Creates a UserRole from a string value
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value.toLowerCase(),
      orElse: () => UserRole.user,
    );
  }
}

/// User account status
enum UserStatus {
  /// Account is active and can be used
  active('active', 'Active'),
  
  /// Account is inactive/disabled
  inactive('inactive', 'Inactive'),
  
  /// Account is pending verification
  pending('pending', 'Pending Verification'),
  
  /// Account is suspended
  suspended('suspended', 'Suspended');

  final String value;
  final String displayName;

  const UserStatus(this.value, this.displayName);

  /// Creates a UserStatus from a string value
  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (status) => status.value == value.toLowerCase(),
      orElse: () => UserStatus.active,
    );
  }
}

/// User entity representing the core user data
class UserEntity extends Equatable {
  /// Unique identifier
  final String id;
  
  /// User's email address
  final String email;
  
  /// User's first name
  final String firstName;
  
  /// User's last name
  final String lastName;
  
  /// User's role in the system
  final UserRole role;
  
  /// User's account status
  final UserStatus status;
  
  /// User's avatar/profile image URL
  final String? avatarUrl;
  
  /// User's phone number
  final String? phoneNumber;
  
  /// Whether email is verified
  final bool isEmailVerified;
  
  /// Whether phone is verified
  final bool isPhoneVerified;
  
  /// Account creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime? updatedAt;
  
  /// Last login timestamp
  final DateTime? lastLoginAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.role = UserRole.user,
    this.status = UserStatus.active,
    this.avatarUrl,
    this.phoneNumber,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  /// Returns the user's full name
  String get fullName => '$firstName $lastName'.trim();

  /// Returns the user's initials (first letter of first and last name)
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  /// Checks if the user is an admin
  bool get isAdmin => role == UserRole.admin;

  /// Checks if the user account is active
  bool get isActive => status == UserStatus.active;

  /// Checks if the user account is fully verified
  bool get isVerified => isEmailVerified;

  /// Checks if the user has a complete profile
  bool get hasCompleteProfile {
    return firstName.isNotEmpty && 
           lastName.isNotEmpty && 
           isEmailVerified;
  }

  /// Creates a copy of this entity with the given fields replaced
  UserEntity copyWith({
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
    return UserEntity(
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

  /// Creates an empty/guest user
  factory UserEntity.empty() {
    return UserEntity(
      id: '',
      email: '',
      firstName: '',
      lastName: '',
      role: UserRole.user,
      status: UserStatus.inactive,
      createdAt: DateTime.now(),
    );
  }

  /// Checks if this is an empty/guest user
  bool get isEmpty => id.isEmpty;

  /// Checks if this is not an empty user
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        status,
        avatarUrl,
        phoneNumber,
        isEmailVerified,
        isPhoneVerified,
        createdAt,
        updatedAt,
        lastLoginAt,
      ];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName, role: ${role.value})';
  }
}

/// Authentication tokens entity
class AuthTokensEntity extends Equatable {
  /// JWT access token
  final String accessToken;
  
  /// JWT refresh token
  final String refreshToken;
  
  /// Access token expiry timestamp
  final DateTime expiresAt;
  
  /// Token type (usually "Bearer")
  final String tokenType;

  const AuthTokensEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  /// Checks if the access token has expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Checks if the access token is about to expire (within 5 minutes)
  bool get isAboutToExpire {
    final threshold = expiresAt.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(threshold);
  }

  /// Remaining time until token expires
  Duration get remainingTime {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return Duration.zero;
    return expiresAt.difference(now);
  }

  /// Creates a copy with updated values
  AuthTokensEntity copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return AuthTokensEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, tokenType];
}

/// Combined authentication session entity
class AuthSessionEntity extends Equatable {
  /// The authenticated user
  final UserEntity user;
  
  /// Authentication tokens
  final AuthTokensEntity tokens;

  const AuthSessionEntity({
    required this.user,
    required this.tokens,
  });

  /// Checks if the session is valid (user exists and token not expired)
  bool get isValid => user.isNotEmpty && !tokens.isExpired;

  /// Checks if the session needs token refresh
  bool get needsRefresh => tokens.isAboutToExpire;

  @override
  List<Object?> get props => [user, tokens];
}