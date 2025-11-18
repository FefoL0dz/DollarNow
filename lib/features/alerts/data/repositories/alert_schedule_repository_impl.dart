import '../../domain/entities/alert_schedule.dart';
import '../../domain/repositories/alert_schedule_repository.dart';
import '../datasources/alert_schedule_local_data_source.dart';
import '../models/alert_schedule_model.dart';

class AlertScheduleRepositoryImpl implements AlertScheduleRepository {
  AlertScheduleRepositoryImpl(this.localDataSource);

  final AlertScheduleLocalDataSource localDataSource;

  @override
  Future<void> deleteAlert(String id) {
    return localDataSource.deleteAlert(id);
  }

  @override
  Future<List<AlertSchedule>> loadAlerts() {
    return localDataSource.loadAlerts();
  }

  @override
  Future<void> markTriggered(String id, DateTime triggeredAt) async {
    final models = await localDataSource.loadAlerts();
    final target = models.firstWhere(
      (alert) => alert.id == id,
      orElse: () => throw StateError('Alert not found'),
    );
    final updated = target.copyWith(
      lastTriggeredAt: triggeredAt,
      isActive: target.repeatDaily ? target.isActive : false,
    );
    await localDataSource.saveAlert(updated);
  }

  @override
  Future<void> saveAlert(AlertSchedule alert) {
    return localDataSource.saveAlert(AlertScheduleModel.fromEntity(alert));
  }

  @override
  Future<void> toggleAlert(String id, bool isActive) async {
    final models = await localDataSource.loadAlerts();
    final target = models.firstWhere(
      (alert) => alert.id == id,
      orElse: () => throw StateError('Alert not found'),
    );
    final updated = target.copyWith(isActive: isActive);
    await localDataSource.saveAlert(updated);
  }

  @override
  Stream<List<AlertSchedule>> watchAlerts() {
    return localDataSource.watchAlerts();
  }
}
