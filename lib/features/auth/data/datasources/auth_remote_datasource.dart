/// Auth Remote Data Source
///
/// Handles API calls for authentication operations.
/// Communicates with the backend authentication endpoints.
library;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

/// Abstract interface for auth remote data source
abstract class AuthRemoteDataSource {
  /// Authenticates user with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Registers a new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  /// Logs out the current user
  Future<void> logout();

  /// Gets the current user profile
  Future<UserModel> getCurrentUser();

  /// Refreshes the access token
  Future<AuthTokensModel> refreshToken(String refreshToken);

  /// Sends password reset email
  Future<MessageResponseModel> forgotPassword(String email);

  /// Resets password with token
  Future<MessageResponseModel> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Changes password for authenticated user
  Future<MessageResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Verifies email with token
  Future<MessageResponseModel> verifyEmail(String token);

  /// Resends verification email
  Future<MessageResponseModel> resendVerificationEmail();

  /// Verifies OTP — returns token + user on success
  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otp,
  });

  /// Resends OTP
  Future<MessageResponseModel> resendOtp(String email);

  /// Updates user profile
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Deletes user account
  Future<void> deleteAccount(String password);
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Login failed: $e');
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post(ApiEndpoints.logout);
    } on ServerException {
      // Ignore server errors during logout
      // We'll clear local data anyway
    } catch (e) {
      // Ignore errors during logout
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.authMe);

      final data = response.data as Map<String, dynamic>;

      // Handle wrapped response
      final userData =
          data['data'] as Map<String, dynamic>? ??
          data['user'] as Map<String, dynamic>? ??
          data;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get user: $e');
    }
  }

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final tokenData = data['tokens'] as Map<String, dynamic>? ?? data;

      return AuthTokensModel.fromJson(tokenData);
    } on UnauthorizedException {
      throw const SessionExpiredException();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Token refresh failed: $e');
    }
  }

  @override
  Future<MessageResponseModel> forgotPassword(String email) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );

      return MessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Forgot password request failed: $e');
    }
  }

  @override
  Future<MessageResponseModel> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.resetPassword,
        data: {'token': token, 'password': newPassword},
      );

      return MessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Password reset failed: $e');
    }
  }

  @override
  Future<MessageResponseModel> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      return MessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Password change failed: $e');
    }
  }

  @override
  Future<MessageResponseModel> verifyEmail(String token) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.verifyEmail,
        data: {'token': token},
      );

      return MessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Email verification failed: $e');
    }
  }

  @override
  Future<MessageResponseModel> resendVerificationEmail() async {
    try {
      final response = await _dioClient.post(ApiEndpoints.resendVerification);

      return MessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Resend verification failed: $e');
    }
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp},
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'OTP verification failed: $e');
    }
  }

  @override
  Future<MessageResponseModel> resendOtp(String email) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.resendOtp,
        data: {'email': email},
      );

      return MessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Resend OTP failed: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      final response = await _dioClient.put(
        ApiEndpoints.updateProfile,
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      final userData =
          responseData['data'] as Map<String, dynamic>? ??
          responseData['user'] as Map<String, dynamic>? ??
          responseData;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Profile update failed: $e');
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      await _dioClient.delete(
        ApiEndpoints.deleteAccount,
        data: {'password': password},
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Account deletion failed: $e');
    }
  }
}
