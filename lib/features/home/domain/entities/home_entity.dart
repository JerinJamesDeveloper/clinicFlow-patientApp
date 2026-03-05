/// Home Entity
///
/// Core business entity representing a home in the system.
/// This is a pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// Home entity representing the core home data
class HomeEntity extends Equatable {
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

  const HomeEntity({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Creates a copy with updated fields
  HomeEntity copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HomeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Creates an empty Home
  factory HomeEntity.empty() {
    return HomeEntity(
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
    return 'HomeEntity(id: $id, name: $name)';
  }
}
