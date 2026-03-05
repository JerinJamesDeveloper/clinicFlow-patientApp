/// DoctorSchedule Local Data Source
///
/// Handles local storage operations for doctor_schedule data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/doctor_schedule_model.dart';

/// Storage key for doctor_schedule cache
const String _doctorScheduleCacheKey = 'cached_doctor_schedules';

/// Abstract interface for doctor_schedule local data source
abstract class DoctorScheduleLocalDataSource {
  /// Gets a cached doctor_schedule by ID
  Future<DoctorScheduleModel?> getDoctorSchedule(String id);

  /// Gets all cached doctor_schedules
  Future<List<DoctorScheduleModel>> getAllDoctorSchedules();

  /// Caches a doctor_schedule
  Future<void> cacheDoctorSchedule(DoctorScheduleModel doctorSchedule);

  /// Caches all doctor_schedules
  Future<void> cacheAllDoctorSchedules(List<DoctorScheduleModel> doctorSchedules);

  /// Removes a cached doctor_schedule
  Future<void> removeDoctorSchedule(String id);
  
  /// Clears all cached doctor_schedules
  Future<void> clearCache();
}

/// Implementation of DoctorScheduleLocalDataSource
class DoctorScheduleLocalDataSourceImpl implements DoctorScheduleLocalDataSource {
  final LocalStorage _storage;

  DoctorScheduleLocalDataSourceImpl(this._storage);

  @override
  Future<DoctorScheduleModel?> getDoctorSchedule(String id) async {
    try {
      final all = await getAllDoctorSchedules();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get doctor_schedule: $e');
    }
  }

  @override
  Future<List<DoctorScheduleModel>> getAllDoctorSchedules() async {
    try {
      final jsonString = await _storage.getString(_doctorScheduleCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => DoctorScheduleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get doctor_schedules: $e');
    }
  }

  @override
  Future<void> cacheDoctorSchedule(DoctorScheduleModel doctorSchedule) async {
    try {
      final all = await getAllDoctorSchedules();
      final index = all.indexWhere((item) => item.id == doctorSchedule.id);
      
      if (index >= 0) {
        all[index] = doctorSchedule;
      } else {
        all.add(doctorSchedule);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache doctor_schedule: $e');
    }
  }

  @override
  Future<void> cacheAllDoctorSchedules(List<DoctorScheduleModel> doctorSchedules) async {
    try {
      await _saveAll(doctorSchedules);
    } catch (e) {
      throw StorageException(message: 'Failed to cache doctor_schedules: $e');
    }
  }

  @override
  Future<void> removeDoctorSchedule(String id) async {
    try {
      final all = await getAllDoctorSchedules();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove doctor_schedule: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_doctorScheduleCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<DoctorScheduleModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_doctorScheduleCacheKey, jsonEncode(jsonList));
  }
}
