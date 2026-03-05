/// Get Home Use Case
///
/// Retrieves a home by ID.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Parameters for GetHomeUseCase
class GetHomeParams extends Equatable {
  final String id;

  const GetHomeParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Get home use case
class GetHomeUseCase implements UseCase<HomeEntity, GetHomeParams> {
  final HomeRepository _repository;

  GetHomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeEntity>> call(GetHomeParams params) async {
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID cannot be empty',
        fieldErrors: {'id': ['ID is required']},
      ));
    }

    return await _repository.getHome(params.id);
  }
}
