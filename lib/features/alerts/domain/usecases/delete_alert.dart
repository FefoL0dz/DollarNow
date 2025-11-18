import '../repositories/alert_schedule_repository.dart';

class DeleteAlert {
  const DeleteAlert(this.repository);

  final AlertScheduleRepository repository;

  Future<void> call(String id) {
    return repository.deleteAlert(id);
  }
}
