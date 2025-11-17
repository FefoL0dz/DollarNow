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
import '../../features/dollar_quote/presentation/providers/dollar_quote_provider.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(DollarQuoteModelAdapter());
  }

  final latestBox = await Hive.openBox<DollarQuoteModel>('latest_quotes');
  final historyBox = await Hive.openBox<List<dynamic>>('history_quotes');

  sl
    ..registerLazySingleton<http.Client>(() => http.Client())
    ..registerLazySingleton<BcbRemoteDataSource>(
      () => BcbRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<DollarQuoteLocalDataSource>(
      () => DollarQuoteLocalDataSourceImpl(latestBox, historyBox),
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
    ..registerFactory(
      () => DollarQuoteProvider(
        getLatestDollarQuote: sl(),
        getDollarQuoteHistory: sl(),
      ),
    );
}
