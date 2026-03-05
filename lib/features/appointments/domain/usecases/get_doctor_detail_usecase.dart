/// GetDoctorDetail Use Case
///
/// GetDoctorDetail for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for GetDoctorDetailUseCase
class GetDoctorDetailParams extends Equatable {
  final String doctorId;

  const GetDoctorDetailParams({
    required this.doctorId,
  });

  @override
  List<Object?> get props => [doctorId];
}

/// GetDoctorDetail use case
class GetDoctorDetailUseCase implements UseCase<AppointmentsEntity, GetDoctorDetailParams> {
  final AppointmentsRepository _repository;

  GetDoctorDetailUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(GetDoctorDetailParams params) async {
    // Validation
    if (params.doctorId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Doctor Id cannot be empty',
        fieldErrors: {'doctorId': ['Doctor Id is required']},
      ));
    }

    return await _repository.getDoctorDetail(
      doctorId: params.doctorId.trim(),
    );
  }
}
