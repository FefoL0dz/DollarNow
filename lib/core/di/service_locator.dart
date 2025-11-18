import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../features/alerts/data/datasources/alert_schedule_local_data_source.dart';
import '../../features/alerts/data/repositories/alert_schedule_repository_impl.dart';
import '../../features/alerts/data/services/debug_alert_notification_service.dart';
import '../../features/alerts/domain/repositories/alert_schedule_repository.dart';
import '../../features/alerts/domain/services/alert_notification_service.dart';
import '../../features/alerts/domain/usecases/create_alert.dart';
import '../../features/alerts/domain/usecases/delete_alert.dart';
import '../../features/alerts/domain/usecases/mark_alert_triggered.dart';
import '../../features/alerts/domain/usecases/toggle_alert.dart';
import '../../features/alerts/domain/usecases/watch_alerts.dart';
import '../../features/alerts/presentation/providers/alert_planner_provider.dart';
import '../../features/dollar_quote/data/datasources/bcb_remote_data_source.dart';
import '../../features/dollar_quote/data/datasources/dollar_quote_local_data_source.dart';
import '../../features/dollar_quote/data/models/dollar_quote_model.dart';
import '../../features/dollar_quote/data/repositories/dollar_quote_repository_impl.dart';
import '../../features/dollar_quote/domain/repositories/dollar_quote_repository.dart';
import '../../features/dollar_quote/domain/usecases/get_dollar_quote_history.dart';
import '../../features/dollar_quote/domain/usecases/get_latest_dollar_quote.dart';
import '../../features/dollar_quote/domain/usecases/get_supported_currencies.dart';
import '../../features/dollar_quote/presentation/providers/dollar_quote_provider.dart';
import '../network/logging_http_client.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DollarQuoteModelAdapter());
  }

  final latestBox = await Hive.openBox<DollarQuoteModel>('latest_quotes');
  final historyBox = await Hive.openBox<List<dynamic>>('history_quotes');
  final currencyBox = await Hive.openBox<List<dynamic>>('currencies');
  final alertsBox = await Hive.openBox<Map>('alert_schedules');

  sl
    ..registerLazySingleton<http.Client>(() {
      final baseClient = http.Client();
      if (kDebugMode) {
        return LoggingHttpClient(baseClient);
      }
      return baseClient;
    })
    ..registerLazySingleton<BcbRemoteDataSource>(
      () => BcbRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<DollarQuoteLocalDataSource>(
      () => DollarQuoteLocalDataSourceImpl(latestBox, historyBox, currencyBox),
    )
    ..registerLazySingleton<DollarQuoteRepository>(
      () => DollarQuoteRepositoryImpl(sl(), sl()),
    )
    ..registerLazySingleton<GetLatestDollarQuote>(
      () => GetLatestDollarQuote(sl()),
    )
    ..registerLazySingleton<GetDollarQuoteHistory>(
      () => GetDollarQuoteHistory(sl()),
    )
    ..registerLazySingleton<GetSupportedCurrencies>(
      () => GetSupportedCurrencies(sl()),
    )
    ..registerLazySingleton<AlertScheduleLocalDataSource>(
      () => AlertScheduleLocalDataSourceImpl(alertsBox),
    )
    ..registerLazySingleton<AlertScheduleRepository>(
      () => AlertScheduleRepositoryImpl(sl()),
    )
    ..registerLazySingleton<CreateAlert>(() => CreateAlert(sl()))
    ..registerLazySingleton<WatchAlerts>(() => WatchAlerts(sl()))
    ..registerLazySingleton<ToggleAlert>(() => ToggleAlert(sl()))
    ..registerLazySingleton<DeleteAlert>(() => DeleteAlert(sl()))
    ..registerLazySingleton<MarkAlertTriggered>(() => MarkAlertTriggered(sl()))
    ..registerLazySingleton<AlertNotificationService>(
      () => const DebugAlertNotificationService(),
    )
    ..registerFactory(
      () => DollarQuoteProvider(
        getLatestDollarQuote: sl(),
        getDollarQuoteHistory: sl(),
        getSupportedCurrencies: sl(),
      ),
    )
    ..registerFactory(
      () => AlertPlannerProvider(
        createAlert: sl(),
        watchAlerts: sl(),
        toggleAlert: sl(),
        deleteAlert: sl(),
        markTriggered: sl(),
        getLatestDollarQuote: sl(),
        getSupportedCurrencies: sl(),
        notificationService: sl(),
      ),
    );
}
