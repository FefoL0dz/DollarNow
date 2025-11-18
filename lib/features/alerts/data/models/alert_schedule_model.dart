import '../../domain/entities/alert_schedule.dart';

class AlertScheduleModel extends AlertSchedule {
  const AlertScheduleModel({
    required super.id,
    required super.currencyCode,
    required super.currencyName,
    required super.threshold,
    required super.startDate,
    required super.repeatDaily,
    required super.createdAt,
    super.lastTriggeredAt,
    super.isActive,
  });

  factory AlertScheduleModel.fromMap(Map<String, dynamic> map) {
    return AlertScheduleModel(
      id: map['id'] as String,
      currencyCode: map['currencyCode'] as String,
      currencyName: map['currencyName'] as String,
      threshold: (map['threshold'] as num).toDouble(),
      startDate: DateTime.parse(map['startDate'] as String),
      repeatDaily: map['repeatDaily'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastTriggeredAt: map['lastTriggeredAt'] != null
          ? DateTime.parse(map['lastTriggeredAt'] as String)
          : null,
      isActive: map['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currencyCode': currencyCode,
      'currencyName': currencyName,
      'threshold': threshold,
      'startDate': startDate.toIso8601String(),
      'repeatDaily': repeatDaily,
      'createdAt': createdAt.toIso8601String(),
      'lastTriggeredAt': lastTriggeredAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  static AlertScheduleModel fromEntity(AlertSchedule schedule) {
    return AlertScheduleModel(
      id: schedule.id,
      currencyCode: schedule.currencyCode,
      currencyName: schedule.currencyName,
      threshold: schedule.threshold,
      startDate: schedule.startDate,
      repeatDaily: schedule.repeatDaily,
      createdAt: schedule.createdAt,
      lastTriggeredAt: schedule.lastTriggeredAt,
      isActive: schedule.isActive,
    );
  }

  @override
  AlertScheduleModel copyWith({
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
    return AlertScheduleModel(
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
}
