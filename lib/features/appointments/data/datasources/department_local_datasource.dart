/// Department Local Data Source
///
/// Handles local storage operations for department data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/department_model.dart';

/// Storage key for department cache
const String _departmentCacheKey = 'cached_departments';

/// Abstract interface for department local data source
abstract class DepartmentLocalDataSource {
  /// Gets a cached department by ID
  Future<DepartmentModel?> getDepartment(String id);

  /// Gets all cached departments
  Future<List<DepartmentModel>> getAllDepartments();

  /// Caches a department
  Future<void> cacheDepartment(DepartmentModel department);

  /// Caches all departments
  Future<void> cacheAllDepartments(List<DepartmentModel> departments);

  /// Removes a cached department
  Future<void> removeDepartment(String id);
  
  /// Clears all cached departments
  Future<void> clearCache();
}

/// Implementation of DepartmentLocalDataSource
class DepartmentLocalDataSourceImpl implements DepartmentLocalDataSource {
  final LocalStorage _storage;

  DepartmentLocalDataSourceImpl(this._storage);

  @override
  Future<DepartmentModel?> getDepartment(String id) async {
    try {
      final all = await getAllDepartments();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get department: $e');
    }
  }

  @override
  Future<List<DepartmentModel>> getAllDepartments() async {
    try {
      final jsonString = await _storage.getString(_departmentCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => DepartmentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get departments: $e');
    }
  }

  @override
  Future<void> cacheDepartment(DepartmentModel department) async {
    try {
      final all = await getAllDepartments();
      final index = all.indexWhere((item) => item.id == department.id);
      
      if (index >= 0) {
        all[index] = department;
      } else {
        all.add(department);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache department: $e');
    }
  }

  @override
  Future<void> cacheAllDepartments(List<DepartmentModel> departments) async {
    try {
      await _saveAll(departments);
    } catch (e) {
      throw StorageException(message: 'Failed to cache departments: $e');
    }
  }

  @override
  Future<void> removeDepartment(String id) async {
    try {
      final all = await getAllDepartments();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove department: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_departmentCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<DepartmentModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_departmentCacheKey, jsonEncode(jsonList));
  }
}
