import 'package:flutter/foundation.dart';

import '../repositories/alert_schedule_repository.dart';

class MarkAlertTriggered {
  const MarkAlertTriggered(this.repository);

  final AlertScheduleRepository repository;

  Future<void> call(String id, DateTime triggeredAt) async {
    await repository.markTriggered(id, triggeredAt);
    if (kDebugMode) {
      debugPrint('Alert $id marked triggered at $triggeredAt');
    }
  }
}
