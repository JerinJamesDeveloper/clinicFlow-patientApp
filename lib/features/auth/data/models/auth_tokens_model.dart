/// Auth Tokens Model
/// 
/// Data model for authentication tokens.
/// Handles JWT token storage and expiry management.
library;

import '../../domain/entities/user_entity.dart';

/// Auth tokens data model with JSON serialization
class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
    super.tokenType = 'Bearer',
  });

  /// Creates AuthTokensModel from JSON map
  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token'] as String? ?? 
                   json['accessToken'] as String? ??
                   json['token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? 
                    json['refreshToken'] as String? ?? '',
      expiresAt: _parseExpiresAt(json),
      tokenType: json['token_type'] as String? ?? 
                 json['tokenType'] as String? ?? 'Bearer',
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }

  /// Creates AuthTokensModel from entity
  factory AuthTokensModel.fromEntity(AuthTokensEntity entity) {
    return AuthTokensModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
      tokenType: entity.tokenType,
    );
  }

  /// Converts to entity
  AuthTokensEntity toEntity() {
    return AuthTokensEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      tokenType: tokenType,
    );
  }

  /// Creates a copy with updated fields
  @override
  AuthTokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? tokenType,
  }) {
    return AuthTokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  /// Parse expires_at from various formats
  static DateTime _parseExpiresAt(Map<String, dynamic> json) {
    // Try expires_at field
    final expiresAt = json['expires_at'] ?? json['expiresAt'];
    if (expiresAt != null) {
      if (expiresAt is DateTime) return expiresAt;
      if (expiresAt is String) {
        final parsed = DateTime.tryParse(expiresAt);
        if (parsed != null) return parsed;
      }
      if (expiresAt is int) {
        return DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
      }
    }

    // Try expires_in (seconds from now)
    final expiresIn = json['expires_in'] ?? json['expiresIn'];
    if (expiresIn != null && expiresIn is int) {
      return DateTime.now().add(Duration(seconds: expiresIn));
    }

    // Default: 1 hour from now
    return DateTime.now().add(const Duration(hours: 1));
  }
}