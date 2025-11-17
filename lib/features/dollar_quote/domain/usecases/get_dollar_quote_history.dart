import '../entities/dollar_quote.dart';
import '../repositories/dollar_quote_repository.dart';

class GetDollarQuoteHistory {
  const GetDollarQuoteHistory(this.repository);

  final DollarQuoteRepository repository;

  Future<List<DollarQuote>> call({
    required String currencyCode,
    required String currencyName,
    int days = 7,
  }) {
    return repository.getRecentHistory(
      currencyCode: currencyCode,
      currencyName: currencyName,
      days: days,
    );
  }
}
