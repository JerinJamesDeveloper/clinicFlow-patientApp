/// QueueStatus Local Data Source
///
/// Handles local storage operations for queue_status data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/queue_status_model.dart';

/// Storage key for queue_status cache
const String _queueStatusCacheKey = 'cached_queue_statuss';

/// Abstract interface for queue_status local data source
abstract class QueueStatusLocalDataSource {
  /// Gets a cached queue_status by ID
  Future<QueueStatusModel?> getQueueStatus(String id);

  /// Gets all cached queue_statuss
  Future<List<QueueStatusModel>> getAllQueueStatuss();

  /// Caches a queue_status
  Future<void> cacheQueueStatus(QueueStatusModel queueStatus);

  /// Caches all queue_statuss
  Future<void> cacheAllQueueStatuss(List<QueueStatusModel> queueStatuss);

  /// Removes a cached queue_status
  Future<void> removeQueueStatus(String id);
  
  /// Clears all cached queue_statuss
  Future<void> clearCache();
}

/// Implementation of QueueStatusLocalDataSource
class QueueStatusLocalDataSourceImpl implements QueueStatusLocalDataSource {
  final LocalStorage _storage;

  QueueStatusLocalDataSourceImpl(this._storage);

  @override
  Future<QueueStatusModel?> getQueueStatus(String id) async {
    try {
      final all = await getAllQueueStatuss();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get queue_status: $e');
    }
  }

  @override
  Future<List<QueueStatusModel>> getAllQueueStatuss() async {
    try {
      final jsonString = await _storage.getString(_queueStatusCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => QueueStatusModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get queue_statuss: $e');
    }
  }

  @override
  Future<void> cacheQueueStatus(QueueStatusModel queueStatus) async {
    try {
      final all = await getAllQueueStatuss();
      final index = all.indexWhere((item) => item.id == queueStatus.id);
      
      if (index >= 0) {
        all[index] = queueStatus;
      } else {
        all.add(queueStatus);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache queue_status: $e');
    }
  }

  @override
  Future<void> cacheAllQueueStatuss(List<QueueStatusModel> queueStatuss) async {
    try {
      await _saveAll(queueStatuss);
    } catch (e) {
      throw StorageException(message: 'Failed to cache queue_statuss: $e');
    }
  }

  @override
  Future<void> removeQueueStatus(String id) async {
    try {
      final all = await getAllQueueStatuss();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove queue_status: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_queueStatusCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<QueueStatusModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_queueStatusCacheKey, jsonEncode(jsonList));
  }
}
