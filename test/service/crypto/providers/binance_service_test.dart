import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:dollar_now/service/crypto/providers/binance_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  group('BinanceService', () {
    late BinanceService service;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      service = BinanceService(client: mockHttpClient);
    });

    test('should return list of CryptoCoin when http response is 200', () async {
      const mockResponse = '''[
        {
          "symbol": "BTCUSDT",
          "lastPrice": "50000.00",
          "priceChangePercent": "5.0"
        }
      ]''';

      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response(mockResponse, 200),
      );

      final coins = await service.fetchTopCoins(limit: 1);

      expect(coins.length, 1);
      expect(coins[0].id, 'btc');
      expect(coins[0].symbol, 'BTC');
      expect(coins[0].priceUsd, 50000.0);
      expect(coins[0].change24h, 5.0);
      expect(coins[0].imageUrl, isNull);
    });

    test('should throw an exception when http response is not 200', () async {
      when(() => mockHttpClient.get(any())).thenAnswer(
        (_) async => http.Response('Error', 500),
      );

      expect(
        () => service.fetchTopCoins(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
