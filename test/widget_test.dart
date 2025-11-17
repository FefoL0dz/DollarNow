import 'package:dollar_now/features/dollar_quote/domain/entities/dollar_quote.dart';
import 'package:dollar_now/features/dollar_quote/domain/repositories/dollar_quote_repository.dart';
import 'package:dollar_now/features/dollar_quote/domain/usecases/get_dollar_quote_history.dart';
import 'package:dollar_now/features/dollar_quote/domain/usecases/get_latest_dollar_quote.dart';
import 'package:dollar_now/features/dollar_quote/presentation/providers/dollar_quote_provider.dart';
import 'package:dollar_now/main.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDollarQuoteRepository implements DollarQuoteRepository {
  @override
  Future<DollarQuote> getLatestQuote({
    required String currencyCode,
    required String currencyName,
  }) async {
    return DollarQuote(
      currencyCode: currencyCode,
      currencyName: currencyName,
      buyPrice: 4.95,
      sellPrice: 5.02,
      quotationTime: DateTime(2024, 11, 20, 13, 30),
    );
  }

  @override
  Future<List<DollarQuote>> getRecentHistory({
    required String currencyCode,
    required String currencyName,
    int days = 7,
  }) async {
    final now = DateTime(2024, 11, 20, 13, 30);
    return List.generate(days, (index) {
      final date = now.subtract(Duration(days: days - index));
      return DollarQuote(
        currencyCode: currencyCode,
        currencyName: currencyName,
        buyPrice: 4.8 + index * 0.02,
        sellPrice: 4.9 + index * 0.02,
        quotationTime: date,
      );
    });
  }
}

void main() {
  testWidgets('shows Banco Central quote data', (WidgetTester tester) async {
    final repository = _FakeDollarQuoteRepository();
    final provider = DollarQuoteProvider(
      getLatestDollarQuote: GetLatestDollarQuote(repository),
      getDollarQuoteHistory: GetDollarQuoteHistory(repository),
    );

    await tester.pumpWidget(
      DollarNowApp(providerBuilder: () => provider, bootstrapData: false),
    );

    await provider.loadDashboard();
    await tester.pumpAndSettle();
    expect(find.text('Compra'), findsOneWidget);
    expect(find.text('Venda'), findsOneWidget);
    expect(find.text('Atualizar cotação'), findsOneWidget);
    expect(find.textContaining('Histórico dos últimos'), findsOneWidget);
  });
}
