import 'package:flutter/foundation.dart';

import '../../domain/entities/alert_schedule.dart';
import '../../domain/services/alert_notification_service.dart';

class DebugAlertNotificationService implements AlertNotificationService {
  const DebugAlertNotificationService();

  @override
  Future<void> showAlertTriggered(AlertSchedule schedule, double price) async {
    if (kDebugMode) {
      debugPrint(
        '🔔 Alert triggered for ${schedule.currencyCode}: '
        '${price.toStringAsFixed(4)} < ${schedule.threshold}',
      );
    }
  }
}
