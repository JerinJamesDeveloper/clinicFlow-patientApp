/// Doctor Local Data Source
///
/// Handles local storage operations for doctor data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/doctor_model.dart';

/// Storage key for doctor cache
const String _doctorCacheKey = 'cached_doctors';

/// Abstract interface for doctor local data source
abstract class DoctorLocalDataSource {
  /// Gets a cached doctor by ID
  Future<DoctorModel?> getDoctor(String id);

  /// Gets all cached doctors
  Future<List<DoctorModel>> getAllDoctors();

  /// Caches a doctor
  Future<void> cacheDoctor(DoctorModel doctor);

  /// Caches all doctors
  Future<void> cacheAllDoctors(List<DoctorModel> doctors);

  /// Removes a cached doctor
  Future<void> removeDoctor(String id);
  
  /// Clears all cached doctors
  Future<void> clearCache();
}

/// Implementation of DoctorLocalDataSource
class DoctorLocalDataSourceImpl implements DoctorLocalDataSource {
  final LocalStorage _storage;

  DoctorLocalDataSourceImpl(this._storage);

  @override
  Future<DoctorModel?> getDoctor(String id) async {
    try {
      final all = await getAllDoctors();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get doctor: $e');
    }
  }

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final jsonString = await _storage.getString(_doctorCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => DoctorModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get doctors: $e');
    }
  }

  @override
  Future<void> cacheDoctor(DoctorModel doctor) async {
    try {
      final all = await getAllDoctors();
      final index = all.indexWhere((item) => item.id == doctor.id);
      
      if (index >= 0) {
        all[index] = doctor;
      } else {
        all.add(doctor);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache doctor: $e');
    }
  }

  @override
  Future<void> cacheAllDoctors(List<DoctorModel> doctors) async {
    try {
      await _saveAll(doctors);
    } catch (e) {
      throw StorageException(message: 'Failed to cache doctors: $e');
    }
  }

  @override
  Future<void> removeDoctor(String id) async {
    try {
      final all = await getAllDoctors();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove doctor: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_doctorCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<DoctorModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_doctorCacheKey, jsonEncode(jsonList));
  }
}
