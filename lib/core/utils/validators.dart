/// Form Validators
/// 
/// Centralized validation functions for form fields.
/// Returns error message or null if valid.
library;

import '../constants/app_constants.dart';

class Validators {
  // Prevent instantiation
  Validators._();

  // ============== REQUIRED VALIDATION ==============
  /// Check if value is not empty
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // ============== EMAIL VALIDATION ==============
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    if (!AppConstants.emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // ============== PASSWORD VALIDATION ==============
  /// Validate password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must not exceed ${AppConstants.maxPasswordLength} characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Simple password validation (less strict)
  static String? passwordSimple(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    
    return null;
  }

  // ============== CONFIRM PASSWORD ==============
  /// Validate password confirmation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // ============== NAME VALIDATION ==============
  /// Validate name
  static String? name(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Name'} is required';
    }
    
    if (value.trim().length < AppConstants.minNameLength) {
      return '${fieldName ?? 'Name'} must be at least ${AppConstants.minNameLength} characters';
    }
    
    if (value.trim().length > AppConstants.maxNameLength) {
      return '${fieldName ?? 'Name'} must not exceed ${AppConstants.maxNameLength} characters';
    }
    
    if (!AppConstants.nameRegex.hasMatch(value.trim())) {
      return 'Please enter a valid ${fieldName?.toLowerCase() ?? 'name'}';
    }
    
    return null;
  }

  // ============== PHONE VALIDATION ==============
  /// Validate phone number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces, dashes, and parentheses for validation
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (!AppConstants.phoneRegex.hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Optional phone validation
  static String? phoneOptional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional, so empty is OK
    }
    
    return phone(value);
  }

  // ============== LENGTH VALIDATION ==============
  /// Validate minimum length
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (value.trim().length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.trim().length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    
    return null;
  }

  /// Validate length range
  static String? lengthRange(
    String? value, {
    required int min,
    required int max,
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    final length = value.trim().length;
    
    if (length < min || length > max) {
      return '${fieldName ?? 'This field'} must be between $min and $max characters';
    }
    
    return null;
  }

  // ============== NUMERIC VALIDATION ==============
  /// Validate numeric value
  static String? numeric(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (double.tryParse(value.trim()) == null) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  /// Validate integer value
  static String? integer(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (int.tryParse(value.trim()) == null) {
      return 'Please enter a valid whole number';
    }
    
    return null;
  }

  /// Validate number range
  static String? numberRange(
    String? value, {
    required double min,
    required double max,
    String? fieldName,
  }) {
    final numError = numeric(value, fieldName);
    if (numError != null) return numError;
    
    final number = double.parse(value!.trim());
    
    if (number < min || number > max) {
      return '${fieldName ?? 'Value'} must be between $min and $max';
    }
    
    return null;
  }

  // ============== URL VALIDATION ==============
  /// Validate URL format
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }
    
    final uri = Uri.tryParse(value.trim());
    
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return 'Please enter a valid URL';
    }
    
    if (!['http', 'https'].contains(uri.scheme.toLowerCase())) {
      return 'URL must start with http:// or https://';
    }
    
    return null;
  }

  /// Optional URL validation
  static String? urlOptional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    return url(value);
  }

  // ============== DATE VALIDATION ==============
  /// Validate date (must be in past)
  static String? dateInPast(DateTime? value, [String? fieldName]) {
    if (value == null) {
      return '${fieldName ?? 'Date'} is required';
    }
    
    if (value.isAfter(DateTime.now())) {
      return '${fieldName ?? 'Date'} must be in the past';
    }
    
    return null;
  }

  /// Validate date (must be in future)
  static String? dateInFuture(DateTime? value, [String? fieldName]) {
    if (value == null) {
      return '${fieldName ?? 'Date'} is required';
    }
    
    if (value.isBefore(DateTime.now())) {
      return '${fieldName ?? 'Date'} must be in the future';
    }
    
    return null;
  }

  // ============== CUSTOM VALIDATION ==============
  /// Match a specific regex pattern
  static String? pattern(
    String? value, 
    RegExp regex, 
    String errorMessage,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    
    if (!regex.hasMatch(value.trim())) {
      return errorMessage;
    }
    
    return null;
  }

  // ============== COMBINATOR ==============
  /// Combine multiple validators
  /// Returns the first error found, or null if all pass
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  // ============== OTP VALIDATION ==============
  /// Validate OTP code
  static String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP code is required';
    }
    
    if (value.trim().length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }
    
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }
}