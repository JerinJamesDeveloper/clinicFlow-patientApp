/// Home BLoC
///
/// Business Logic Component for home management.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/create_home_usecase.dart';
import '../../domain/usecases/delete_home_usecase.dart';
import '../../domain/usecases/get_home_usecase.dart';
import '../../domain/usecases/get_all_homes_usecase.dart';
import '../../domain/usecases/update_home_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../domain/usecases/get_home_summary_usecase.dart';
import '../../domain/usecases/get_health_alerts_usecase.dart';
import '../../domain/usecases/get_upcoming_appointments_usecase.dart';

/// Home BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUpcomingAppointmentsUseCase _getUpcomingAppointmentsUseCase;
  final GetHealthAlertsUseCase _getHealthAlertsUseCase;
  final GetHomeSummaryUseCase _getHomeSummaryUseCase;
  final GetHomeUseCase _getHomeUseCase;
  final GetAllHomesUseCase _getAllHomesUseCase;
  final CreateHomeUseCase _createHomeUseCase;
  final UpdateHomeUseCase _updateHomeUseCase;
  final DeleteHomeUseCase _deleteHomeUseCase;

  HomeBloc({
    required GetUpcomingAppointmentsUseCase getUpcomingAppointmentsUseCase,
    required GetHealthAlertsUseCase getHealthAlertsUseCase,
    required GetHomeSummaryUseCase getHomeSummaryUseCase,
    required GetHomeUseCase getHomeUseCase,
    required GetAllHomesUseCase getAllHomesUseCase,
    required CreateHomeUseCase createHomeUseCase,
    required UpdateHomeUseCase updateHomeUseCase,
    required DeleteHomeUseCase deleteHomeUseCase,
  })  : _getUpcomingAppointmentsUseCase = getUpcomingAppointmentsUseCase, _getHealthAlertsUseCase = getHealthAlertsUseCase, _getHomeSummaryUseCase = getHomeSummaryUseCase, _getHomeUseCase = getHomeUseCase,
        _getAllHomesUseCase = getAllHomesUseCase,
        _createHomeUseCase = createHomeUseCase,
        _updateHomeUseCase = updateHomeUseCase,
        _deleteHomeUseCase = deleteHomeUseCase,
        super(const HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeListLoadRequested>(_onListLoadRequested);
    on<HomeCreateRequested>(_onCreate);
    on<HomeUpdateRequested>(_onUpdate);
    on<HomeDeleteRequested>(_onDelete);
    on<HomeRefreshRequested>(_onRefresh);
    on<HomeErrorCleared>(_onErrorCleared);
    on<HomeGetHomeSummaryRequested>(_onGetHomeSummary);
    on<HomeGetHealthAlertsRequested>(_onGetHealthAlerts);
    on<HomeGetUpcomingAppointmentsRequested>(_onGetUpcomingAppointments);
  }

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading(message: 'Loading...'));

    final result = await _getHomeUseCase(
      GetHomeParams(id: event.id),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (home) => emit(HomeLoaded(home: home)),
    );
  }

  Future<void> _onListLoadRequested(
    HomeListLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading(message: 'Loading list...'));

    final result = await _getAllHomesUseCase();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homes) => emit(HomeListLoaded(homes: homes)),
    );
  }

  Future<void> _onCreate(
    HomeCreateRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(HomeOperating(
      homes: currentItems,
      operation: HomeOperation.create,
    ));

    final result = await _createHomeUseCase(
      CreateHomeParams(
        name: event.name,
        description: event.description,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentItems)),
      (home) {
        final updatedItems = [...currentItems, home];
        emit(HomeOperationSuccess(
          homes: updatedItems,
          message: 'Home created successfully',
        ));
      },
    );
  }

  Future<void> _onUpdate(
    HomeUpdateRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(HomeOperating(
      homes: currentItems,
      operation: HomeOperation.update,
    ));

    final result = await _updateHomeUseCase(
      UpdateHomeParams(
        id: event.id,
        name: event.name,
        description: event.description,
        isActive: event.isActive,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentItems)),
      (home) {
        final updatedItems = currentItems.map((item) {
          return item.id == home.id ? home : item;
        }).toList();
        emit(HomeOperationSuccess(
          homes: updatedItems,
          message: 'Home updated successfully',
        ));
      },
    );
  }

  Future<void> _onDelete(
    HomeDeleteRequested event,
    Emitter<HomeState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(HomeOperating(
      homes: currentItems,
      operation: HomeOperation.delete,
    ));

    final result = await _deleteHomeUseCase(
      DeleteHomeParams(id: event.id),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure, currentItems)),
      (_) {
        final updatedItems = currentItems.where((item) => item.id != event.id).toList();
        emit(HomeOperationSuccess(
          homes: updatedItems,
          message: 'Home deleted successfully',
        ));
      },
    );
  }

  Future<void> _onRefresh(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    final result = await _getAllHomesUseCase();

    result.fold(
      (failure) {
        // Keep current state on refresh failure
      },
      (homes) => emit(HomeListLoaded(homes: homes)),
    );
  }

  void _onErrorCleared(
    HomeErrorCleared event,
    Emitter<HomeState> emit,
  ) {
    final currentItems = _getCurrentItems();
    if (currentItems.isNotEmpty) {
      emit(HomeListLoaded(homes: currentItems));
    } else {
      emit(const HomeInitial());
    }
  }

  List<HomeEntity> _getCurrentItems() {
    final currentState = state;
    if (currentState is HomeListLoaded) return currentState.homes;
    if (currentState is HomeOperating) return currentState.homes;
    if (currentState is HomeOperationSuccess) return currentState.homes;
    if (currentState is HomeError) return currentState.homes ?? [];
    return [];
  }

  HomeError _mapFailureToState(Failure failure, List<HomeEntity> items) {
    if (failure is ValidationFailure) {
      return HomeError(
        message: failure.message,
        fieldErrors: failure.fieldErrors,
        homes: items,
      );
    }
    return HomeError(
      message: failure.message,
      homes: items,
    );
  }

  Future<void> _onGetHomeSummary(
    HomeGetHomeSummaryRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading(message: 'Loading...'));

    final result = await _getHomeSummaryUseCase(
      GetHomeSummaryParams(id: event.id),
    );

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (home) => emit(HomeLoaded(home: home)),
    );
  }


  Future<void> _onGetHealthAlerts(
    HomeGetHealthAlertsRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading(message: 'Loading list...'));

    final result = await _getHealthAlertsUseCase();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homes) => emit(HomeListLoaded(homes: homes)),
    );
  }


  Future<void> _onGetUpcomingAppointments(
    HomeGetUpcomingAppointmentsRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading(message: 'Loading list...'));

    final result = await _getUpcomingAppointmentsUseCase();

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (homes) => emit(HomeListLoaded(homes: homes)),
    );
  }

}
