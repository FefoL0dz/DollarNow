enum CryptoProviderType {
  coingecko,
  coincap,
  binance,
}

class AppConfig {
  // Set the active Crypto Provider here. This allows easy swapping of the API logic.
  static const CryptoProviderType activeCryptoProvider = CryptoProviderType.coingecko;
}
