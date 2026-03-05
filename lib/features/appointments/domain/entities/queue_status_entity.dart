/// QueueStatus Entity
///
/// Core business entity representing a queue_status in the system.
/// Pure Dart class with no external dependencies.
library;

import 'package:equatable/equatable.dart';

/// QueueStatus entity representing the core queue_status data
class QueueStatusEntity extends Equatable {
  /// Doctor id
  final String doctorId;

  /// Queue date
  final String queueDate;

  /// Status
  final String status;

  /// Current token
  final int currentToken;

  /// Total tokens issued
  final int totalTokensIssued;

  /// Avg wait minutes
  final int avgWaitMinutes;

  const QueueStatusEntity({
    required this.doctorId,
    required this.queueDate,
    required this.status,
    required this.currentToken,
    required this.totalTokensIssued,
    required this.avgWaitMinutes,
  });

  /// Creates a copy with updated fields
  QueueStatusEntity copyWith({
    String? doctorId,
    String? queueDate,
    String? status,
    int? currentToken,
    int? totalTokensIssued,
    int? avgWaitMinutes,
  }) {
    return QueueStatusEntity(
      doctorId: doctorId ?? this.doctorId,
      queueDate: queueDate ?? this.queueDate,
      status: status ?? this.status,
      currentToken: currentToken ?? this.currentToken,
      totalTokensIssued: totalTokensIssued ?? this.totalTokensIssued,
      avgWaitMinutes: avgWaitMinutes ?? this.avgWaitMinutes,
    );
  }

  /// Creates an empty QueueStatus
  factory QueueStatusEntity.empty() {
    return QueueStatusEntity(
      doctorId: '',
      queueDate: '',
      status: '',
      currentToken: 0,
      totalTokensIssued: 0,
      avgWaitMinutes: 0,
    );
  }

  /// Checks if this is an empty entity
  bool get isEmpty => doctorId.isEmpty;

  /// Checks if this is not empty
  bool get isNotEmpty => doctorId.isNotEmpty;

  @override
  List<Object?> get props => [
        doctorId,
        queueDate,
        status,
        currentToken,
        totalTokensIssued,
        avgWaitMinutes,
      ];

  @override
  String toString() {
    return 'QueueStatusEntity(doctorId: $doctorId, queueDate: $queueDate, status: $status)';
  }
}
