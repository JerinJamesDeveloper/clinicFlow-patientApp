/// HealthAlert Local Data Source
///
/// Handles local storage operations for health_alert data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/health_alert_model.dart';

/// Storage key for health_alert cache
const String _healthAlertCacheKey = 'cached_health_alerts';

/// Abstract interface for health_alert local data source
abstract class HealthAlertLocalDataSource {
  /// Gets a cached health_alert by ID
  Future<HealthAlertModel?> getHealthAlert(String id);

  /// Gets all cached health_alerts
  Future<List<HealthAlertModel>> getAllHealthAlerts();

  /// Caches a health_alert
  Future<void> cacheHealthAlert(HealthAlertModel healthAlert);

  /// Caches all health_alerts
  Future<void> cacheAllHealthAlerts(List<HealthAlertModel> healthAlerts);

  /// Removes a cached health_alert
  Future<void> removeHealthAlert(String id);
  
  /// Clears all cached health_alerts
  Future<void> clearCache();
}

/// Implementation of HealthAlertLocalDataSource
class HealthAlertLocalDataSourceImpl implements HealthAlertLocalDataSource {
  final LocalStorage _storage;

  HealthAlertLocalDataSourceImpl(this._storage);

  @override
  Future<HealthAlertModel?> getHealthAlert(String id) async {
    try {
      final all = await getAllHealthAlerts();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get health_alert: $e');
    }
  }

  @override
  Future<List<HealthAlertModel>> getAllHealthAlerts() async {
    try {
      final jsonString = await _storage.getString(_healthAlertCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => HealthAlertModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get health_alerts: $e');
    }
  }

  @override
  Future<void> cacheHealthAlert(HealthAlertModel healthAlert) async {
    try {
      final all = await getAllHealthAlerts();
      final index = all.indexWhere((item) => item.id == healthAlert.id);
      
      if (index >= 0) {
        all[index] = healthAlert;
      } else {
        all.add(healthAlert);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache health_alert: $e');
    }
  }

  @override
  Future<void> cacheAllHealthAlerts(List<HealthAlertModel> healthAlerts) async {
    try {
      await _saveAll(healthAlerts);
    } catch (e) {
      throw StorageException(message: 'Failed to cache health_alerts: $e');
    }
  }

  @override
  Future<void> removeHealthAlert(String id) async {
    try {
      final all = await getAllHealthAlerts();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove health_alert: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_healthAlertCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<HealthAlertModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_healthAlertCacheKey, jsonEncode(jsonList));
  }
}
