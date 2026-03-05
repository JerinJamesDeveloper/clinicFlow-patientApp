/// GetDoctorSchedule Use Case
///
/// GetDoctorSchedule for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for GetDoctorScheduleUseCase
class GetDoctorScheduleParams extends Equatable {
  final String doctorId;

  const GetDoctorScheduleParams({
    required this.doctorId,
  });

  @override
  List<Object?> get props => [doctorId];
}

/// GetDoctorSchedule use case
class GetDoctorScheduleUseCase implements UseCase<List<AppointmentsEntity>, GetDoctorScheduleParams> {
  final AppointmentsRepository _repository;

  GetDoctorScheduleUseCase(this._repository);

  @override
  Future<Either<Failure, List<AppointmentsEntity>>> call(GetDoctorScheduleParams params) async {
    // Validation
    if (params.doctorId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Doctor Id cannot be empty',
        fieldErrors: {'doctorId': ['Doctor Id is required']},
      ));
    }

    return await _repository.getDoctorSchedule(
      doctorId: params.doctorId.trim(),
    );
  }
}
