/// Delete Home Use Case
///
/// Deletes a home by ID.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/home_repository.dart';

/// Parameters for DeleteHomeUseCase
class DeleteHomeParams extends Equatable {
  final String id;

  const DeleteHomeParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Delete home use case
class DeleteHomeUseCase implements UseCase<Unit, DeleteHomeParams> {
  final HomeRepository _repository;

  DeleteHomeUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteHomeParams params) async {
    if (params.id.isEmpty) {
      return const Left(ValidationFailure(
        message: 'ID cannot be empty',
        fieldErrors: {'id': ['ID is required']},
      ));
    }

    return await _repository.deleteHome(params.id);
  }
}
