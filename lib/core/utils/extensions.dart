/// Extension Methods
/// 
/// Useful extension methods for built-in Dart and Flutter types.
/// Enhances productivity and code readability.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ============== STRING EXTENSIONS ==============
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isValidPhone {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final uri = Uri.tryParse(this);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string contains only alphabets
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Check if string contains only alphanumeric characters
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Get initials from name (e.g., "John Doe" -> "JD")
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(' ').where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Convert to nullable int
  int? get toIntOrNull => int.tryParse(this);

  /// Convert to nullable double
  double? get toDoubleOrNull => double.tryParse(this);

  /// Mask sensitive data (e.g., email, phone)
  String maskEmail() {
    if (!isValidEmail) return this;
    final parts = split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) {
      return '***@$domain';
    }
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  String maskPhone() {
    if (length < 4) return this;
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }
}

// ============== NULLABLE STRING EXTENSIONS ==============
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Return the string or a default value
  String orDefault([String defaultValue = '']) => this ?? defaultValue;
}

// ============== NUM EXTENSIONS ==============
extension NumExtensions on num {
  /// Format as currency
  String toCurrency({String symbol = '\$', int decimalDigits = 2}) {
    return '$symbol${toStringAsFixed(decimalDigits)}';
  }

  /// Format with thousand separators
  String toFormattedString({int decimalDigits = 0}) {
    final formatter = NumberFormat('#,##0' + (decimalDigits > 0 ? '.${'0' * decimalDigits}' : ''));
    return formatter.format(this);
  }

  /// Convert bytes to human readable format
  String toFileSize() {
    if (this < 1024) return '${this}B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)}KB';
    if (this < 1024 * 1024 * 1024) return '${(this / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Check if number is between two values (inclusive)
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Clamp percentage (0-100)
  num get clampPercentage => clamp(0, 100);
}

// ============== DURATION EXTENSIONS ==============
extension DurationExtensions on Duration {
  /// Format duration as HH:MM:SS
  String get formatted {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format duration as human readable
  String get humanReadable {
    if (inDays > 0) {
      return '$inDays day${inDays > 1 ? 's' : ''} ago';
    }
    if (inHours > 0) {
      return '$inHours hour${inHours > 1 ? 's' : ''} ago';
    }
    if (inMinutes > 0) {
      return '$inMinutes minute${inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }
}

// ============== DATETIME EXTENSIONS ==============
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Format date (default: dd/MM/yyyy)
  String format([String pattern = 'dd/MM/yyyy']) {
    return DateFormat(pattern).format(this);
  }

  /// Get relative time string
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    }
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    }
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final daysToSubtract = weekday - 1;
    return subtract(Duration(days: daysToSubtract)).startOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);
}

// ============== LIST EXTENSIONS ==============
extension ListExtensions<T> on List<T> {
  /// Get first element or null
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Separate list into chunks
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Get distinct elements
  List<T> get distinct => toSet().toList();
}

// ============== MAP EXTENSIONS ==============
extension MapExtensions<K, V> on Map<K, V> {
  /// Get value or default
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Check if map contains all keys
  bool containsAllKeys(Iterable<K> keys) => keys.every(containsKey);
}

// ============== CONTEXT EXTENSIONS ==============
extension ContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get current theme
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get padding
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get view insets (keyboard height, etc.)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Pop current route
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push replacement named route
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, dynamic>(routeName, arguments: arguments);
  }

  /// Push and remove until
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Show snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Unfocus (dismiss keyboard)
  void unfocus() => FocusScope.of(this).unfocus();
}

// ============== WIDGET EXTENSIONS ==============
extension WidgetExtensions on Widget {
  /// Add padding
  Widget withPadding(EdgeInsetsGeometry padding) {
    return Padding(padding: padding, child: this);
  }

  /// Add margin via Container
  Widget withMargin(EdgeInsetsGeometry margin) {
    return Container(margin: margin, child: this);
  }

  /// Center widget
  Widget get centered => Center(child: this);

  /// Expand widget
  Widget get expanded => Expanded(child: this);

  /// Make widget flexible
  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);

  /// Add opacity
  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);

  /// Add tap gesture
  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }

  /// Make widget scrollable
  Widget get scrollable => SingleChildScrollView(child: this);

  /// Safe area
  Widget get safeArea => SafeArea(child: this);
}