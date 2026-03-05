/// Delete Appointments Use Case
///
/// Deletes a appointments by ID.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for DeleteAppointmentsUseCase
class DeleteAppointmentsParams extends Equatable {
  final String id;

  const DeleteAppointmentsParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Delete appointments use case
class DeleteAppointmentsUseCase implements UseCase<Unit, DeleteAppointmentsParams> {
  final AppointmentsRepository _repository;

  DeleteAppointmentsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteAppointmentsParams params) async {
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID cannot be empty',
        fieldErrors: {'id': ['ID is required']},
      ));
    }

    return await _repository.deleteAppointments(params.id);
  }
}
