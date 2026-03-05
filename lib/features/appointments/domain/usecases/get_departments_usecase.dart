/// GetDepartments Use Case
///
/// GetDepartments for appointments.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointments_entity.dart';
import '../repositories/appointments_repository.dart';

/// GetDepartments use case
class GetDepartmentsUseCase implements UseCaseNoParams<List<AppointmentsEntity>> {
  final AppointmentsRepository _repository;

  GetDepartmentsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AppointmentsEntity>>> call() async {
    return await _repository.getDepartments();
  }
}
