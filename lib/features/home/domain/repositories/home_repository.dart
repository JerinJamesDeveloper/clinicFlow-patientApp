/// Home Repository Interface
///
/// Abstract repository defining the contract for home operations.
/// This interface is implemented by the data layer.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/home_entity.dart';

/// Abstract repository interface for home operations
abstract class HomeRepository {
  /// Gets a home by ID
  ///
  /// Returns [HomeEntity] on success or [Failure] on error.
  Future<Either<Failure, HomeEntity>> getHome(String id);

  /// Gets all homes
  ///
  /// Returns [List<HomeEntity>] on success or [Failure] on error.
  Future<Either<Failure, List<HomeEntity>>> getAllHomes();

  /// Creates a new home
  ///
  /// Returns created [HomeEntity] on success or [Failure] on error.
  Future<Either<Failure, HomeEntity>> createHome({
    required String name,
    String? description,
  });

  /// Updates an existing home
  ///
  /// Returns updated [HomeEntity] on success or [Failure] on error.
  Future<Either<Failure, HomeEntity>> updateHome({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  });

  /// Deletes a home
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> deleteHome(String id);

  /// GetHomeSummary
  Future<Either<Failure, HomeEntity>> getHomeSummary(String id);


  /// GetHealthAlerts
  Future<Either<Failure, List<HomeEntity>>> getHealthAlerts();


  /// GetUpcomingAppointments
  Future<Either<Failure, List<HomeEntity>>> getUpcomingAppointments();

}
