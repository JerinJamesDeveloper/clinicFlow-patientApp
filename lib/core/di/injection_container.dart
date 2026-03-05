/// Dependency Injection Container
///
/// Centralized dependency injection setup using GetIt.
/// Registers all services, repositories, and BLoCs.
library;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../storage/local_storage.dart';
import '../services/permission_service.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/change_password_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Profile Feature
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
// Appointments Feature
import '../../features/appointments/data/datasources/appointments_local_datasource.dart';
import '../../features/appointments/data/datasources/appointments_remote_datasource.dart';
import '../../features/appointments/data/repositories/appointments_repository_impl.dart';
import '../../features/appointments/domain/repositories/appointments_repository.dart';
import '../../features/appointments/domain/usecases/create_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/delete_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/get_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/get_all_appointmentss_usecase.dart';
import '../../features/appointments/domain/usecases/update_appointments_usecase.dart';
import '../../features/appointments/presentation/bloc/appointments_bloc.dart';
import '../../features/appointments/domain/usecases/get_doctors_usecase.dart';
import '../../features/appointments/domain/usecases/get_doctor_detail_usecase.dart';
import '../../features/appointments/domain/usecases/get_departments_usecase.dart';
import '../../features/appointments/domain/usecases/get_hospital_branches_usecase.dart';
import '../../features/appointments/domain/usecases/get_doctor_schedule_usecase.dart';
import '../../features/appointments/domain/usecases/get_queue_status_usecase.dart';
import '../../features/appointments/domain/usecases/get_upcoming_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/get_past_appointments_usecase.dart';
import '../../features/appointments/domain/usecases/get_appointment_detail_usecase.dart';
import '../../features/appointments/domain/usecases/create_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/cancel_appointment_usecase.dart';
import '../../features/appointments/domain/usecases/reschedule_appointment_usecase.dart';


/// Global service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
///
/// Call this in main.dart before running the app:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initDependencies();
///   runApp(const MyApp());
/// }
/// ```
Future<void> initDependencies() async {
  // ==================== EXTERNAL ====================
  await _initExternal();

  // ==================== CORE ====================
  _initCore();

  // ==================== FEATURES ====================
  _initAuthFeature();
  _initProfileFeature();

  _initAppointmentsFeature();
}

/// Initialize external dependencies
Future<void> _initExternal() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}

/// Initialize core services
void _initCore() {
  // Local Storage
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl<SharedPreferences>()),
  );

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl<Connectivity>()),
  );

  // Dio Client
  sl.registerLazySingleton<DioClient>(() => DioClient(sl<LocalStorage>()));

  // Permission Service
  sl.registerLazySingleton<PermissionService>(() => PermissionService());
}

/// Initialize Auth feature
void _initAuthFeature() {
  // ========== BLoC ==========
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      changePasswordUseCase: sl(),
      verifyOtpUseCase: sl(),
      resendOtpUseCase: sl(),
      resendVerificationEmailUseCase: sl(),
    ),
  );

  // ========== Use Cases ==========
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));

  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()));

  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );

  sl.registerLazySingleton<CheckAuthStatusUseCase>(
    () => CheckAuthStatusUseCase(sl()),
  );

  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl()),
  );

  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl()),
  );

  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl()),
  );

  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));

  sl.registerLazySingleton<ResendOtpUseCase>(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton<ResendVerificationEmailUseCase>(
    () => ResendVerificationEmailUseCase(sl()),
  );

  // ========== Repository ==========
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ========== Data Sources ==========
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
}

/// Initialize Profile feature
void _initProfileFeature() {
  // ========== BLoC ==========
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      updateAvatarUseCase: sl(),
      removeAvatarUseCase: sl(),
      deleteAccountUseCase: sl(),
      repository: sl(),
    ),
  );

  // ========== Use Cases ==========
  sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));

  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateAvatarUseCase>(
    () => UpdateAvatarUseCase(sl()),
  );

  sl.registerLazySingleton<RemoveAvatarUseCase>(
    () => RemoveAvatarUseCase(sl()),
  );

  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl()),
  );

  // ========== Repository ==========
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ========== Data Sources ==========
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
  await initDependencies();
}

/// Check if dependencies are initialized
bool get areDependenciesInitialized => sl.isRegistered<AuthBloc>();

/// Injection helper extension
extension GetItExtension on GetIt {
  /// Get or register a singleton
  T getOrRegisterSingleton<T extends Object>(T Function() factory) {
    if (isRegistered<T>()) {
      return get<T>();
    }
    registerSingleton<T>(factory());
    return get<T>();
  }

