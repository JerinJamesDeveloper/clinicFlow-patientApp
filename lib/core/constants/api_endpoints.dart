/// API Endpoints
///
/// Centralized location for all API endpoint paths.
/// Organized by feature/module for easy maintenance.
library;

import 'app_constants.dart';

class ApiEndpoints {
  // Prevent instantiation
  ApiEndpoints._();

  static const String baseUrl = AppConstants.baseUrl;
  // ============== AUTH ENDPOINTS ==============
  static const String _authBase = '$baseUrl/api';

  static const String login = '$_authBase/login';
  static const String register = '$_authBase/register';
  static const String logout = '$_authBase/logout';
  static const String refreshToken = '$_authBase/refresh-token';
  static const String forgotPassword = '$_authBase/forgot-password';
  static const String resetPassword = '$_authBase/reset-password';
  static const String verifyEmail = '$_authBase/verify-email';
  static const String resendVerification = '$_authBase/resend-verification';
  static const String verifyOtp = '$_authBase/verify-otp';
  static const String resendOtp = '$_authBase/resend-otp';
  static const String changePassword = '$_authBase/change-password';
  static const String authMe = '$_authBase/me';

  // ============== USER ENDPOINTS ==============
  static const String _userBase = '$baseUrl/users';

  static const String userMe = '$_userBase/me';
  static const String updateProfile = userMe;
  static const String uploadAvatar = '$_userBase/me/avatar';
  static const String deleteAccount = userMe;

  /// Get user by username
  static String userByUsername(String username) => '$_userBase/$username';

  // ============== ADMIN ENDPOINTS ==============
  static const String _adminBase = '$baseUrl/admin';

  static const String adminUsers = '$_adminBase/users';
  static const String adminDashboard = '$_adminBase/dashboard';
  static const String adminStats = '$_adminBase/stats';

  /// Admin get user by ID
  static String adminUserById(String id) => '$_adminBase/users/$id';

  /// Admin update user role
  static String adminUpdateUserRole(String id) => '$_adminBase/users/$id/role';

  // ============== NOTIFICATION ENDPOINTS ==============
  static final String _notificationBase = '$baseUrl/notifications';

  static String get notifications => _notificationBase;
  static String get notificationUnreadCount =>
      '$_notificationBase/unread-count';
  static String get notificationReadAll => '$_notificationBase/read-all';
  static String get notificationSeenAll => '$_notificationBase/seen-all';
  static String get notificationDeviceToken =>
      '$_notificationBase/device-token';

  /// Get notification by ID
  static String notificationById(String id) => '$_notificationBase/$id';

  /// Mark notification as read
  static String notificationMarkRead(String id) =>
      '$_notificationBase/$id/read';

  // ============== COMMON ==============
  static const String health = '/health';
  static const String version = '/version';
  // ================= Appointments ============================
  static const String appointmentsBase = '$baseUrl/appointmentss';
  static const String appointmentss = appointmentsBase;
  static const String getappointmentss = '$appointmentsBase/get';
  static const String getallappointmentss = '$appointmentsBase/getall';
  static const String createappointmentss = '$appointmentsBase/create';
  static const String deleteappointmentss = '$appointmentsBase/delete';
  static const String updateappointmentss = '$appointmentsBase/update';
  // ================= Home ============================
  static const String homeBase = '$baseUrl/homes';
  static const String homes = homeBase;
  static const String gethomes = '$homeBase/get';
  static const String getallhomes = '$homeBase/getall';
  static const String createhomes = '$homeBase/create';
  static const String deletehomes = '$homeBase/delete';
  static const String updatehomes = '$homeBase/update';
}
