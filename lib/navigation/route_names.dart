/// Route Names
///
/// Centralized route path constants.
/// Prevents typos and makes refactoring easier.
library;

/// Route path constants
class RoutePaths {
  RoutePaths._();

  // ============== AUTH ROUTES ==============
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String verifyOtp = '/verify-otp';

  // ============== MAIN ROUTES ==============
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String changePassword = '/settings/change-password';
  static const String notifications = '/notifications';

  // ============== ADMIN ROUTES ==============
  static const String adminHome = '/admin/home';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminUserDetail = '/admin/users/:userId';
  static const String adminSettings = '/admin/settings';

  // ============== ERROR ROUTES ==============
  static const String notFound = '/404';
  static const String accessDenied = '/access-denied';
  static const String error = '/error';
}

/// Route name constants (for named navigation)
class RouteNames {
  RouteNames._();

  // Auth
  static const String splash = 'splash';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String resetPassword = 'resetPassword';
  static const String verifyEmail = 'verifyEmail';
  static const String verifyOtp = 'verifyOtp';

  // Main
  static const String home = 'home';
  static const String profile = 'profile';
  static const String editProfile = 'editProfile';
  static const String settings = 'settings';
  static const String changePassword = 'changePassword';
  static const String notifications = 'notifications';

  // Admin
  static const String adminHome = 'adminHome';
  static const String adminDashboard = 'adminDashboard';
  static const String adminUsers = 'adminUsers';
  static const String adminUserDetail = 'adminUserDetail';
  static const String adminSettings = 'adminSettings';

  // Error
  static const String notFound = 'notFound';
  static const String accessDenied = 'accessDenied';
  static const String error = 'error';
}
