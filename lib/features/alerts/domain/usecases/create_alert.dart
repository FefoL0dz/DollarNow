import '../entities/alert_schedule.dart';
import '../repositories/alert_schedule_repository.dart';

class CreateAlert {
  const CreateAlert(this.repository);

  final AlertScheduleRepository repository;

  Future<void> call(AlertSchedule alert) {
    return repository.saveAlert(alert);
  }
}
