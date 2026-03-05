/// RescheduleAppointment Use Case
///
/// RescheduleAppointment for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for RescheduleAppointmentUseCase
class RescheduleAppointmentParams extends Equatable {
  final String appointmentId;

  const RescheduleAppointmentParams({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}

/// RescheduleAppointment use case
class RescheduleAppointmentUseCase implements UseCase<AppointmentsEntity, RescheduleAppointmentParams> {
  final AppointmentsRepository _repository;

  RescheduleAppointmentUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(RescheduleAppointmentParams params) async {
    // Validation
    if (params.appointmentId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Appointment Id cannot be empty',
        fieldErrors: {'appointmentId': ['Appointment Id is required']},
      ));
    }

    return await _repository.rescheduleAppointment(
      appointmentId: params.appointmentId.trim(),
    );
  }
}
