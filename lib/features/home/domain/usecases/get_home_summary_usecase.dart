/// GetHomeSummary Use Case
///
/// GetHomeSummary for home.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Parameters for GetHomeSummaryUseCase
class GetHomeSummaryParams extends Equatable {
  final String id;

  const GetHomeSummaryParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// GetHomeSummary use case
class GetHomeSummaryUseCase implements UseCase<HomeEntity, GetHomeSummaryParams> {
  final HomeRepository _repository;

  GetHomeSummaryUseCase(this._repository);

  @override
  Future<Either<Failure, HomeEntity>> call(GetHomeSummaryParams params) async {
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID cannot be empty',
        fieldErrors: {'id': ['ID is required']},
      ));
    }

    return await _repository.getHomeSummary(params.id);
  }
}
