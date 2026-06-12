class CryptoCoin {
  final String id;
  final String symbol;
  final String name;
  final double priceUsd;
  final double? priceBrl;
  final double change24h;
  final String? imageUrl;

  CryptoCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    this.priceBrl,
    required this.change24h,
    this.imageUrl,
  });

  factory CryptoCoin.empty() {
    return CryptoCoin(
      id: '',
      symbol: '',
      name: '',
      priceUsd: 0.0,
      change24h: 0.0,
    );
  }
}
