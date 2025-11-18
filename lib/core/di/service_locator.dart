import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../features/dollar_quote/data/datasources/bcb_remote_data_source.dart';
import '../../features/dollar_quote/data/datasources/dollar_quote_local_data_source.dart';
import '../../features/dollar_quote/data/repositories/dollar_quote_repository_impl.dart';
import '../../features/dollar_quote/data/models/dollar_quote_model.dart';
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
    ..registerFactory(
      () => DollarQuoteProvider(
        getLatestDollarQuote: sl(),
        getDollarQuoteHistory: sl(),
        getSupportedCurrencies: sl(),
      ),
    );
}
