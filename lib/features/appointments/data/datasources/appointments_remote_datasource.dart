/// Appointments Remote Data Source
///
/// Handles API calls for appointments operations.
/// Communicates with the backend appointments endpoints.
library;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/appointments_model.dart';

/// Abstract interface for appointments remote data source
abstract class AppointmentsRemoteDataSource {
  /// Gets a appointments by ID
  Future<AppointmentsModel> getAppointments(String id);

  /// Gets all appointmentss
  Future<List<AppointmentsModel>> getAllAppointmentss();

  /// Creates a new appointments
  Future<AppointmentsModel> createAppointments({
    required String name,
    String? description,
  });

  /// Updates an existing appointments
  Future<AppointmentsModel> updateAppointments({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  });

  /// Deletes a appointments
  Future<void> deleteAppointments(String id);

  /// GetDoctors
  Future<List<AppointmentsModel>> getDoctors();

  /// GetDoctorDetail
  Future<AppointmentsModel> getDoctorDetail({required String doctorId});

  /// GetDepartments
  Future<List<AppointmentsModel>> getDepartments();

  /// GetHospitalBranches
  Future<List<AppointmentsModel>> getHospitalBranches();

  /// GetDoctorSchedule
  Future<List<AppointmentsModel>> getDoctorSchedule({required String doctorId});

  /// GetQueueStatus
  Future<AppointmentsModel> getQueueStatus({required String doctorId});

  /// GetUpcomingAppointments
  Future<List<AppointmentsModel>> getUpcomingAppointments();

  /// GetPastAppointments
  Future<List<AppointmentsModel>> getPastAppointments();

  /// GetAppointmentDetail
  Future<AppointmentsModel> getAppointmentDetail({
    required String appointmentId,
  });

  /// CreateAppointment
  Future<AppointmentsModel> createAppointment({
    required String name,
    String? description,
  });

  /// CancelAppointment
  Future<AppointmentsModel> cancelAppointment({required String appointmentId});

  /// RescheduleAppointment
  Future<AppointmentsModel> rescheduleAppointment({
    required String appointmentId,
  });
}

/// Implementation of AppointmentsRemoteDataSource
class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  final DioClient _dioClient;

  AppointmentsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AppointmentsModel> getAppointments(String id) async {
    try {
      final response = await _dioClient.get(
        '${ApiEndpoints.getappointmentss}/$id',
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointments: $e');
    }
  }

  @override
  Future<List<AppointmentsModel>> getAllAppointmentss() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallappointmentss);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<AppointmentsModel> createAppointments({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.createappointmentss,
        data: {
          'name': name,
          if (description != null) 'description': description,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to create appointments: $e');
    }
  }

  @override
  Future<AppointmentsModel> updateAppointments({
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
        '${ApiEndpoints.updateappointmentss}/$id',
        data: updateData,
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to update appointments: $e');
    }
  }

  @override
  Future<void> deleteAppointments(String id) async {
    try {
      await _dioClient.delete('${ApiEndpoints.deleteappointmentss}/$id');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to delete appointments: $e');
    }
  }

  @override
  Future<List<AppointmentsModel>> getDoctors() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallappointmentss);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<AppointmentsModel> getDoctorDetail({required String doctorId}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.appointmentss,
        data: {'doctor_id': doctorId},
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to getDoctorDetail appointments: $e',
      );
    }
  }

  @override
  Future<List<AppointmentsModel>> getDepartments() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallappointmentss);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<List<AppointmentsModel>> getHospitalBranches() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallappointmentss);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<List<AppointmentsModel>> getDoctorSchedule({
    required String doctorId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.appointmentss,
        data: {'doctor_id': doctorId},
      );

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];
      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to getDoctorSchedule appointments: $e',
      );
    }
  }

  @override
  Future<AppointmentsModel> getQueueStatus({required String doctorId}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.appointmentss,
        data: {'doctor_id': doctorId},
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to getQueueStatus appointments: $e',
      );
    }
  }

  @override
  Future<List<AppointmentsModel>> getUpcomingAppointments() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallappointmentss);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<List<AppointmentsModel>> getPastAppointments() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.getallappointmentss);

      final data = response.data as Map<String, dynamic>;
      final listData = data['data'] as List? ?? [];

      return listData
          .map(
            (item) => AppointmentsModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get appointmentss: $e');
    }
  }

  @override
  Future<AppointmentsModel> getAppointmentDetail({
    required String appointmentId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.appointmentss,
        data: {'appointment_id': appointmentId},
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to getAppointmentDetail appointments: $e',
      );
    }
  }

  @override
  Future<AppointmentsModel> createAppointment({
    required String name,
    String? description,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.createappointmentss,
        data: {
          'name': name,
          if (description != null) 'description': description,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to create appointments: $e');
    }
  }

  @override
  Future<AppointmentsModel> cancelAppointment({
    required String appointmentId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.appointmentss,
        data: {'appointment_id': appointmentId},
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to cancelAppointment appointments: $e',
      );
    }
  }

  @override
  Future<AppointmentsModel> rescheduleAppointment({
    required String appointmentId,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.appointmentss,
        data: {'appointment_id': appointmentId},
      );

      final data = response.data as Map<String, dynamic>;
      final itemData = data['data'] as Map<String, dynamic>? ?? data;

      return AppointmentsModel.fromJson(itemData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to rescheduleAppointment appointments: $e',
      );
    }
  }
}
