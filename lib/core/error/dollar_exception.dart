class DollarException implements Exception {
  const DollarException(this.message);

  final String message;

  @override
  String toString() => message;
}
