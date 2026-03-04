/// Auth Local Data Source
///
/// Handles local storage operations for authentication data.
/// Stores tokens, user data, and session information.
library;

import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';

/// Abstract interface for auth local data source
abstract class AuthLocalDataSource {
  /// Saves authentication tokens
  Future<void> saveTokens(AuthTokensModel tokens);

  /// Gets stored authentication tokens
  Future<AuthTokensModel?> getTokens();

  /// Saves user data
  Future<void> saveUser(UserModel user);

  /// Gets stored user data
  Future<UserModel?> getUser();

  /// Clears all auth data (logout)
  Future<void> clearAuthData();

  /// Checks if user is logged in
  Future<bool> isLoggedIn();

  /// Gets the access token
  Future<String?> getAccessToken();

  /// Gets the refresh token
  Future<String?> getRefreshToken();

  /// Updates only the access token (after refresh)
  Future<void> updateAccessToken(String accessToken, DateTime expiresAt);

  /// Saves remember me preference
  Future<void> setRememberMe(bool value);

  /// Gets remember me preference
  Future<bool> getRememberMe();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage _storage;

  AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    try {
      await _storage.setString(
        StorageKeys.accessToken,
        tokens.accessToken,
      );
      await _storage.setString(
        StorageKeys.refreshToken,
        tokens.refreshToken,
      );
      await _storage.setString(
        StorageKeys.tokenExpiry,
        tokens.expiresAt.toIso8601String(),
      );
      await _storage.setBool(StorageKeys.isLoggedIn, true);
    } catch (e) {
      throw StorageException(message: 'Failed to save tokens: $e');
    }
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    try {
      final accessToken =
          await _storage.getString(StorageKeys.accessToken);
      final refreshToken =
          await _storage.getString(StorageKeys.refreshToken);
      final expiryString =
          await _storage.getString(StorageKeys.tokenExpiry);

      if (accessToken == null || refreshToken == null) {
        return null;
      }

      final expiresAt = expiryString != null
          ? DateTime.tryParse(expiryString) ??
              DateTime.now().add(const Duration(hours: 1))
          : DateTime.now().add(const Duration(hours: 1));

      return AuthTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
    } catch (e) {
      throw StorageException(message: 'Failed to get tokens: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _storage.setString(
        StorageKeys.currentUser,
        userJson,
      );
      await _storage.setString(
        StorageKeys.userRole,
        user.role.value,
      );
    } catch (e) {
      throw StorageException(message: 'Failed to save user: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson =
          await _storage.getString(StorageKeys.currentUser);

      if (userJson == null) {
        return null;
      }

      final userMap =
          jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw StorageException(message: 'Failed to get user: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await _storage.remove(StorageKeys.accessToken);
      await _storage.remove(StorageKeys.refreshToken);
      await _storage.remove(StorageKeys.tokenExpiry);
      await _storage.remove(StorageKeys.currentUser);
      await _storage.remove(StorageKeys.userRole);
      await _storage.remove(StorageKeys.isLoggedIn);
    } catch (e) {
      throw StorageException(message: 'Failed to clear auth data: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final refreshToken =
          await _storage.getString(StorageKeys.refreshToken);

      return refreshToken != null && refreshToken.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.getString(StorageKeys.accessToken);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.getString(StorageKeys.refreshToken);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateAccessToken(
    String accessToken,
    DateTime expiresAt,
  ) async {
    try {
      await _storage.setString(
        StorageKeys.accessToken,
        accessToken,
      );
      await _storage.setString(
        StorageKeys.tokenExpiry,
        expiresAt.toIso8601String(),
      );
    } catch (e) {
      throw StorageException(
        message: 'Failed to update access token: $e',
      );
    }
  }

  @override
  Future<void> setRememberMe(bool value) async {
    try {
      await _storage.setBool(StorageKeys.rememberMe, value);
    } catch (e) {
      throw StorageException(
        message: 'Failed to save remember me: $e',
      );
    }
  }

  @override
  Future<bool> getRememberMe() async {
    try {
      return await _storage.getBool(StorageKeys.rememberMe) ?? false;
    } catch (_) {
      return false;
    }
  }
}
