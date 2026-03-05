/// Get Appointments Use Case
///
/// Retrieves a appointments by ID.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for GetAppointmentsUseCase
class GetAppointmentsParams extends Equatable {
  final String id;

  const GetAppointmentsParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Get appointments use case
class GetAppointmentsUseCase implements UseCase<AppointmentsEntity, GetAppointmentsParams> {
  final AppointmentsRepository _repository;

  GetAppointmentsUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(GetAppointmentsParams params) async {
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID cannot be empty',
        fieldErrors: {'id': ['ID is required']},
      ));
    }

    return await _repository.getAppointments(params.id);
  }
}
