import 'package:flutter_test/flutter_test.dart';
import 'package:dollar_now/config/app_config.dart';
import 'package:dollar_now/service/crypto/crypto_service_factory.dart';
import 'package:dollar_now/service/crypto/providers/coingecko_service.dart';
import 'package:dollar_now/service/crypto/providers/coincap_service.dart';
import 'package:dollar_now/service/crypto/providers/binance_service.dart';

void main() {
  group('CryptoServiceFactory', () {
    test('should return CoinGeckoService for coingecko type', () {
      final service = CryptoServiceFactory.getService(CryptoProviderType.coingecko);
      expect(service, isA<CoinGeckoService>());
    });

    test('should return CoinCapService for coincap type', () {
      final service = CryptoServiceFactory.getService(CryptoProviderType.coincap);
      expect(service, isA<CoinCapService>());
    });

    test('should return BinanceService for binance type', () {
      final service = CryptoServiceFactory.getService(CryptoProviderType.binance);
      expect(service, isA<BinanceService>());
    });

    test('getActiveService should return service matching active config', () {
      // In this case, AppConfig.activeCryptoProvider is hardcoded to coingecko.
      final service = CryptoServiceFactory.getActiveService();
      expect(service, isA<CoinGeckoService>());
    });
  });
}
