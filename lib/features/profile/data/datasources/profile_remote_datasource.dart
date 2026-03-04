/// Profile Remote Data Source
/// 
/// Handles API calls for profile operations.
library;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/models/user_model.dart';

/// Abstract interface for profile remote data source
abstract class ProfileRemoteDataSource {
  /// Gets the current user's profile
  Future<UserModel> getProfile();

  /// Updates the user's profile
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  });

  /// Updates the user's avatar
  Future<UserModel> updateAvatar(String imagePath);

  /// Removes the user's avatar
  Future<UserModel> removeAvatar();

  /// Deletes the user's account
  Future<void> deleteAccount(String password);
}

/// Implementation of ProfileRemoteDataSource
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.userMe);
      
      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>? ?? 
                       data['user'] as Map<String, dynamic>? ?? 
                       data;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get profile: $e');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      final data = <String, dynamic>{};
      
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;

      final response = await _dioClient.put(
        ApiEndpoints.updateProfile,
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      final userData = responseData['data'] as Map<String, dynamic>? ?? 
                       responseData['user'] as Map<String, dynamic>? ?? 
                       responseData;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to update profile: $e');
    }
  }

  @override
  Future<UserModel> updateAvatar(String imagePath) async {
    try {
      final response = await _dioClient.uploadFile(
        ApiEndpoints.uploadAvatar,
        filePath: imagePath,
        fileKey: 'avatar',
      );

      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>? ?? 
                       data['user'] as Map<String, dynamic>? ?? 
                       data;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to update avatar: $e');
    }
  }

  @override
  Future<UserModel> removeAvatar() async {
    try {
      final response = await _dioClient.delete(ApiEndpoints.uploadAvatar);

      final data = response.data as Map<String, dynamic>;
      final userData = data['data'] as Map<String, dynamic>? ?? 
                       data['user'] as Map<String, dynamic>? ?? 
                       data;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to remove avatar: $e');
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
      throw ServerException(message: 'Failed to delete account: $e');
    }
  }
}
