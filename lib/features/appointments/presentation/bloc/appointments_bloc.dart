/// Appointments BLoC
///
/// Business Logic Component for appointments management.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/appointments_entity.dart';
import '../../domain/usecases/create_appointments_usecase.dart';
import '../../domain/usecases/delete_appointments_usecase.dart';
import '../../domain/usecases/get_appointments_usecase.dart';
import '../../domain/usecases/get_all_appointmentss_usecase.dart';
import '../../domain/usecases/update_appointments_usecase.dart';
import 'appointments_event.dart';
import 'appointments_state.dart';
import '../../domain/usecases/get_doctors_usecase.dart';
import '../../domain/usecases/get_doctor_detail_usecase.dart';
import '../../domain/usecases/get_departments_usecase.dart';
import '../../domain/usecases/get_hospital_branches_usecase.dart';
import '../../domain/usecases/get_doctor_schedule_usecase.dart';
import '../../domain/usecases/get_queue_status_usecase.dart';
import '../../domain/usecases/get_upcoming_appointments_usecase.dart';
import '../../domain/usecases/get_past_appointments_usecase.dart';
import '../../domain/usecases/get_appointment_detail_usecase.dart';
import '../../domain/usecases/create_appointment_usecase.dart';
import '../../domain/usecases/cancel_appointment_usecase.dart';
import '../../domain/usecases/reschedule_appointment_usecase.dart';

