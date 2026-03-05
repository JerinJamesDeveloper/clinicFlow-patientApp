/// Home Model
///
/// Data model that extends HomeEntity.
/// Handles JSON serialization/deserialization for API communication.
library;

import '../../domain/entities/home_entity.dart';

/// Home data model with JSON serialization
class HomeModel extends HomeEntity {
  const HomeModel({
    required super.id,
    required super.name,
    super.description,
    super.isActive = true,
    required super.createdAt,
    super.updatedAt,
  });

  /// Creates a HomeModel from JSON map
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
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

  /// Creates a HomeModel from a HomeEntity
  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converts this model to an entity
  HomeEntity toEntity() {
    return HomeEntity(
      id: id,
      name: name,
      description: description,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates an empty HomeModel
  factory HomeModel.empty() {
    return HomeModel(
      id: '',
      name: '',
      createdAt: DateTime.now(),
    );
  }

  /// Creates a copy with updated fields
  @override
  HomeModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HomeModel(
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
