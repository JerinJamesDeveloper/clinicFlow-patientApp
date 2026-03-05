/// Home Local Data Source
///
/// Handles local storage operations for home data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/home_model.dart';

/// Storage key for home cache
const String _homeCacheKey = 'cached_homes';

/// Abstract interface for home local data source
abstract class HomeLocalDataSource {
  /// Gets a cached home by ID
  Future<HomeModel?> getHome(String id);

  /// Gets all cached homes
  Future<List<HomeModel>> getAllHomes();

  /// Caches a home
  Future<void> cacheHome(HomeModel home);

  /// Caches all homes
  Future<void> cacheAllHomes(List<HomeModel> homes);

  /// Removes a cached home
  Future<void> removeHome(String id);
  
  /// Clears all cached homes
  Future<void> clearCache();
}

/// Implementation of HomeLocalDataSource
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final LocalStorage _storage;

  HomeLocalDataSourceImpl(this._storage);

  @override
  Future<HomeModel?> getHome(String id) async {
    try {
      final all = await getAllHomes();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get home: $e');
    }
  }

  @override
  Future<List<HomeModel>> getAllHomes() async {
    try {
      final jsonString = await _storage.getString(_homeCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => HomeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get homes: $e');
    }
  }

  @override
  Future<void> cacheHome(HomeModel home) async {
    try {
      final all = await getAllHomes();
      final index = all.indexWhere((item) => item.id == home.id);
      
      if (index >= 0) {
        all[index] = home;
      } else {
        all.add(home);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache home: $e');
    }
  }

  @override
  Future<void> cacheAllHomes(List<HomeModel> homes) async {
    try {
      await _saveAll(homes);
    } catch (e) {
      throw StorageException(message: 'Failed to cache homes: $e');
    }
  }

  @override
  Future<void> removeHome(String id) async {
    try {
      final all = await getAllHomes();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove home: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_homeCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<HomeModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_homeCacheKey, jsonEncode(jsonList));
  }
}
