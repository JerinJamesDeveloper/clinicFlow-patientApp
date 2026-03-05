/// Appointment Local Data Source
///
/// Handles local storage operations for appointment data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/appointment_model.dart';

/// Storage key for appointment cache
const String _appointmentCacheKey = 'cached_appointments';

/// Abstract interface for appointment local data source
abstract class AppointmentLocalDataSource {
  /// Gets a cached appointment by ID
  Future<AppointmentModel?> getAppointment(String id);

  /// Gets all cached appointments
  Future<List<AppointmentModel>> getAllAppointments();

  /// Caches a appointment
  Future<void> cacheAppointment(AppointmentModel appointment);

  /// Caches all appointments
  Future<void> cacheAllAppointments(List<AppointmentModel> appointments);

  /// Removes a cached appointment
  Future<void> removeAppointment(String id);
  
  /// Clears all cached appointments
  Future<void> clearCache();
}

/// Implementation of AppointmentLocalDataSource
class AppointmentLocalDataSourceImpl implements AppointmentLocalDataSource {
  final LocalStorage _storage;

  AppointmentLocalDataSourceImpl(this._storage);

  @override
  Future<AppointmentModel?> getAppointment(String id) async {
    try {
      final all = await getAllAppointments();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get appointment: $e');
    }
  }

  @override
  Future<List<AppointmentModel>> getAllAppointments() async {
    try {
      final jsonString = await _storage.getString(_appointmentCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => AppointmentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get appointments: $e');
    }
  }

  @override
  Future<void> cacheAppointment(AppointmentModel appointment) async {
    try {
      final all = await getAllAppointments();
      final index = all.indexWhere((item) => item.id == appointment.id);
      
      if (index >= 0) {
        all[index] = appointment;
      } else {
        all.add(appointment);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache appointment: $e');
    }
  }

  @override
  Future<void> cacheAllAppointments(List<AppointmentModel> appointments) async {
    try {
      await _saveAll(appointments);
    } catch (e) {
      throw StorageException(message: 'Failed to cache appointments: $e');
    }
  }

  @override
  Future<void> removeAppointment(String id) async {
    try {
      final all = await getAllAppointments();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove appointment: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_appointmentCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<AppointmentModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_appointmentCacheKey, jsonEncode(jsonList));
  }
}
