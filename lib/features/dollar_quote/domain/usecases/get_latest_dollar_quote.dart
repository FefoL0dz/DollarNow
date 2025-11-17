import '../entities/dollar_quote.dart';
import '../repositories/dollar_quote_repository.dart';

class GetLatestDollarQuote {
  const GetLatestDollarQuote(this.repository);

  final DollarQuoteRepository repository;

  Future<DollarQuote> call({
    required String currencyCode,
    required String currencyName,
  }) {
    return repository.getLatestQuote(
      currencyCode: currencyCode,
      currencyName: currencyName,
    );
  }
}
