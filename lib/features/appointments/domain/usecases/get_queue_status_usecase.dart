/// GetQueueStatus Use Case
///
/// GetQueueStatus for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for GetQueueStatusUseCase
class GetQueueStatusParams extends Equatable {
  final String doctorId;

  const GetQueueStatusParams({
    required this.doctorId,
  });

  @override
  List<Object?> get props => [doctorId];
}

/// GetQueueStatus use case
class GetQueueStatusUseCase implements UseCase<AppointmentsEntity, GetQueueStatusParams> {
  final AppointmentsRepository _repository;

  GetQueueStatusUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(GetQueueStatusParams params) async {
    // Validation
    if (params.doctorId.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Doctor Id cannot be empty',
        fieldErrors: {'doctorId': ['Doctor Id is required']},
      ));
    }

    return await _repository.getQueueStatus(
      doctorId: params.doctorId.trim(),
    );
  }
}
