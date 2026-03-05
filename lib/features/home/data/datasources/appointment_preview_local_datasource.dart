/// AppointmentPreview Local Data Source
///
/// Handles local storage operations for appointment_preview data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/appointment_preview_model.dart';

/// Storage key for appointment_preview cache
const String _appointmentPreviewCacheKey = 'cached_appointment_previews';

/// Abstract interface for appointment_preview local data source
abstract class AppointmentPreviewLocalDataSource {
  /// Gets a cached appointment_preview by ID
  Future<AppointmentPreviewModel?> getAppointmentPreview(String id);

  /// Gets all cached appointment_previews
  Future<List<AppointmentPreviewModel>> getAllAppointmentPreviews();

  /// Caches a appointment_preview
  Future<void> cacheAppointmentPreview(AppointmentPreviewModel appointmentPreview);

  /// Caches all appointment_previews
  Future<void> cacheAllAppointmentPreviews(List<AppointmentPreviewModel> appointmentPreviews);

  /// Removes a cached appointment_preview
  Future<void> removeAppointmentPreview(String id);
  
  /// Clears all cached appointment_previews
  Future<void> clearCache();
}

/// Implementation of AppointmentPreviewLocalDataSource
class AppointmentPreviewLocalDataSourceImpl implements AppointmentPreviewLocalDataSource {
  final LocalStorage _storage;

  AppointmentPreviewLocalDataSourceImpl(this._storage);

  @override
  Future<AppointmentPreviewModel?> getAppointmentPreview(String id) async {
    try {
      final all = await getAllAppointmentPreviews();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get appointment_preview: $e');
    }
  }

  @override
  Future<List<AppointmentPreviewModel>> getAllAppointmentPreviews() async {
    try {
      final jsonString = await _storage.getString(_appointmentPreviewCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => AppointmentPreviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get appointment_previews: $e');
    }
  }

  @override
  Future<void> cacheAppointmentPreview(AppointmentPreviewModel appointmentPreview) async {
    try {
      final all = await getAllAppointmentPreviews();
      final index = all.indexWhere((item) => item.id == appointmentPreview.id);
      
      if (index >= 0) {
        all[index] = appointmentPreview;
      } else {
        all.add(appointmentPreview);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache appointment_preview: $e');
    }
  }

  @override
  Future<void> cacheAllAppointmentPreviews(List<AppointmentPreviewModel> appointmentPreviews) async {
    try {
      await _saveAll(appointmentPreviews);
    } catch (e) {
      throw StorageException(message: 'Failed to cache appointment_previews: $e');
    }
  }

  @override
  Future<void> removeAppointmentPreview(String id) async {
    try {
      final all = await getAllAppointmentPreviews();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove appointment_preview: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_appointmentPreviewCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<AppointmentPreviewModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_appointmentPreviewCacheKey, jsonEncode(jsonList));
  }
}