  /// Get or register a lazy singleton
  T getOrRegisterLazySingleton<T extends Object>(T Function() factory) {
    if (isRegistered<T>()) {
      return get<T>();
    }
    registerLazySingleton<T>(factory);
    return get<T>();
  }
}

/// Service locator mixin for widgets that need dependencies
mixin ServiceLocatorMixin {
  /// Get a dependency from the service locator
  T locate<T extends Object>() => sl<T>();

  /// Get AuthBloc
  AuthBloc get authBloc => sl<AuthBloc>();

  /// Get ProfileBloc
  ProfileBloc get profileBloc => sl<ProfileBloc>();
}

// ==================== END OF FEATURE ====================


/// Initialize Appointments feature
void _initAppointmentsFeature() {
  // ========== BLoC ==========
  sl.registerFactory<AppointmentsBloc>(
    () => AppointmentsBloc(
      rescheduleAppointmentUseCase: sl(),
      cancelAppointmentUseCase: sl(),
      createAppointmentUseCase: sl(),
      getAppointmentDetailUseCase: sl(),
      getPastAppointmentsUseCase: sl(),
      getUpcomingAppointmentsUseCase: sl(),
      getQueueStatusUseCase: sl(),
      getDoctorScheduleUseCase: sl(),
      getHospitalBranchesUseCase: sl(),
      getDepartmentsUseCase: sl(),
      getDoctorDetailUseCase: sl(),
      getDoctorsUseCase: sl(),
      getAppointmentsUseCase: sl(),
      getAllAppointmentssUseCase: sl(),
      createAppointmentsUseCase: sl(),
      updateAppointmentsUseCase: sl(),
      deleteAppointmentsUseCase: sl(),
    ),
  );

  // ========== Use Cases ==========
  sl.registerLazySingleton<RescheduleAppointmentUseCase>(
    () => RescheduleAppointmentUseCase(sl()),
  );

  sl.registerLazySingleton<CancelAppointmentUseCase>(
    () => CancelAppointmentUseCase(sl()),
  );

  sl.registerLazySingleton<CreateAppointmentUseCase>(
    () => CreateAppointmentUseCase(sl()),
  );

  sl.registerLazySingleton<GetAppointmentDetailUseCase>(
    () => GetAppointmentDetailUseCase(sl()),
  );

  sl.registerLazySingleton<GetPastAppointmentsUseCase>(
    () => GetPastAppointmentsUseCase(sl()),
  );

  sl.registerLazySingleton<GetUpcomingAppointmentsUseCase>(
    () => GetUpcomingAppointmentsUseCase(sl()),
  );

  sl.registerLazySingleton<GetQueueStatusUseCase>(
    () => GetQueueStatusUseCase(sl()),
  );

  sl.registerLazySingleton<GetDoctorScheduleUseCase>(
    () => GetDoctorScheduleUseCase(sl()),
  );

  sl.registerLazySingleton<GetHospitalBranchesUseCase>(
    () => GetHospitalBranchesUseCase(sl()),
  );

  sl.registerLazySingleton<GetDepartmentsUseCase>(
    () => GetDepartmentsUseCase(sl()),
  );

  sl.registerLazySingleton<GetDoctorDetailUseCase>(
    () => GetDoctorDetailUseCase(sl()),
  );

  sl.registerLazySingleton<GetDoctorsUseCase>(
    () => GetDoctorsUseCase(sl()),
  );

  sl.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(sl()),
  );

  sl.registerLazySingleton<GetAllAppointmentssUseCase>(
    () => GetAllAppointmentssUseCase(sl()),
  );

  sl.registerLazySingleton<CreateAppointmentsUseCase>(
    () => CreateAppointmentsUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateAppointmentsUseCase>(
    () => UpdateAppointmentsUseCase(sl()),
  );

  sl.registerLazySingleton<DeleteAppointmentsUseCase>(
    () => DeleteAppointmentsUseCase(sl()),
  );

  // ========== Repository ==========
  sl.registerLazySingleton<AppointmentsRepository>(
    () => AppointmentsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ========== Data Sources ==========
  sl.registerLazySingleton<AppointmentsRemoteDataSource>(
    () => AppointmentsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AppointmentsLocalDataSource>(
    () => AppointmentsLocalDataSourceImpl(sl()),
  );
}

// ==================== END OF Appointments FEATURE ====================

