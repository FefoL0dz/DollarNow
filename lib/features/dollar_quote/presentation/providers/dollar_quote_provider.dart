import 'package:flutter/material.dart';

import '../../../../core/error/dollar_exception.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/dollar_quote.dart';
import '../../domain/usecases/get_dollar_quote_history.dart';
import '../../domain/usecases/get_latest_dollar_quote.dart';
import '../../domain/usecases/get_supported_currencies.dart';

class DollarQuoteProvider extends ChangeNotifier {
  DollarQuoteProvider({
    required GetLatestDollarQuote getLatestDollarQuote,
    required GetDollarQuoteHistory getDollarQuoteHistory,
    required GetSupportedCurrencies getSupportedCurrencies,
  }) : _getLatestDollarQuote = getLatestDollarQuote,
       _getDollarQuoteHistory = getDollarQuoteHistory,
       _getSupportedCurrencies = getSupportedCurrencies;

  final GetLatestDollarQuote _getLatestDollarQuote;
  final GetDollarQuoteHistory _getDollarQuoteHistory;
  final GetSupportedCurrencies _getSupportedCurrencies;

  final List<int> supportedHistoryRanges = const [7, 15, 30];

  final Map<String, CurrencyAccent> _presetAccents = {
    'USD': CurrencyAccent(
      gradient: [Color(0xFF2BC0E4), Color(0xFFEAECC6)],
      primary: Color(0xFF00ACC1),
      onPrimary: Colors.white,
      chartLine: Color(0xFF8EE8FF),
    ),
    'EUR': CurrencyAccent(
      gradient: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
      primary: Color(0xFFFF6F91),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFC2D1),
    ),
    'GBP': CurrencyAccent(
      gradient: [Color(0xFFF6D365), Color(0xFFFDA085)],
      primary: Color(0xFFF4A259),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFE3B3),
    ),
    'JPY': CurrencyAccent(
      gradient: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
      primary: Color(0xFF64B5F6),
      onPrimary: Colors.white,
      chartLine: Color(0xFFC2E9FB),
    ),
    'BRL': CurrencyAccent(
      gradient: [Color(0xFF00C9A7), Color(0xFF92FE9D)],
      primary: Color(0xFF00B894),
      onPrimary: Colors.white,
      chartLine: Color(0xFFA7FFCF),
    ),
    'CAD': CurrencyAccent(
      gradient: [Color(0xFF43C6AC), Color(0xFFF8FFAE)],
      primary: Color(0xFF26A69A),
      onPrimary: Colors.white,
      chartLine: Color(0xFFE6F7A9),
    ),
    'AUD': CurrencyAccent(
      gradient: [Color(0xFFF857A6), Color(0xFFFF5858)],
      primary: Color(0xFFFF4081),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFF99B9),
    ),
    'CHF': CurrencyAccent(
      gradient: [Color(0xFF7F00FF), Color(0xFFE100FF)],
      primary: Color(0xFFAA00FF),
      onPrimary: Colors.white,
      chartLine: Color(0xFFE0B3FF),
    ),
    'CNY': CurrencyAccent(
      gradient: [Color(0xFFFF9966), Color(0xFFFF5E62)],
      primary: Color(0xFFFF7043),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFAD99),
    ),
    'MXN': CurrencyAccent(
      gradient: [Color(0xFF1FA2FF), Color(0xFF12D8FA), Color(0xFFA6FFCB)],
      primary: Color(0xFF29B6F6),
      onPrimary: Colors.white,
      chartLine: Color(0xFFA6FFCB),
    ),
  };

  final List<CurrencyAccent> _extraAccents = [
    CurrencyAccent(
      gradient: [Color(0xFF00B4DB), Color(0xFF0083B0)],
      primary: Color(0xFF0288D1),
      onPrimary: Colors.white,
      chartLine: Color(0xFF81D4FA),
    ),
    CurrencyAccent(
      gradient: [Color(0xFFFEB692), Color(0xFFEA5455)],
      primary: Color(0xFFE64A19),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFC4A3),
    ),
    CurrencyAccent(
      gradient: [Color(0xFF52ACFF), Color(0xFFFFE32C)],
      primary: Color(0xFF1E88E5),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFE32C),
    ),
    CurrencyAccent(
      gradient: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
      primary: Color(0xFF7E57C2),
      onPrimary: Colors.white,
      chartLine: Color(0xFFD1C4E9),
    ),
    CurrencyAccent(
      gradient: [Color(0xFFFA709A), Color(0xFFFEE140)],
      primary: Color(0xFFFF9E80),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFE082),
    ),
    CurrencyAccent(
      gradient: [Color(0xFF21D4FD), Color(0xFFB721FF)],
      primary: Color(0xFF7C4DFF),
      onPrimary: Colors.white,
      chartLine: Color(0xFFB388FF),
    ),
    CurrencyAccent(
      gradient: [Color(0xFF6EE7B7), Color(0xFF3B82F6)],
      primary: Color(0xFF0097A7),
      onPrimary: Colors.white,
      chartLine: Color(0xFF9CEC9A),
    ),
  ];

  final CurrencyAccent _defaultAccent = CurrencyAccent(
    gradient: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    primary: const Color(0xFFF06292),
    onPrimary: Colors.white,
    chartLine: const Color(0xFFFFB5E8),
  );

  final Map<String, CurrencyAccent> _dynamicAccents = {};

  DollarQuoteViewState _state = DollarQuoteViewState.initial();
  DollarQuoteViewState get state => _state;

  DollarQuote? quoteForCurrency(String code) => _state.cachedQuotes[code];

  CurrencyAccent accentFor(Currency currency) => _resolveAccent(currency.code);

  CurrencyAccent accentForCode(String code) => _resolveAccent(code);

  CurrencyAccent get currentAccent {
    final currency = _state.selectedCurrency;
    if (currency == null) {
      return _defaultAccent;
    }
    return _resolveAccent(currency.code);
  }

  CurrencyAccent _resolveAccent(String code) {
    final preset = _presetAccents[code];
    if (preset != null) {
      return preset;
    }

    final assigned = _dynamicAccents[code];
    if (assigned != null) {
      return assigned;
    }

    if (_extraAccents.isNotEmpty) {
      final accent =
          _extraAccents[_dynamicAccents.length % _extraAccents.length];
      _dynamicAccents[code] = accent;
      return accent;
    }

    return _defaultAccent;
  }

  Future<void> loadDashboard({Currency? currency, int? historyDays}) async {
    await _ensureCurrenciesLoaded();
    final currentCurrency = currency ?? _state.selectedCurrency;
    if (currentCurrency == null) {
      return;
    }

    final currentHistory = historyDays ?? _state.historyDays;
    final previousState = _state;
    _state = _state.copyWith(
      selectedCurrency: currentCurrency,
      historyDays: currentHistory,
      isLoading: true,
      isHistoryLoading: true,
      errorMessage: null,
      historyErrorMessage: null,
    );
    notifyListeners();

    DollarQuote? nextQuote = previousState.quote;
    List<DollarQuote> nextHistory = previousState.history;
    String? latestError;
    String? historyError;

    try {
      nextQuote = await _getLatestDollarQuote(
        currencyCode: currentCurrency.code,
        currencyName: currentCurrency.name,
      );
    } on DollarException catch (error) {
      latestError = error.message;
    } catch (_) {
      latestError = 'Erro inesperado ao carregar as informações.';
    }

    try {
      nextHistory = await _getDollarQuoteHistory(
        currencyCode: currentCurrency.code,
        currencyName: currentCurrency.name,
        days: currentHistory,
      );
    } on DollarException catch (error) {
      historyError = error.message;
    } catch (_) {
      historyError = 'Erro ao carregar histórico de cotações.';
    }

    final updatedCache = Map<String, DollarQuote>.from(
      previousState.cachedQuotes,
    );
    if (nextQuote != null) {
      updatedCache[currentCurrency.code] = nextQuote;
    }

    _state = _state.copyWith(
      isLoading: false,
      isHistoryLoading: false,
      quote: nextQuote,
      history: nextHistory,
      selectedCurrency: currentCurrency,
      historyDays: currentHistory,
      cachedQuotes: updatedCache,
      errorMessage: latestError,
      historyErrorMessage: historyError,
    );
    notifyListeners();
  }

  Future<void> selectCurrency(Currency option) async {
    if (option.code == _state.selectedCurrency?.code) {
      return;
    }
    await loadDashboard(currency: option);
  }

  Future<void> selectHistoryRange(int days) async {
    if (days == _state.historyDays) {
      return;
    }
    await loadDashboard(historyDays: days);
  }

  Future<void> refreshCurrencies() async {
    _state = _state.copyWith(
      isCurrencyLoading: true,
      currencyErrorMessage: null,
    );
    notifyListeners();
    try {
      final currencies = await _getSupportedCurrencies();
      final selected = currencies.isNotEmpty ? currencies.first : null;
      _state = _state.copyWith(
        currencies: currencies,
        selectedCurrency: selected,
        isCurrencyLoading: false,
      );
    } on DollarException catch (error) {
      _state = _state.copyWith(
        isCurrencyLoading: false,
        currencyErrorMessage: error.message,
      );
    } catch (_) {
      _state = _state.copyWith(
        isCurrencyLoading: false,
        currencyErrorMessage: 'Erro ao carregar moedas disponíveis.',
      );
    }
    notifyListeners();
  }

  Future<void> _ensureCurrenciesLoaded() async {
    if (_state.currencies.isNotEmpty) {
      return;
    }
    _state = _state.copyWith(
      isCurrencyLoading: true,
      currencyErrorMessage: null,
    );
    notifyListeners();
    try {
      final currencies = await _getSupportedCurrencies();
      final selected = currencies.isNotEmpty ? currencies.first : null;
      _state = _state.copyWith(
        currencies: currencies,
        selectedCurrency: selected,
        isCurrencyLoading: false,
      );
    } on DollarException catch (error) {
      _state = _state.copyWith(
        isCurrencyLoading: false,
        currencyErrorMessage: error.message,
      );
    } catch (_) {
      _state = _state.copyWith(
        isCurrencyLoading: false,
        currencyErrorMessage: 'Erro ao carregar moedas disponíveis.',
      );
    }
    notifyListeners();
  }
}

