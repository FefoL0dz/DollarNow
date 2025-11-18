import 'package:equatable/equatable.dart';

class AlertSchedule extends Equatable {
  const AlertSchedule({
    required this.id,
    required this.currencyCode,
    required this.currencyName,
    required this.threshold,
    required this.startDate,
    required this.repeatDaily,
    required this.createdAt,
    this.lastTriggeredAt,
    this.isActive = true,
  });

  final String id;
  final String currencyCode;
  final String currencyName;
  final double threshold;
  final DateTime startDate;
  final bool repeatDaily;
  final DateTime createdAt;
  final DateTime? lastTriggeredAt;
  final bool isActive;

  AlertSchedule copyWith({
    String? id,
    String? currencyCode,
    String? currencyName,
    double? threshold,
    DateTime? startDate,
    bool? repeatDaily,
    DateTime? createdAt,
    DateTime? lastTriggeredAt,
    bool? isActive,
  }) {
    return AlertSchedule(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyName: currencyName ?? this.currencyName,
      threshold: threshold ?? this.threshold,
      startDate: startDate ?? this.startDate,
      repeatDaily: repeatDaily ?? this.repeatDaily,
      createdAt: createdAt ?? this.createdAt,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    currencyCode,
    currencyName,
    threshold,
    startDate,
    repeatDaily,
    createdAt,
    lastTriggeredAt,
    isActive,
  ];
}
