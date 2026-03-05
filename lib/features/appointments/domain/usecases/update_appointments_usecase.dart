/// Update Appointments Use Case
///
/// Updates an existing appointments.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// Parameters for UpdateAppointmentsUseCase
class UpdateAppointmentsParams extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final bool? isActive;

  const UpdateAppointmentsParams({
    required this.id,
    this.name,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

/// Update appointments use case
class UpdateAppointmentsUseCase implements UseCase<AppointmentsEntity, UpdateAppointmentsParams> {
  final AppointmentsRepository _repository;

  UpdateAppointmentsUseCase(this._repository);

  @override
  Future<Either<Failure, AppointmentsEntity>> call(UpdateAppointmentsParams params) async {
    // Validation
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID cannot be empty',
        fieldErrors: {'id': ['ID is required']},
      ));
    }

    if (params.name != null && params.name!.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Name cannot be empty',
        fieldErrors: {'name': ['Name cannot be empty if provided']},
      ));
    }

    return await _repository.updateAppointments(
      id: params.id,
      name: params.name?.trim(),
      description: params.description?.trim(),
      isActive: params.isActive,
    );
  }
}