class DollarQuoteViewState {
  const DollarQuoteViewState({
    required this.isLoading,
    required this.isHistoryLoading,
    required this.isCurrencyLoading,
    this.currencies = const [],
    this.selectedCurrency,
    this.historyDays = 7,
    this.quote,
    this.history = const [],
    this.errorMessage,
    this.historyErrorMessage,
    this.currencyErrorMessage,
    this.cachedQuotes = const {},
  });

  factory DollarQuoteViewState.initial() => const DollarQuoteViewState(
    isLoading: false,
    isHistoryLoading: false,
    isCurrencyLoading: false,
  );

  final bool isLoading;
  final bool isHistoryLoading;
  final bool isCurrencyLoading;
  final List<Currency> currencies;
  final Currency? selectedCurrency;
  final int historyDays;
  final DollarQuote? quote;
  final List<DollarQuote> history;
  final String? errorMessage;
  final String? historyErrorMessage;
  final String? currencyErrorMessage;
  final Map<String, DollarQuote> cachedQuotes;

  bool get hasError => errorMessage != null;
  bool get hasData => quote != null;
  bool get hasHistory => history.isNotEmpty;

  DollarQuoteViewState copyWith({
    bool? isLoading,
    bool? isHistoryLoading,
    bool? isCurrencyLoading,
    List<Currency>? currencies,
    Currency? selectedCurrency,
    int? historyDays,
    DollarQuote? quote,
    List<DollarQuote>? history,
    Map<String, DollarQuote>? cachedQuotes,
    Object? errorMessage = _sentinel,
    Object? historyErrorMessage = _sentinel,
    Object? currencyErrorMessage = _sentinel,
  }) {
    return DollarQuoteViewState(
      isLoading: isLoading ?? this.isLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      isCurrencyLoading: isCurrencyLoading ?? this.isCurrencyLoading,
      currencies: currencies ?? this.currencies,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      historyDays: historyDays ?? this.historyDays,
      quote: quote ?? this.quote,
      history: history ?? this.history,
      cachedQuotes: cachedQuotes ?? this.cachedQuotes,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      historyErrorMessage: identical(historyErrorMessage, _sentinel)
          ? this.historyErrorMessage
          : historyErrorMessage as String?,
      currencyErrorMessage: identical(currencyErrorMessage, _sentinel)
          ? this.currencyErrorMessage
          : currencyErrorMessage as String?,
    );
  }

  static const Object _sentinel = Object();
}

class CurrencyAccent {
  const CurrencyAccent({
    required this.gradient,
    required this.primary,
    required this.onPrimary,
    required this.chartLine,
  });

  final List<Color> gradient;
  final Color primary;
  final Color onPrimary;
  final Color chartLine;

  Color get chartFill => chartLine.withValues(alpha: 0.2);
}
