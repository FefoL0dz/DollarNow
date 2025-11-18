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

  final Map<String, CurrencyAccent> _currencyAccents = {
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
      primary: Color(0xFFF2A03D),
      onPrimary: Colors.white,
      chartLine: Color(0xFFFFE29C),
    ),
    'JPY': CurrencyAccent(
      gradient: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
      primary: Color(0xFF64B5F6),
      onPrimary: Colors.white,
      chartLine: Color(0xFFC2E9FB),
    ),
  };

  final CurrencyAccent _defaultAccent = CurrencyAccent(
    gradient: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
    primary: const Color(0xFFF06292),
    onPrimary: Colors.white,
    chartLine: const Color(0xFFFFB5E8),
  );

  DollarQuoteViewState _state = DollarQuoteViewState.initial();
  DollarQuoteViewState get state => _state;

  DollarQuote? quoteForCurrency(String code) => _state.cachedQuotes[code];

  CurrencyAccent accentFor(Currency currency) {
    return _currencyAccents[currency.code] ?? _defaultAccent;
  }

  CurrencyAccent accentForCode(String code) {
    return _currencyAccents[code] ?? _defaultAccent;
  }

  CurrencyAccent get currentAccent {
    final currency = _state.selectedCurrency;
    if (currency == null) {
      return _defaultAccent;
    }
    return accentFor(currency);
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
