import '../../../../core/error/dollar_exception.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/dollar_quote.dart';
import '../../domain/repositories/dollar_quote_repository.dart';
import '../datasources/bcb_remote_data_source.dart';
import '../datasources/dollar_quote_local_data_source.dart';
import '../models/dollar_quote_model.dart';

class DollarQuoteRepositoryImpl implements DollarQuoteRepository {
  DollarQuoteRepositoryImpl(this.remoteDataSource, this.localDataSource);

  final BcbRemoteDataSource remoteDataSource;
  final DollarQuoteLocalDataSource localDataSource;

  @override
  Future<DollarQuote> getLatestQuote({
    required String currencyCode,
    required String currencyName,
  }) async {
    try {
      final remote = await remoteDataSource.fetchLatestQuote(
        currencyCode: currencyCode,
        currencyName: currencyName,
      );
      await localDataSource.cacheLatestQuote(remote);
      return remote;
    } on DollarException {
      final cached = await localDataSource.getCachedLatestQuote(currencyCode);
      if (cached != null) {
        return cached;
      }
      rethrow;
    } catch (_) {
      final cached = await localDataSource.getCachedLatestQuote(currencyCode);
      if (cached != null) {
        return cached;
      }
      throw const DollarException(
        'Não foi possível carregar a cotação. Verifique sua conexão e tente novamente.',
      );
    }
  }

  @override
  Future<List<DollarQuote>> getRecentHistory({
    required String currencyCode,
    required String currencyName,
    int days = 7,
  }) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    try {
      final List<DollarQuoteModel> history = await remoteDataSource
          .fetchQuoteHistory(
            currencyCode: currencyCode,
            currencyName: currencyName,
            startDate: startDate,
            endDate: now,
          );
      await localDataSource.cacheHistory(currencyCode, history);
      return history;
    } on DollarException {
      final cached = await localDataSource.getCachedHistory(currencyCode);
      if (cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    } catch (_) {
      final cached = await localDataSource.getCachedHistory(currencyCode);
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const DollarException(
        'Não foi possível carregar o histórico. Tente novamente mais tarde.',
      );
    }
  }

  @override
  Future<List<Currency>> getAvailableCurrencies() async {
    try {
      final currencies = await remoteDataSource.fetchAvailableCurrencies();
      await localDataSource.cacheCurrencies(currencies);
      return currencies;
    } on DollarException {
      final cached = await localDataSource.getCachedCurrencies();
      if (cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    } catch (_) {
      final cached = await localDataSource.getCachedCurrencies();
      if (cached.isNotEmpty) {
        return cached;
      }
      throw const DollarException(
        'Não foi possível carregar a lista de moedas. Verifique sua conexão.',
      );
    }
  }
}
