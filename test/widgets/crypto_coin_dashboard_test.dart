import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dollar_now/model/crypto_coin.dart';
import 'package:dollar_now/service/crypto/crypto_service_factory.dart';
import 'package:dollar_now/service/crypto/crypto_service_interface.dart';
import 'package:dollar_now/widgets/crypto_coin_dashboard.dart';

class MockCryptoService extends Mock implements ICryptoService {}

void main() {
  late MockCryptoService mockService;

  setUp(() {
    mockService = MockCryptoService();
    CryptoServiceFactory.mockService = mockService;
  });

  tearDown(() {
    CryptoServiceFactory.mockService = null;
  });

  testWidgets('CryptoCoinDashboard shows loading then list of coins', (WidgetTester tester) async {
    // Setup mock response
    final fakeCoins = [
      CryptoCoin(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        priceUsd: 50000.0,
        change24h: 5.5,
        imageUrl: null,
      ),
      CryptoCoin(
        id: 'ethereum',
        symbol: 'ETH',
        name: 'Ethereum',
        priceUsd: 3000.0,
        change24h: -2.1,
        imageUrl: null,
      ),
    ];

    when(() => mockService.fetchTopCoins(limit: any(named: 'limit')))
        .thenAnswer((_) async => fakeCoins);

    // Build widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CryptoCoinDashboard(),
      ),
    ));

    // Verify loading indicator is present initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for future to complete
    await tester.pumpAndSettle();

    // Verify loading is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify list items are present
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('\$50000.00'), findsOneWidget);
    expect(find.text('5.50%'), findsOneWidget);

    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('\$3000.00'), findsOneWidget);
    expect(find.text('-2.10%'), findsOneWidget);
  });

  testWidgets('CryptoCoinDashboard shows error state on failure', (WidgetTester tester) async {
    when(() => mockService.fetchTopCoins(limit: any(named: 'limit')))
        .thenAnswer((_) => Future.error(Exception('Failed to load')));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CryptoCoinDashboard(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Failed to load crypto data'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
