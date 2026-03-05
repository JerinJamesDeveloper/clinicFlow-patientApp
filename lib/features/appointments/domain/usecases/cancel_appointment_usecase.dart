/// CancelAppointment Use Case
///
/// CancelAppointment for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for CancelAppointmentUseCase
class CancelAppointmentParams extends Equatable {
  final String appointmentId;

  const CancelAppointmentParams({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}

/// CancelAppointment use case
class CancelAppointmentUseCase implements UseCase<Unit, CancelAppointmentParams> {
  final AppointmentsRepository _repository;

  CancelAppointmentUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(CancelAppointmentParams params) async {
    // Validation
    if (params.appointmentId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Appointment Id cannot be empty',
        fieldErrors: {'appointmentId': ['Appointment Id is required']},
      ));
    }

    return await _repository.cancelAppointment(
      appointmentId: params.appointmentId.trim(),
    );
  }
}
