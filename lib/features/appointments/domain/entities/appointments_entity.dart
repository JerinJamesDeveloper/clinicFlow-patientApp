/// Appointments Entity
///
/// Core business entity representing a appointments in the system.
/// This is a pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// Appointments entity representing the core appointments data
class AppointmentsEntity extends Equatable {
  /// Unique identifier
  final String id;

  /// Name or title
  final String name;

  /// Description
  final String? description;

  /// Whether this item is active
  final bool isActive;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime? updatedAt;

  const AppointmentsEntity({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy with updated fields
  AppointmentsEntity copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentsEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Creates an empty Appointments
  factory AppointmentsEntity.empty() {
    return AppointmentsEntity(
      id: '',
      name: '',
      createdAt: DateTime.now(),
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => id.isEmpty;

  /// Checks if this is not an empty entity
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isActive,
        createdAt,
        updatedAt,
      ];
      
  @override
  String toString() {
    return 'AppointmentsEntity(id: $id, name: $name)';
  }
}
