import '../entities/alert_schedule.dart';

abstract class AlertNotificationService {
  Future<void> showAlertTriggered(AlertSchedule schedule, double price);
}
