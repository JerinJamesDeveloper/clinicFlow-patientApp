/// Local Storage Keys
/// 
/// Centralized location for all SharedPreferences/SecureStorage keys.
/// Prevents typos and makes key management easier.
library;

class StorageKeys {
  // Prevent instantiation
  StorageKeys._();

  // ============== AUTH KEYS ==============
  /// JWT access token
  static const String accessToken = 'access_token';
  
  /// JWT refresh token
  static const String refreshToken = 'refresh_token';
  
  /// Token expiration timestamp
  static const String tokenExpiry = 'token_expiry';
  
  /// Current user data (JSON)
  static const String currentUser = 'current_user';

  ///userRole data (JSON)
  static const String userRole = 'user_role';
  
  /// Is user logged in flag
  static const String isLoggedIn = 'is_logged_in';
  
  /// Remember me preference
  static const String rememberMe = 'remember_me';
  
  /// Last logged in email
  static const String lastEmail = 'last_email';

  // ============== USER PREFERENCES ==============
  /// App theme mode (light/dark/system)
  static const String themeMode = 'theme_mode';
  
  /// Selected language code
  static const String languageCode = 'language_code';
  
  /// Notification settings enabled
  static const String notificationsEnabled = 'notifications_enabled';
  
  /// Biometric auth enabled
  static const String biometricEnabled = 'biometric_enabled';

  // ============== ONBOARDING ==============
  /// Has user seen onboarding
  static const String onboardingComplete = 'onboarding_complete';
  
  /// First app launch flag
  static const String isFirstLaunch = 'is_first_launch';

  // ============== CACHE KEYS ==============
  /// Prefix for cached data
  static const String cachePrefix = 'cache_';
  
  /// Cache timestamp suffix
  static const String cacheTimestampSuffix = '_timestamp';
  
  /// Cached user profile
  static const String cachedProfile = '${cachePrefix}profile';

  // ============== APP STATE ==============
  /// Last active timestamp
  static const String lastActiveTime = 'last_active_time';
  
  /// App version (for migration checks)
  static const String appVersion = 'app_version';
  
  /// FCM token for push notifications
  static const String fcmToken = 'fcm_token';

  // ============== HELPER METHODS ==============
  /// Generate cache key for a specific item
  static String cacheKey(String key) => '$cachePrefix$key';
  
  /// Generate cache timestamp key
  static String cacheTimestampKey(String key) => '$key$cacheTimestampSuffix';
}