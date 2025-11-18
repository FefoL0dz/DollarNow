import '../entities/currency.dart';
import '../entities/dollar_quote.dart';

abstract class DollarQuoteRepository {
  Future<DollarQuote> getLatestQuote({
    required String currencyCode,
    required String currencyName,
  });

  Future<List<DollarQuote>> getRecentHistory({
    required String currencyCode,
    required String currencyName,
    int days = 7,
  });

  Future<List<Currency>> getAvailableCurrencies();
}
