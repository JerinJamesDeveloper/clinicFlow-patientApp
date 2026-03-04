/// Auth Response Model
/// 
/// Data model for authentication API responses.
/// Combines user data and tokens from login/register responses.
library;

import '../../domain/entities/user_entity.dart';
import 'auth_tokens_model.dart';
import 'user_model.dart';

/// Auth response model containing user and tokens
class AuthResponseModel {
  /// Authenticated user data
  final UserModel user;
  
  /// Authentication tokens
  final AuthTokensModel tokens;

  const AuthResponseModel({
    required this.user,
    required this.tokens,
  });

  /// Creates AuthResponseModel from JSON map
  /// 
  /// Handles various API response formats:
  /// Format 1: { user: {...}, tokens: {...} }
  /// Format 2: { user: {...}, access_token: "...", refresh_token: "..." }
  /// Format 3: { data: { user: {...}, tokens: {...} } }
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle wrapped response
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    // Parse user
    final userJson = data['user'] as Map<String, dynamic>?;
    final user = userJson != null 
        ? UserModel.fromJson(userJson)
        : UserModel.empty();

    // Parse tokens - could be nested or flat
    AuthTokensModel tokens;
    final tokensJson = data['tokens'] as Map<String, dynamic>?;
    
    if (tokensJson != null) {
      tokens = AuthTokensModel.fromJson(tokensJson);
    } else {
      // Tokens might be at the root level
      tokens = AuthTokensModel.fromJson(data);
    }

    return AuthResponseModel(
      user: user,
      tokens: tokens,
    );
  }

  /// Converts to JSON map
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
    };
  }

  /// Converts to domain entity
  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      user: user.toEntity(),
      tokens: tokens.toEntity(),
    );
  }

  /// Creates from domain entity
  factory AuthResponseModel.fromEntity(AuthSessionEntity entity) {
    return AuthResponseModel(
      user: UserModel.fromEntity(entity.user),
      tokens: AuthTokensModel.fromEntity(entity.tokens),
    );
  }
}

/// Simple message response model
class MessageResponseModel {
  /// Response message
  final String message;
  
  /// Success status
  final bool success;

  const MessageResponseModel({
    required this.message,
    this.success = true,
  });

  /// Creates from JSON
  factory MessageResponseModel.fromJson(Map<String, dynamic> json) {
    return MessageResponseModel(
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? true,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
    };
  }
}