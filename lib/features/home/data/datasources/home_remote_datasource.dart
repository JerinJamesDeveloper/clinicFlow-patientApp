/// Home Remote Data Source
///
/// Handles API calls for home operations.
/// Communicates with the backend home endpoints.
library;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/home_model.dart';

/// Abstract interface for home remote data source
abstract class HomeRemoteDataSource {
  /// Gets a home by ID
  Future<HomeModel> getHome(String id);

  /// Gets all homes
  Future<List<HomeModel>> getAllHomes();

  /// Creates a new home
  Future<HomeModel> createHome({
    required String name,
    String? description,
  });

  /// Updates an existing home
  Future<HomeModel> updateHome({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  });

  /// Deletes a home
  Future<void> deleteHome(String id);

  /// GetHomeSummary
  Future<HomeModel> getHomeSummary(String id);


  /// GetHealthAlerts
  Future<List<HomeModel>> getHealthAlerts();


  /// GetUpcomingAppointments
  Future<List<HomeModel>> getUpcomingAppointments();

}

/// Implementation of HomeRemoteDataSource
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _dioClient;

  HomeRemoteDataSourceImpl(this._dioClient);

  @override
  Future<HomeModel> getHome(String id) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.gethomes}/$id',
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return HomeModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get home: $e');
    }
  }

  @override
  Future<List<HomeModel>> getAllHomes() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallhomes);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map((item) => HomeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get homes: $e');
    }
  }

  @override
  Future<HomeModel> createHome({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.createhomes,
        data: {
          'name': name,
          if (description != null) 'description': description,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return HomeModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to create home: $e');
    }
  }

  @override
  Future<HomeModel> updateHome({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (isActive != null) updateData['is_active'] = isActive;

      final response = await _dioClient.put(
        '${ApiEndpoints.updatehomes}/$id',
        data: updateData,
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return HomeModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to update home: $e');
    }
  }

  @override
  Future<void> deleteHome(String id) async {
    try {
      await _dioClient.delete('${ApiEndpoints.deletehomes}/$id');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to delete home: $e');
    }
  }

  @override
  Future<HomeModel> getHomeSummary(String id) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.gethomes}/$id',
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return HomeModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get home: $e');
    }
  }


  @override
  Future<List<HomeModel>> getHealthAlerts() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallhomes);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map((item) => HomeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get homes: $e');
    }
  }


  @override
  Future<List<HomeModel>> getUpcomingAppointments() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallhomes);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map((item) => HomeModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get homes: $e');
    }
  }

}
