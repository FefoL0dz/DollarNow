import 'package:dollar_now/config/app_config.dart';
import 'package:dollar_now/service/crypto/crypto_service_interface.dart';
import 'package:dollar_now/service/crypto/providers/binance_service.dart';
import 'package:dollar_now/service/crypto/providers/coincap_service.dart';
import 'package:dollar_now/service/crypto/providers/coingecko_service.dart';

class CryptoServiceFactory {
  static ICryptoService? mockService;

  /// Returns the concrete implementation of ICryptoService based on the provided configuration type.
  static ICryptoService getService(CryptoProviderType type) {
    switch (type) {
      case CryptoProviderType.coingecko:
        return CoinGeckoService();
      case CryptoProviderType.coincap:
        return CoinCapService();
      case CryptoProviderType.binance:
        return BinanceService();
      default:
        // Default to CoinGecko as fallback
        return CoinGeckoService();
    }
  }

  /// Convenience method to get the service based on the active AppConfig.
  static ICryptoService getActiveService() {
    if (mockService != null) return mockService!;
    return getService(AppConfig.activeCryptoProvider);
  }
}
