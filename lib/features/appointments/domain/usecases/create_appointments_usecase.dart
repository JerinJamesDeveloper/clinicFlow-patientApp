/// Create Appointments Use Case
///
/// Creates a new appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for CreateAppointmentsUseCase
class CreateAppointmentsParams extends Equatable {
  final String name;
  final String? description;

  const CreateAppointmentsParams({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// Create appointments use case
class CreateAppointmentsUseCase implements UseCase<AppointmentsEntity, CreateAppointmentsParams> {
  final AppointmentsRepository _repository;

  CreateAppointmentsUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(CreateAppointmentsParams params) async {
    // Validation
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Name cannot be empty',
        fieldErrors: {'name': ['Name is required']},
      ));
    }

    return await _repository.createAppointments(
      name: params.name.trim(),
      description: params.description?.trim(),
    );
  }
}
