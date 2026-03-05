/// Department Entity
///
/// Core business entity representing a department in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// Department entity representing the core department data
class DepartmentEntity extends Equatable {
  /// Name
  final String name;

  /// Code
  final String code;

  /// Description
  final String description;

  const DepartmentEntity({
    required this.name,
    required this.code,
    required this.description,
  });

  /// Creates a copy with updated fields
  DepartmentEntity copyWith({
    String? name,
    String? code,
    String? description,
  }) {
    return DepartmentEntity(
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
    );
  }

  /// Creates an empty Department
  factory DepartmentEntity.empty() {
    return DepartmentEntity(
      name: '',
      code: '',
      description: '',
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => name.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => name.isNotEmpty;

  @override
  List<Object?> get props => [
        name,
        code,
        description,
      ];

  @override
  String toString() {
    return 'DepartmentEntity(name: $name, code: $code, description: $description)';
  }
}
