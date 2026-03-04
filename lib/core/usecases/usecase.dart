/// Base Use Case
/// 
/// Abstract class that all use cases extend.
/// Implements the callable interface for clean invocation.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base use case interface with parameters
/// 
/// [Type] is the return type on success
/// [Params] is the parameters type
abstract class UseCase<Type, Params> {
  /// Executes the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require any parameters
abstract class UseCaseNoParams<Type> {
  /// Executes the use case
  Future<Either<Failure, Type>> call();
}

/// Stream use case for reactive data
abstract class StreamUseCase<Type, Params> {
  /// Returns a stream of data
  Stream<Type> call(Params params);
}

/// Stream use case without parameters
abstract class StreamUseCaseNoParams<Type> {
  /// Returns a stream of data
  Stream<Type> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}