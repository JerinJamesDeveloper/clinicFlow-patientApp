/// HospitalBranch Local Data Source
///
/// Handles local storage operations for hospital_branch data.
/// Uses LocalStorage for caching.
library;

import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/hospital_branch_model.dart';

/// Storage key for hospital_branch cache
const String _hospitalBranchCacheKey = 'cached_hospital_branchs';

/// Abstract interface for hospital_branch local data source
abstract class HospitalBranchLocalDataSource {
  /// Gets a cached hospital_branch by ID
  Future<HospitalBranchModel?> getHospitalBranch(String id);

  /// Gets all cached hospital_branchs
  Future<List<HospitalBranchModel>> getAllHospitalBranchs();

  /// Caches a hospital_branch
  Future<void> cacheHospitalBranch(HospitalBranchModel hospitalBranch);

  /// Caches all hospital_branchs
  Future<void> cacheAllHospitalBranchs(List<HospitalBranchModel> hospitalBranchs);

  /// Removes a cached hospital_branch
  Future<void> removeHospitalBranch(String id);
  
  /// Clears all cached hospital_branchs
  Future<void> clearCache();
}

/// Implementation of HospitalBranchLocalDataSource
class HospitalBranchLocalDataSourceImpl implements HospitalBranchLocalDataSource {
  final LocalStorage _storage;

  HospitalBranchLocalDataSourceImpl(this._storage);

  @override
  Future<HospitalBranchModel?> getHospitalBranch(String id) async {
    try {
      final all = await getAllHospitalBranchs();
      return all.where((item) => item.id == id).firstOrNull;
    } catch (e) {
      throw StorageException(message: 'Failed to get hospital_branch: $e');
    }
  }

  @override
  Future<List<HospitalBranchModel>> getAllHospitalBranchs() async {
    try {
      final jsonString = await _storage.getString(_hospitalBranchCacheKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => HospitalBranchModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw StorageException(message: 'Failed to get hospital_branchs: $e');
    }
  }

  @override
  Future<void> cacheHospitalBranch(HospitalBranchModel hospitalBranch) async {
    try {
      final all = await getAllHospitalBranchs();
      final index = all.indexWhere((item) => item.id == hospitalBranch.id);
      
      if (index >= 0) {
        all[index] = hospitalBranch;
      } else {
        all.add(hospitalBranch);
      }

      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to cache hospital_branch: $e');
    }
  }

  @override
  Future<void> cacheAllHospitalBranchs(List<HospitalBranchModel> hospitalBranchs) async {
    try {
      await _saveAll(hospitalBranchs);
    } catch (e) {
      throw StorageException(message: 'Failed to cache hospital_branchs: $e');
    }
  }

  @override
  Future<void> removeHospitalBranch(String id) async {
    try {
      final all = await getAllHospitalBranchs();
      all.removeWhere((item) => item.id == id);
      await _saveAll(all);
    } catch (e) {
      throw StorageException(message: 'Failed to remove hospital_branch: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storage.remove(_hospitalBranchCacheKey);
    } catch (e) {
      throw StorageException(message: 'Failed to clear cache: $e');
    }
  }

  Future<void> _saveAll(List<HospitalBranchModel> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    await _storage.setString(_hospitalBranchCacheKey, jsonEncode(jsonList));
  }
}
