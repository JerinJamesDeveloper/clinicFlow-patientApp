/// Application-wide constants
/// 
/// Contains all static configuration values used throughout the app.
/// Modify these values based on your environment and requirements.
library;

class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ============== APP INFO ==============
  static const String appName = 'Flutter Starter Kit';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // ============== API CONFIGURATION ==============
  /// Base URL for API calls
  /// Change this based on your environment (dev, staging, prod)
  static const String baseUrl = 'http://localhost:5000';
  
  /// Request timeout duration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // ============== PAGINATION ==============
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // ============== CACHE ==============
  /// Cache duration for different data types
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
  
  // ============== VALIDATION ==============
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int otpLength = 6;
  
  // ============== UI CONFIGURATION ==============
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double buttonHeight = 52.0;
  static const double inputFieldHeight = 56.0;
  static const double defaultRadius = 12.0;
  static const double defaultIconSize = 24.0;
  
  
  // ============== ANIMATION ==============
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // ============== DATE FORMATS ==============
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  
  // ============== REGEX PATTERNS ==============
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );
  
  static final RegExp nameRegex = RegExp(
    r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$",
  );
}