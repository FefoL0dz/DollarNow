import '../repositories/alert_schedule_repository.dart';

class ToggleAlert {
  const ToggleAlert(this.repository);

  final AlertScheduleRepository repository;

  Future<void> call(String id, bool isActive) {
    return repository.toggleAlert(id, isActive);
  }
}
