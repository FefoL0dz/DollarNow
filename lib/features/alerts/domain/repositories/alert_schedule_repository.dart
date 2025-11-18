import '../entities/alert_schedule.dart';

abstract class AlertScheduleRepository {
  Stream<List<AlertSchedule>> watchAlerts();
  Future<List<AlertSchedule>> loadAlerts();
  Future<void> saveAlert(AlertSchedule alert);
  Future<void> toggleAlert(String id, bool isActive);
  Future<void> deleteAlert(String id);
  Future<void> markTriggered(String id, DateTime triggeredAt);
}
