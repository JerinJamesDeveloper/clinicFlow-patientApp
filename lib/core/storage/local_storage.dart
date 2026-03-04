/// Local Storage Service
/// 
/// Abstraction layer for local data persistence using SharedPreferences.
/// Provides type-safe methods for storing and retrieving data.
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import '../errors/exceptions.dart';

/// Abstract interface for local storage operations
abstract class LocalStorage {
  // String operations
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  
  // Int operations
  Future<bool> setInt(String key, int value);
  Future<int?> getInt(String key);
  
  // Double operations
  Future<bool> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  
  // Bool operations
  Future<bool> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  
  // StringList operations
  Future<bool> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  
  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getJson(String key);
  
  // Generic operations
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
  Future<Set<String>> getKeys();
  
  // Cache operations with expiration
  Future<bool> setWithExpiry(String key, String value, Duration expiry);
  Future<String?> getWithExpiry(String key);
  Future<bool> isExpired(String key);
}

/// Implementation of LocalStorage using SharedPreferences
class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _preferences;

  LocalStorageImpl(this._preferences);

  // ============== STRING OPERATIONS ==============
  @override
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string: $e');
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _preferences.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string: $e');
    }
  }

  // ============== INT OPERATIONS ==============
  @override
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences.setInt(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save int: $e');
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get int: $e');
    }
  }

  // ============== DOUBLE OPERATIONS ==============
  @override
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences.setDouble(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save double: $e');
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      return _preferences.getDouble(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get double: $e');
    }
  }

  // ============== BOOL OPERATIONS ==============
  @override
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save bool: $e');
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return _preferences.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get bool: $e');
    }
  }

  // ============== STRING LIST OPERATIONS ==============
  @override
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences.setStringList(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string list: $e');
    }
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    try {
      return _preferences.getStringList(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string list: $e');
    }
  }

  // ============== JSON OPERATIONS ==============
  @override
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await _preferences.setString(key, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to save JSON: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final jsonString = _preferences.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(message: 'Failed to get JSON: $e');
    }
  }

  // ============== GENERIC OPERATIONS ==============
  @override
  Future<bool> remove(String key) async {
    try {
      // Also remove timestamp if exists
      await _preferences.remove(StorageKeys.cacheTimestampKey(key));
      return await _preferences.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: $e');
    }
  }

  @override
  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear storage: $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      return _preferences.containsKey(key);
    } catch (e) {
      throw CacheException(message: 'Failed to check key: $e');
    }
  }

  @override
  Future<Set<String>> getKeys() async {
    try {
      return _preferences.getKeys();
    } catch (e) {
      throw CacheException(message: 'Failed to get keys: $e');
    }
  }

  // ============== CACHE WITH EXPIRATION ==============
  @override
  Future<bool> setWithExpiry(String key, String value, Duration expiry) async {
    try {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await _preferences.setInt(StorageKeys.cacheTimestampKey(key), expiryTime);
      return await _preferences.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save with expiry: $e');
    }
  }

  @override
  Future<String?> getWithExpiry(String key) async {
    try {
      // Check if expired
      if (await isExpired(key)) {
        // Remove expired data
        await remove(key);
        return null;
      }
      return _preferences.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get with expiry: $e');
    }
  }

  @override
  Future<bool> isExpired(String key) async {
    try {
      final expiryTime = _preferences.getInt(StorageKeys.cacheTimestampKey(key));
      if (expiryTime == null) return true;
      return DateTime.now().millisecondsSinceEpoch > expiryTime;
    } catch (e) {
      return true;
    }
  }

  // ============== CONVENIENCE METHODS ==============
  /// Save user token with expiry
  Future<bool> saveToken(String token, {Duration? expiry}) async {
    if (expiry != null) {
      return setWithExpiry(StorageKeys.accessToken, token, expiry);
    }
    return setString(StorageKeys.accessToken, token);
  }

  /// Get user token
  Future<String?> getToken() async {
    return getString(StorageKeys.accessToken);
  }

  /// Clear all auth data
  Future<void> clearAuthData() async {
    await remove(StorageKeys.accessToken);
    await remove(StorageKeys.refreshToken);
    await remove(StorageKeys.tokenExpiry);
    await remove(StorageKeys.currentUser);
    await remove(StorageKeys.isLoggedIn);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final loggedIn = await getBool(StorageKeys.isLoggedIn);
    final token = await getString(StorageKeys.accessToken);
    return loggedIn == true && token != null && token.isNotEmpty;
  }
}