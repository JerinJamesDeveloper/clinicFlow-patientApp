/// Get All Homes Use Case
///
/// Retrieves all homes.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Get all homes use case
class GetAllHomesUseCase implements UseCaseNoParams<List<HomeEntity>> {
  final HomeRepository _repository;

  GetAllHomesUseCase(this._repository);

  @override
  Future<Either<Failure, List<HomeEntity>>> call() async {
    return await _repository.getAllHomes();
  }
}
