import 'package:flutter/foundation.dart';

import '../../../../core/error/dollar_exception.dart';
import '../../domain/entities/dollar_quote.dart';
import '../../domain/usecases/get_dollar_quote_history.dart';
import '../../domain/usecases/get_latest_dollar_quote.dart';

class DollarQuoteProvider extends ChangeNotifier {
  DollarQuoteProvider({
    required GetLatestDollarQuote getLatestDollarQuote,
    required GetDollarQuoteHistory getDollarQuoteHistory,
  }) : _getLatestDollarQuote = getLatestDollarQuote,
       _getDollarQuoteHistory = getDollarQuoteHistory {
    _state = DollarQuoteViewState.initial(
      selectedCurrency: supportedCurrencies.first,
      historyDays: supportedHistoryRanges.first,
    );
  }

  final GetLatestDollarQuote _getLatestDollarQuote;
  final GetDollarQuoteHistory _getDollarQuoteHistory;

  final List<CurrencyOption> supportedCurrencies = const [
    CurrencyOption(code: 'USD', name: 'Dólar'),
    CurrencyOption(code: 'EUR', name: 'Euro'),
    CurrencyOption(code: 'GBP', name: 'Libra'),
    CurrencyOption(code: 'JPY', name: 'Iene'),
  ];

  final List<int> supportedHistoryRanges = const [7, 15, 30];

  late DollarQuoteViewState _state;
  DollarQuoteViewState get state => _state;

  Future<void> loadDashboard({
    CurrencyOption? currency,
    int? historyDays,
  }) async {
    final currentCurrency = currency ?? _state.selectedCurrency;
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

    _state = _state.copyWith(
      isLoading: false,
      isHistoryLoading: false,
      quote: nextQuote,
      history: nextHistory,
      selectedCurrency: currentCurrency,
      historyDays: currentHistory,
      errorMessage: latestError,
      historyErrorMessage: historyError,
    );
    notifyListeners();
  }

  Future<void> selectCurrency(CurrencyOption option) async {
    if (option.code == _state.selectedCurrency.code) {
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
}

class DollarQuoteViewState {
  const DollarQuoteViewState({
    required this.isLoading,
    required this.isHistoryLoading,
    required this.selectedCurrency,
    required this.historyDays,
    this.quote,
    this.history = const [],
    this.errorMessage,
    this.historyErrorMessage,
  });

  factory DollarQuoteViewState.initial({
    required CurrencyOption selectedCurrency,
    required int historyDays,
  }) => DollarQuoteViewState(
    isLoading: false,
    isHistoryLoading: false,
    selectedCurrency: selectedCurrency,
    historyDays: historyDays,
  );

  final bool isLoading;
  final bool isHistoryLoading;
  final CurrencyOption selectedCurrency;
  final int historyDays;
  final DollarQuote? quote;
  final List<DollarQuote> history;
  final String? errorMessage;
  final String? historyErrorMessage;

  bool get hasError => errorMessage != null;
  bool get hasData => quote != null;
  bool get hasHistory => history.isNotEmpty;

  DollarQuoteViewState copyWith({
    bool? isLoading,
    bool? isHistoryLoading,
    CurrencyOption? selectedCurrency,
    int? historyDays,
    DollarQuote? quote,
    List<DollarQuote>? history,
    Object? errorMessage = _sentinel,
    Object? historyErrorMessage = _sentinel,
  }) {
    return DollarQuoteViewState(
      isLoading: isLoading ?? this.isLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      historyDays: historyDays ?? this.historyDays,
      quote: quote ?? this.quote,
      history: history ?? this.history,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      historyErrorMessage: identical(historyErrorMessage, _sentinel)
          ? this.historyErrorMessage
          : historyErrorMessage as String?,
    );
  }

  static const Object _sentinel = Object();
}

class CurrencyOption {
  const CurrencyOption({required this.code, required this.name});

  final String code;
  final String name;
}
