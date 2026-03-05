/// GetUpcomingAppointments Use Case
///
/// GetUpcomingAppointments for home.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// GetUpcomingAppointments use case
class GetUpcomingAppointmentsUseCase implements UseCaseNoParams<List<HomeEntity>> {
  final HomeRepository _repository;

  GetUpcomingAppointmentsUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeEntity>>> call() async {
    return await _repository.getUpcomingAppointments();
  }
}
