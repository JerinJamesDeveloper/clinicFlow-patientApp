/// Update Home Use Case
///
/// Updates an existing home.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

/// Parameters for UpdateHomeUseCase
class UpdateHomeParams extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final bool? isActive;

  const UpdateHomeParams({
    required this.id,
    this.name,
    this.description,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, isActive];
}

/// Update home use case
class UpdateHomeUseCase implements UseCase<HomeEntity, UpdateHomeParams> {
  final HomeRepository _repository;

  UpdateHomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeEntity>> call(UpdateHomeParams params) async {
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

    return await _repository.updateHome(
      id: params.id,
      name: params.name?.trim(),
      description: params.description?.trim(),
      isActive: params.isActive,
    );
  }
}