/// Appointments BLoC
class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  final RescheduleAppointmentUseCase _rescheduleAppointmentUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final GetAppointmentDetailUseCase _getAppointmentDetailUseCase;
  final GetPastAppointmentsUseCase _getPastAppointmentsUseCase;
  final GetUpcomingAppointmentsUseCase _getUpcomingAppointmentsUseCase;
  final GetQueueStatusUseCase _getQueueStatusUseCase;
  final GetDoctorScheduleUseCase _getDoctorScheduleUseCase;
  final GetHospitalBranchesUseCase _getHospitalBranchesUseCase;
  final GetDepartmentsUseCase _getDepartmentsUseCase;
  final GetDoctorDetailUseCase _getDoctorDetailUseCase;
  final GetDoctorsUseCase _getDoctorsUseCase;
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final GetAllAppointmentssUseCase _getAllAppointmentssUseCase;
  final CreateAppointmentsUseCase _createAppointmentsUseCase;
  final UpdateAppointmentsUseCase _updateAppointmentsUseCase;
  final DeleteAppointmentsUseCase _deleteAppointmentsUseCase;

  AppointmentsBloc({
    required RescheduleAppointmentUseCase rescheduleAppointmentUseCase,
    required CancelAppointmentUseCase cancelAppointmentUseCase,
    required CreateAppointmentUseCase createAppointmentUseCase,
    required GetAppointmentDetailUseCase getAppointmentDetailUseCase,
    required GetPastAppointmentsUseCase getPastAppointmentsUseCase,
    required GetUpcomingAppointmentsUseCase getUpcomingAppointmentsUseCase,
    required GetQueueStatusUseCase getQueueStatusUseCase,
    required GetDoctorScheduleUseCase getDoctorScheduleUseCase,
    required GetHospitalBranchesUseCase getHospitalBranchesUseCase,
    required GetDepartmentsUseCase getDepartmentsUseCase,
    required GetDoctorDetailUseCase getDoctorDetailUseCase,
    required GetDoctorsUseCase getDoctorsUseCase,
    required GetAppointmentsUseCase getAppointmentsUseCase,
    required GetAllAppointmentssUseCase getAllAppointmentssUseCase,
    required CreateAppointmentsUseCase createAppointmentsUseCase,
    required UpdateAppointmentsUseCase updateAppointmentsUseCase,
    required DeleteAppointmentsUseCase deleteAppointmentsUseCase,
  }) : _rescheduleAppointmentUseCase = rescheduleAppointmentUseCase,
       _cancelAppointmentUseCase = cancelAppointmentUseCase,
       _createAppointmentUseCase = createAppointmentUseCase,
       _getAppointmentDetailUseCase = getAppointmentDetailUseCase,
       _getPastAppointmentsUseCase = getPastAppointmentsUseCase,
       _getUpcomingAppointmentsUseCase = getUpcomingAppointmentsUseCase,
       _getQueueStatusUseCase = getQueueStatusUseCase,
       _getDoctorScheduleUseCase = getDoctorScheduleUseCase,
       _getHospitalBranchesUseCase = getHospitalBranchesUseCase,
       _getDepartmentsUseCase = getDepartmentsUseCase,
       _getDoctorDetailUseCase = getDoctorDetailUseCase,
       _getDoctorsUseCase = getDoctorsUseCase,
       _getAppointmentsUseCase = getAppointmentsUseCase,
       _getAllAppointmentssUseCase = getAllAppointmentssUseCase,
       _createAppointmentsUseCase = createAppointmentsUseCase,
       _updateAppointmentsUseCase = updateAppointmentsUseCase,
       _deleteAppointmentsUseCase = deleteAppointmentsUseCase,
       super(const AppointmentsInitial()) {
    on<AppointmentsLoadRequested>(_onLoadRequested);
    on<AppointmentsListLoadRequested>(_onListLoadRequested);
    on<AppointmentsCreateRequested>(_onCreate);
    on<AppointmentsUpdateRequested>(_onUpdate);
    on<AppointmentsDeleteRequested>(_onDelete);
    on<AppointmentsRefreshRequested>(_onRefresh);
    on<AppointmentsErrorCleared>(_onErrorCleared);
    on<AppointmentsGetDoctorsRequested>(_onGetDoctors);
    on<AppointmentsGetDoctorDetailRequested>(_onGetDoctorDetail);
    on<AppointmentsGetDepartmentsRequested>(_onGetDepartments);
    on<AppointmentsRescheduleAppointmentRequested>(_onRescheduleAppointment);
    on<AppointmentsCancelAppointmentRequested>(_onCancelAppointment);
    on<AppointmentsCreateAppointmentRequested>(_onCreateAppointment);
    on<AppointmentsGetAppointmentDetailRequested>(_onGetAppointmentDetail);
    on<AppointmentsGetPastAppointmentsRequested>(_onGetPastAppointments);
    on<AppointmentsGetUpcomingAppointmentsRequested>(
      _onGetUpcomingAppointments,
    );
    on<AppointmentsGetQueueStatusRequested>(_onGetQueueStatus);
    on<AppointmentsGetDoctorScheduleRequested>(_onGetDoctorSchedule);
    on<AppointmentsGetHospitalBranchesRequested>(_onGetHospitalBranches);
  }

  Future<void> _onLoadRequested(
    AppointmentsLoadRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading...'));

    final result = await _getAppointmentsUseCase(
      GetAppointmentsParams(id: event.id),
    );

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointments) => emit(AppointmentsLoaded(appointments: appointments)),
    );
  }

  Future<void> _onListLoadRequested(
    AppointmentsListLoadRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading list...'));

    final result = await _getAllAppointmentssUseCase();

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  Future<void> _onCreate(
    AppointmentsCreateRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.create,
      ),
    );

    final result = await _createAppointmentsUseCase(
      CreateAppointmentsParams(
        name: event.name,
        description: event.description,
      ),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = [...currentItems, appointments];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'Appointments created successfully',
        ),
      );
    });
  }

  Future<void> _onUpdate(
    AppointmentsUpdateRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.update,
      ),
    );

    final result = await _updateAppointmentsUseCase(
      UpdateAppointmentsParams(
        id: event.id,
        name: event.name,
        description: event.description,
        isActive: event.isActive,
      ),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = currentItems.map((item) {
        return item.id == appointments.id ? appointments : item;
      }).toList();
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'Appointments updated successfully',
        ),
      );
    });
  }

  Future<void> _onDelete(
    AppointmentsDeleteRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.delete,
      ),
    );

    final result = await _deleteAppointmentsUseCase(
      DeleteAppointmentsParams(id: event.id),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      _,
    ) {
      final updatedItems = currentItems
          .where((item) => item.id != event.id)
          .toList();
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'Appointments deleted successfully',
        ),
      );
    });
  }

  Future<void> _onRefresh(
    AppointmentsRefreshRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final result = await _getAllAppointmentssUseCase();

    result.fold(
      (failure) {
        // Keep current state on refresh failure
      },
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  void _onErrorCleared(
    AppointmentsErrorCleared event,
    Emitter<AppointmentsState> emit,
  ) {
    final currentItems = _getCurrentItems();
    if (currentItems.isNotEmpty) {
      emit(AppointmentsListLoaded(appointmentss: currentItems));
    } else {
      emit(const AppointmentsInitial());
    }
  }

  List<AppointmentsEntity> _getCurrentItems() {
    final currentState = state;
    if (currentState is AppointmentsListLoaded)
      return currentState.appointmentss;
    if (currentState is AppointmentsOperating)
      return currentState.appointmentss;
    if (currentState is AppointmentsOperationSuccess)
      return currentState.appointmentss;
    if (currentState is AppointmentsError)
      return currentState.appointmentss ?? [];
    return [];
  }

  AppointmentsError _mapFailureToState(
    Failure failure,
    List<AppointmentsEntity> items,
  ) {
    if (failure is ValidationFailure) {
      return AppointmentsError(
        message: failure.message,
        fieldErrors: failure.fieldErrors,
        appointmentss: items,
      );
    }
    return AppointmentsError(message: failure.message, appointmentss: items);
  }

  Future<void> _onGetDoctors(
    AppointmentsGetDoctorsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading list...'));

    final result = await _getDoctorsUseCase();

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  Future<void> _onGetDoctorDetail(
    AppointmentsGetDoctorDetailRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.getDoctorDetail,
      ),
    );

    final result = await _getDoctorDetailUseCase(
      GetDoctorDetailParams(doctorId: event.doctorId),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = [...currentItems, appointments];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'GetDoctorDetail completed successfully',
        ),
      );
    });
  }

  Future<void> _onGetDepartments(
    AppointmentsGetDepartmentsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading list...'));

    final result = await _getDepartmentsUseCase();

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  Future<void> _onGetHospitalBranches(
    AppointmentsGetHospitalBranchesRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading list...'));

    final result = await _getHospitalBranchesUseCase();

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  Future<void> _onGetDoctorSchedule(
    AppointmentsGetDoctorScheduleRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.getDoctorSchedule,
      ),
    );

    final result = await _getDoctorScheduleUseCase(
      GetDoctorScheduleParams(doctorId: event.doctorId),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointmentss,
    ) {
      final updatedItems = [...currentItems, ...appointmentss];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'GetDoctorSchedule completed successfully',
        ),
      );
    });
  }

  Future<void> _onGetQueueStatus(
    AppointmentsGetQueueStatusRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.getQueueStatus,
      ),
    );

    final result = await _getQueueStatusUseCase(
      GetQueueStatusParams(doctorId: event.doctorId),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = [...currentItems, appointments];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'GetQueueStatus completed successfully',
        ),
      );
    });
  }

  Future<void> _onGetUpcomingAppointments(
    AppointmentsGetUpcomingAppointmentsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading list...'));

    final result = await _getUpcomingAppointmentsUseCase();

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  Future<void> _onGetPastAppointments(
    AppointmentsGetPastAppointmentsRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    emit(const AppointmentsLoading(message: 'Loading list...'));

    final result = await _getPastAppointmentsUseCase();

    result.fold(
      (failure) => emit(AppointmentsError(message: failure.message)),
      (appointmentss) =>
          emit(AppointmentsListLoaded(appointmentss: appointmentss)),
    );
  }

  Future<void> _onGetAppointmentDetail(
    AppointmentsGetAppointmentDetailRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.getAppointmentDetail,
      ),
    );

    final result = await _getAppointmentDetailUseCase(
      GetAppointmentDetailParams(appointmentId: event.appointmentId),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = [...currentItems, appointments];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'GetAppointmentDetail completed successfully',
        ),
      );
    });
  }

  Future<void> _onCreateAppointment(
    AppointmentsCreateAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.createAppointment,
      ),
    );

    final result = await _createAppointmentUseCase(
      CreateAppointmentParams(name: event.name, description: event.description),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = [...currentItems, appointments];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'CreateAppointment completed successfully',
        ),
      );
    });
  }

  Future<void> _onCancelAppointment(
    AppointmentsCancelAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.cancelAppointment,
      ),
    );

    final result = await _cancelAppointmentUseCase(
      CancelAppointmentParams(appointmentId: event.appointmentId),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      _,
    ) {
      final updatedItems = currentItems
          .where((item) => item.id != event.appointmentId)
          .toList();
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'CancelAppointment completed successfully',
        ),
      );
    });
  }

  Future<void> _onRescheduleAppointment(
    AppointmentsRescheduleAppointmentRequested event,
    Emitter<AppointmentsState> emit,
  ) async {
    final currentItems = _getCurrentItems();
    emit(
      AppointmentsOperating(
        appointmentss: currentItems,
        operation: AppointmentsOperation.rescheduleAppointment,
      ),
    );

    final result = await _rescheduleAppointmentUseCase(
      RescheduleAppointmentParams(appointmentId: event.appointmentId),
    );

    result.fold((failure) => emit(_mapFailureToState(failure, currentItems)), (
      appointments,
    ) {
      final updatedItems = [...currentItems, appointments];
      emit(
        AppointmentsOperationSuccess(
          appointmentss: updatedItems,
          message: 'RescheduleAppointment completed successfully',
        ),
      );
    });
  }
}
