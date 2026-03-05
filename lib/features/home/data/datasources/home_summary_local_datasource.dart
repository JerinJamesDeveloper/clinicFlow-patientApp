/// HomeSummary Local Data Source
///
/// Handles local storage operations for home_summary data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/home_summary_model.dart';

/// Storage key for home_summary cache
const String _homeSummaryCacheKey = 'cached_home_summarys';

/// Abstract interface for home_summary local data source
abstract class HomeSummaryLocalDataSource {
  /// Gets a cached home_summary by ID
  Future<HomeSummaryModel?> getHomeSummary(String id);

  /// Gets all cached home_summarys
  Future<List<HomeSummaryModel>> getAllHomeSummarys();

  /// Caches a home_summary
  Future<void> cacheHomeSummary(HomeSummaryModel homeSummary);

  /// Caches all home_summarys
  Future<void> cacheAllHomeSummarys(List<HomeSummaryModel> homeSummarys);

  /// Removes a cached home_summary
  Future<void> removeHomeSummary(String id);
  
  /// Clears all cached home_summarys
  Future<void> clearCache();
}

/// Implementation of HomeSummaryLocalDataSource
class HomeSummaryLocalDataSourceImpl implements HomeSummaryLocalDataSource {
  final LocalStorage _storage;

  HomeSummaryLocalDataSourceImpl(this._storage);

  @override
  Future<HomeSummaryModel?> getHomeSummary(String id) async {
    try {
      final all = await getAllHomeSummarys();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get home_summary: $e');
    }
  }

  @override
  Future<List<HomeSummaryModel>> getAllHomeSummarys() async {
    try {
      final jsonString = await _storage.getString(_homeSummaryCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => HomeSummaryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get home_summarys: $e');
    }
  }

  @override
  Future<void> cacheHomeSummary(HomeSummaryModel homeSummary) async {
    try {
      final all = await getAllHomeSummarys();
      final index = all.indexWhere((item) => item.id == homeSummary.id);
      
      if (index >= 0) {
        all[index] = homeSummary;
      } else {
        all.add(homeSummary);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache home_summary: $e');
    }
  }

  @override
  Future<void> cacheAllHomeSummarys(List<HomeSummaryModel> homeSummarys) async {
    try {
      await _saveAll(homeSummarys);
    } catch (e) {
      throw StorageException(message: 'Failed to cache home_summarys: $e');
    }
  }

  @override
  Future<void> removeHomeSummary(String id) async {
    try {
      final all = await getAllHomeSummarys();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove home_summary: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_homeSummaryCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<HomeSummaryModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_homeSummaryCacheKey, jsonEncode(jsonList));
  }
}
