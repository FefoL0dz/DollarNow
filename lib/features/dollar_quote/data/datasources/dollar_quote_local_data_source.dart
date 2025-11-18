import 'package:hive/hive.dart';

import '../models/currency_model.dart';
import '../models/dollar_quote_model.dart';

abstract class DollarQuoteLocalDataSource {
  Future<void> cacheLatestQuote(DollarQuoteModel quote);
  Future<DollarQuoteModel?> getCachedLatestQuote(String currencyCode);
  Future<void> cacheHistory(String currencyCode, List<DollarQuoteModel> quotes);
  Future<List<DollarQuoteModel>> getCachedHistory(String currencyCode);
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);
  Future<List<CurrencyModel>> getCachedCurrencies();
}

class DollarQuoteLocalDataSourceImpl implements DollarQuoteLocalDataSource {
  DollarQuoteLocalDataSourceImpl(
    this.latestBox,
    this.historyBox,
    this.currencyBox,
  );

  final Box<DollarQuoteModel> latestBox;
  final Box<List<dynamic>> historyBox;
  final Box<List<dynamic>> currencyBox;

  @override
  Future<void> cacheLatestQuote(DollarQuoteModel quote) async {
    await latestBox.put(quote.currencyCode, quote);
  }

  @override
  Future<void> cacheHistory(
    String currencyCode,
    List<DollarQuoteModel> quotes,
  ) async {
    await historyBox.put(currencyCode, List<DollarQuoteModel>.from(quotes));
  }

  @override
  Future<DollarQuoteModel?> getCachedLatestQuote(String currencyCode) async {
    return latestBox.get(currencyCode);
  }

  @override
  Future<List<DollarQuoteModel>> getCachedHistory(String currencyCode) async {
    final stored = historyBox.get(currencyCode);
    if (stored == null) {
      return [];
    }

    return stored.cast<DollarQuoteModel>();
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    await currencyBox.put(
      'currencies',
      currencies.map((currency) => currency.toJson()).toList(),
    );
  }

  @override
  Future<List<CurrencyModel>> getCachedCurrencies() async {
    final stored = currencyBox.get('currencies');
    if (stored == null) {
      return [];
    }

    return stored
        .map(
          (item) =>
              CurrencyModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
