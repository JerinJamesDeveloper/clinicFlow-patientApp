/// Appointments Local Data Source
///
/// Handles local storage operations for appointments data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/appointments_model.dart';

/// Storage key for appointments cache
const String _appointmentsCacheKey = 'cached_appointmentss';

/// Abstract interface for appointments local data source
abstract class AppointmentsLocalDataSource {
  /// Gets a cached appointments by ID
  Future<AppointmentsModel?> getAppointments(String id);

  /// Gets all cached appointmentss
  Future<List<AppointmentsModel>> getAllAppointmentss();

  /// Caches a appointments
  Future<void> cacheAppointments(AppointmentsModel appointments);

  /// Caches all appointmentss
  Future<void> cacheAllAppointmentss(List<AppointmentsModel> appointmentss);

  /// Removes a cached appointments
  Future<void> removeAppointments(String id);
  
  /// Clears all cached appointmentss
  Future<void> clearCache();
}

/// Implementation of AppointmentsLocalDataSource
class AppointmentsLocalDataSourceImpl implements AppointmentsLocalDataSource {
  final LocalStorage _storage;

  AppointmentsLocalDataSourceImpl(this._storage);

  @override
  Future<AppointmentsModel?> getAppointments(String id) async {
    try {
      final all = await getAllAppointmentss();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get appointments: $e');
    }
  }

  @override
  Future<List<AppointmentsModel>> getAllAppointmentss() async {
    try {
      final jsonString = await _storage.getString(_appointmentsCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => AppointmentsModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<void> cacheAppointments(AppointmentsModel appointments) async {
    try {
      final all = await getAllAppointmentss();
      final index = all.indexWhere((item) => item.id == appointments.id);
      
      if (index >= 0) {
        all[index] = appointments;
      } else {
        all.add(appointments);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache appointments: $e');
    }
  }

  @override
  Future<void> cacheAllAppointmentss(List<AppointmentsModel> appointmentss) async {
    try {
      await _saveAll(appointmentss);
    } catch (e) {
      throw StorageException(message: 'Failed to cache appointmentss: $e');
    }
  }

  @override
  Future<void> removeAppointments(String id) async {
    try {
      final all = await getAllAppointmentss();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove appointments: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_appointmentsCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<AppointmentsModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_appointmentsCacheKey, jsonEncode(jsonList));
  }
}
