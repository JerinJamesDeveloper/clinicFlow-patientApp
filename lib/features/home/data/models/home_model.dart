/// Home Model
///
/// Data model that extends HomeEntity.
/// Handles JSON serialization/deserialization for API communication.
library;

import '../../domain/entities/home_entity.dart';

/// Home data model with JSON serialization
class HomeModel extends HomeEntity {
  HomeModel({
    required String name,
    String? id,
    String? description,
    bool isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id ?? _generateId(name: name, description: description),
          name: name,
          description: description,
          isActive: isActive,
          createdAt: createdAt ?? DateTime.now(),
          updatedAt: updatedAt,
        );

  /// Creates a HomeModel from JSON map
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final parsedName = (json['name'] ?? json['title'])?.toString() ?? '';
    final parsedDescription =
        (json['description'] ?? json['subtitle'] ?? json['summary'])
            ?.toString();

    return HomeModel(
      id: (json['id'] ??
              json['home_id'] ??
              json['homeId'] ??
              json['item_id'])
          ?.toString(),
      name: parsedName,
      description: parsedDescription,
      isActive: _parseBool(json['is_active'] ?? json['isActive']) ?? true,
      createdAt: _parseDateTime(
        json['created_at'] ?? json['createdAt'] ?? json['timestamp'],
      ),
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
      name: '',
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

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  static String _generateId({
    required String name,
    String? description,
  }) {
    final seed = '${name.trim()}|${description?.trim() ?? ''}';
    if (seed == '|') return 'home_local';

    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = ((hash * 31) + unit) & 0x7fffffff;
    }
    return 'home_$hash';
  }
}
