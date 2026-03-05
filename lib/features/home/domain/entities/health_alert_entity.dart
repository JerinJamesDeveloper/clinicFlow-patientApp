/// HealthAlert Entity
///
/// Core business entity representing a health_alert in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// HealthAlert entity representing the core health_alert data
class HealthAlertEntity extends Equatable {
  /// Title
  final String title;

  /// Message
  final String message;

  /// Alert type
  final String alertType;

  /// Priority
  final String priority;

  const HealthAlertEntity({
    required this.title,
    required this.message,
    required this.alertType,
    required this.priority,
  });

  /// Creates a copy with updated fields
  HealthAlertEntity copyWith({
    String? title,
    String? message,
    String? alertType,
    String? priority,
  }) {
    return HealthAlertEntity(
      title: title ?? this.title,
      message: message ?? this.message,
      alertType: alertType ?? this.alertType,
      priority: priority ?? this.priority,
    );
  }

  /// Creates an empty HealthAlert
  factory HealthAlertEntity.empty() {
    return HealthAlertEntity(
      title: '',
      message: '',
      alertType: '',
      priority: '',
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => title.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => title.isNotEmpty;

  @override
  List<Object?> get props => [
        title,
        message,
        alertType,
        priority,
      ];

  @override
  String toString() {
    return 'HealthAlertEntity(title: $title, message: $message, alertType: $alertType)';
  }
}
