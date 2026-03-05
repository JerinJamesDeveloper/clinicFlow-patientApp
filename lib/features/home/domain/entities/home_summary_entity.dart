/// HomeSummary Entity
///
/// Core business entity representing a home_summary in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// HomeSummary entity representing the core home_summary data
class HomeSummaryEntity extends Equatable {
  /// Summary title
  final String summaryTitle;

  const HomeSummaryEntity({
    required this.summaryTitle,
  });

  /// Creates a copy with updated fields
  HomeSummaryEntity copyWith({
    String? summaryTitle,
  }) {
    return HomeSummaryEntity(
      summaryTitle: summaryTitle ?? this.summaryTitle,
    );
  }

  /// Creates an empty HomeSummary
  factory HomeSummaryEntity.empty() {
    return HomeSummaryEntity(
      summaryTitle: '',
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => summaryTitle.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => summaryTitle.isNotEmpty;

  @override
  List<Object?> get props => [
        summaryTitle,
      ];

  @override
  String toString() {
    return 'HomeSummaryEntity(summaryTitle: $summaryTitle)';
  }
}
