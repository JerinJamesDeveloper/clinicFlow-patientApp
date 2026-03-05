/// Appointments Repository Interface
///
/// Abstract repository defining the contract for appointments operations.
/// This interface is implemented by the data layer.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/appointments_entity.dart';

/// Abstract repository interface for appointments operations
abstract class AppointmentsRepository {
  /// Gets a appointments by ID
  ///
  /// Returns [AppointmentsEntity] on success or [Failure] on error.
  Future<Either<Failure, AppointmentsEntity>> getAppointments(String id);

  /// Gets all appointmentss
  ///
  /// Returns [List<AppointmentsEntity>] on success or [Failure] on error.
  Future<Either<Failure, List<AppointmentsEntity>>> getAllAppointmentss();

  /// Creates a new appointments
  ///
  /// Returns created [AppointmentsEntity] on success or [Failure] on error.
  Future<Either<Failure, AppointmentsEntity>> createAppointments({
    required String name,
    String? description,
  });

  /// Updates an existing appointments
  ///
  /// Returns updated [AppointmentsEntity] on success or [Failure] on error.
  Future<Either<Failure, AppointmentsEntity>> updateAppointments({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  });

  /// Deletes a appointments
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> deleteAppointments(String id);

  /// GetDoctors
  Future<Either<Failure, List<AppointmentsEntity>>> getDoctors();


  /// GetDoctorDetail
  Future<Either<Failure, AppointmentsEntity>> getDoctorDetail({
    required String doctorId,
  });


  /// GetDepartments
  Future<Either<Failure, List<AppointmentsEntity>>> getDepartments();


  /// GetHospitalBranches
  Future<Either<Failure, List<AppointmentsEntity>>> getHospitalBranches();


  /// GetDoctorSchedule
  Future<Either<Failure, List<AppointmentsEntity>>> getDoctorSchedule({
    required String doctorId,
  });


  /// GetQueueStatus
  Future<Either<Failure, AppointmentsEntity>> getQueueStatus({
    required String doctorId,
  });


  /// GetUpcomingAppointments
  Future<Either<Failure, List<AppointmentsEntity>>> getUpcomingAppointments();


  /// GetPastAppointments
  Future<Either<Failure, List<AppointmentsEntity>>> getPastAppointments();


  /// GetAppointmentDetail
  Future<Either<Failure, AppointmentsEntity>> getAppointmentDetail({
    required String appointmentId,
  });


  /// CreateAppointment
  Future<Either<Failure, AppointmentsEntity>> createAppointment({
    required String name,
    String? description,
  });


  /// CancelAppointment
  Future<Either<Failure, Unit>> cancelAppointment({
    required String appointmentId,
  });


  /// RescheduleAppointment
  Future<Either<Failure, AppointmentsEntity>> rescheduleAppointment({
    required String appointmentId,
  });

}
