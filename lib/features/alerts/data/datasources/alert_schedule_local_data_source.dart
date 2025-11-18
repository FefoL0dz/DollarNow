import 'package:hive/hive.dart';

import '../models/alert_schedule_model.dart';

abstract class AlertScheduleLocalDataSource {
  Stream<List<AlertScheduleModel>> watchAlerts();
  Future<List<AlertScheduleModel>> loadAlerts();
  Future<void> saveAlert(AlertScheduleModel model);
  Future<void> deleteAlert(String id);
}

class AlertScheduleLocalDataSourceImpl implements AlertScheduleLocalDataSource {
  AlertScheduleLocalDataSourceImpl(this.box);

  final Box<Map> box;

  @override
  Stream<List<AlertScheduleModel>> watchAlerts() async* {
    yield _readAll();
    yield* box.watch().map((_) => _readAll());
  }

  @override
  Future<List<AlertScheduleModel>> loadAlerts() async {
    return _readAll();
  }

  @override
  Future<void> saveAlert(AlertScheduleModel model) async {
    await box.put(model.id, model.toMap());
  }

  @override
  Future<void> deleteAlert(String id) async {
    await box.delete(id);
  }

  List<AlertScheduleModel> _readAll() {
    final items =
        box.values
            .map((value) => Map<String, dynamic>.from(value))
            .map(AlertScheduleModel.fromMap)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }
}
