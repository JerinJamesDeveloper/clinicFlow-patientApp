/// GetAppointmentDetail Use Case
///
/// GetAppointmentDetail for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for GetAppointmentDetailUseCase
class GetAppointmentDetailParams extends Equatable {
  final String appointmentId;

  const GetAppointmentDetailParams({
    required this.appointmentId,
  });

  @override
  List<Object?> get props => [appointmentId];
}

/// GetAppointmentDetail use case
class GetAppointmentDetailUseCase implements UseCase<AppointmentsEntity, GetAppointmentDetailParams> {
  final AppointmentsRepository _repository;

  GetAppointmentDetailUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(GetAppointmentDetailParams params) async {
    // Validation
    if (params.appointmentId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Appointment Id cannot be empty',
        fieldErrors: {'appointmentId': ['Appointment Id is required']},
      ));
    }

    return await _repository.getAppointmentDetail(
      appointmentId: params.appointmentId.trim(),
    );
  }
}
