/// Create Home Use Case
///
/// Creates a new home.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Parameters for CreateHomeUseCase
class CreateHomeParams extends Equatable {
  final String name;
  final String? description;

  const CreateHomeParams({
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

/// Create home use case
class CreateHomeUseCase implements UseCase<HomeEntity, CreateHomeParams> {
  final HomeRepository _repository;

  CreateHomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeEntity>> call(CreateHomeParams params) async {
    // Validation
    if (params.name.trim().isEmpty) {
      return const Left(ValidationFailure(
        message: 'Name cannot be empty',
        fieldErrors: {'name': ['Name is required']},
      ));
    }

    return await _repository.createHome(
      name: params.name.trim(),
      description: params.description?.trim(),
    );
  }
}
