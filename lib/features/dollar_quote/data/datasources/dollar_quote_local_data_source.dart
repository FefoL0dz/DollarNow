import 'package:hive/hive.dart';

import '../models/dollar_quote_model.dart';

abstract class DollarQuoteLocalDataSource {
  Future<void> cacheLatestQuote(DollarQuoteModel quote);
  Future<DollarQuoteModel?> getCachedLatestQuote(String currencyCode);
  Future<void> cacheHistory(String currencyCode, List<DollarQuoteModel> quotes);

  Future<List<DollarQuoteModel>> getCachedHistory(String currencyCode);
}

class DollarQuoteLocalDataSourceImpl implements DollarQuoteLocalDataSource {
  DollarQuoteLocalDataSourceImpl(this.latestBox, this.historyBox);

  final Box<DollarQuoteModel> latestBox;
  final Box<List<dynamic>> historyBox;

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
}
