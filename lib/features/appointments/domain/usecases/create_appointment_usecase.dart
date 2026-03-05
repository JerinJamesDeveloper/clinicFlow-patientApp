/// CreateAppointment Use Case
///
/// CreateAppointment for appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for CreateAppointmentUseCase
class CreateAppointmentParams extends Equatable {
  final String name;
  final String? description;

  const CreateAppointmentParams({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// CreateAppointment use case
class CreateAppointmentUseCase implements UseCase<AppointmentsEntity, CreateAppointmentParams> {
  final AppointmentsRepository _repository;

  CreateAppointmentUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(CreateAppointmentParams params) async {
    // Validation
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Name cannot be empty',
        fieldErrors: {'name': ['Name is required']},
      ));
    }

    return await _repository.createAppointment(
      name: params.name.trim(),
      description: params.description?.trim(),
    );
  }
}
