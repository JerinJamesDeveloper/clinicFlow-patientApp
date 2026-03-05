/// Appointments Model
///
/// Data model that extends AppointmentsEntity.
/// Handles JSON serialization/deserialization for API communication.
library;

import '../../domain/entities/appointments_entity.dart';

/// Appointments data model with JSON serialization
class AppointmentsModel extends AppointmentsEntity {
  const AppointmentsModel({
    required super.id,
    required super.name,
    super.description,
    super.isActive = true,
    required super.createdAt,
    super.updatedAt,
  });

  /// Creates a AppointmentsModel from JSON map
  factory AppointmentsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentsModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? 
                json['isActive'] as bool? ?? true,
      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']) ?? 
                 DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a AppointmentsModel from a AppointmentsEntity
  factory AppointmentsModel.fromEntity(AppointmentsEntity entity) {
    return AppointmentsModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converts this model to an entity
  AppointmentsEntity toEntity() {
    return AppointmentsEntity(
      id: id,
      name: name,
      description: description,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates an empty AppointmentsModel
  factory AppointmentsModel.empty() {
    return AppointmentsModel(
      id: '',
      name: '',
      createdAt: DateTime.now(),
    );
  }

  /// Creates a copy with updated fields
  @override
  AppointmentsModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper to parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }
}
