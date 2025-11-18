import '../entities/alert_schedule.dart';
import '../repositories/alert_schedule_repository.dart';

class WatchAlerts {
  const WatchAlerts(this.repository);

  final AlertScheduleRepository repository;

  Stream<List<AlertSchedule>> call() => repository.watchAlerts();
}
