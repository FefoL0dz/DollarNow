import '../entities/currency.dart';
import '../repositories/dollar_quote_repository.dart';

class GetSupportedCurrencies {
  const GetSupportedCurrencies(this.repository);

  final DollarQuoteRepository repository;

  Future<List<Currency>> call() => repository.getAvailableCurrencies();
}
