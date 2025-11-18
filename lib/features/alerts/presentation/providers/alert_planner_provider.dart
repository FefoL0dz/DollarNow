import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../dollar_quote/domain/entities/currency.dart';
import '../../../dollar_quote/domain/entities/dollar_quote.dart';
import '../../../dollar_quote/domain/usecases/get_latest_dollar_quote.dart';
import '../../../dollar_quote/domain/usecases/get_supported_currencies.dart';
import '../../domain/entities/alert_schedule.dart';
import '../../domain/services/alert_notification_service.dart';
import '../../domain/usecases/create_alert.dart';
import '../../domain/usecases/delete_alert.dart';
import '../../domain/usecases/mark_alert_triggered.dart';
import '../../domain/usecases/toggle_alert.dart';
import '../../domain/usecases/watch_alerts.dart';

class AlertPlannerProvider extends ChangeNotifier {
  AlertPlannerProvider({
    required CreateAlert createAlert,
    required WatchAlerts watchAlerts,
    required ToggleAlert toggleAlert,
    required DeleteAlert deleteAlert,
    required MarkAlertTriggered markTriggered,
    required GetLatestDollarQuote getLatestDollarQuote,
    required GetSupportedCurrencies getSupportedCurrencies,
    required AlertNotificationService notificationService,
  }) : _createAlert = createAlert,
       _watchAlerts = watchAlerts,
       _toggleAlert = toggleAlert,
       _deleteAlert = deleteAlert,
       _markTriggered = markTriggered,
       _getLatestDollarQuote = getLatestDollarQuote,
       _getSupportedCurrencies = getSupportedCurrencies,
       _notificationService = notificationService;

  final CreateAlert _createAlert;
  final WatchAlerts _watchAlerts;
  final ToggleAlert _toggleAlert;
  final DeleteAlert _deleteAlert;
  final MarkAlertTriggered _markTriggered;
  final GetLatestDollarQuote _getLatestDollarQuote;
  final GetSupportedCurrencies _getSupportedCurrencies;
  final AlertNotificationService _notificationService;

  final List<AlertSchedule> _alerts = [];
  List<AlertSchedule> get alerts => List.unmodifiable(_alerts);

  List<Currency> _currencies = [];
  List<Currency> get currencies => List.unmodifiable(_currencies);

  Currency? _selectedCurrency;
  Currency? get selectedCurrency => _selectedCurrency;

  double? _currentPrice;
  double? get currentPrice => _currentPrice;

  double? threshold;
  DateTime startDate = DateTime.now().add(const Duration(hours: 1));
  bool repeatDaily = false;

  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  StreamSubscription<List<AlertSchedule>>? _subscription;
  Timer? _monitor;

  Future<void> initialize() async {
    try {
      _currencies = await _getSupportedCurrencies();
      _selectedCurrency = _currencies.isNotEmpty ? _currencies.first : null;
      await _refreshCurrentPrice();
      threshold = _currentPrice;
      _subscription = _watchAlerts().listen((data) {
        _alerts
          ..clear()
          ..addAll(data);
        notifyListeners();
      });
      _monitor ??= Timer.periodic(const Duration(minutes: 1), (_) {
        _checkAlerts();
      });
    } catch (error, stack) {
      errorMessage = 'Não foi possível carregar os dados do planejador.';
      debugPrint('$error\n$stack');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCurrency(Currency currency) async {
    _selectedCurrency = currency;
    isLoading = true;
    notifyListeners();
    await _refreshCurrentPrice();
    threshold = _currentPrice;
    isLoading = false;
    notifyListeners();
  }

  void updateThreshold(String value) {
    threshold = double.tryParse(value.replaceAll(',', '.')) ?? threshold;
    notifyListeners();
  }

  void updateStartDate(DateTime dateTime) {
    startDate = dateTime;
    notifyListeners();
  }

  void updateRepeatDaily(bool value) {
    repeatDaily = value;
    notifyListeners();
  }

  Future<void> _refreshCurrentPrice() async {
    final currency = _selectedCurrency;
    if (currency == null) {
      _currentPrice = null;
      return;
    }
    try {
      final quote = await _getLatestDollarQuote(
        currencyCode: currency.code,
        currencyName: currency.name,
      );
      _currentPrice = quote.sellPrice;
    } catch (_) {
      _currentPrice = null;
    }
  }

  Future<void> submitAlert() async {
    final currency = _selectedCurrency;
    final price = threshold;
    if (currency == null || price == null || isSubmitting) {
      return;
    }
    isSubmitting = true;
    notifyListeners();

    final alert = AlertSchedule(
      id: _generateId(),
      currencyCode: currency.code,
      currencyName: currency.name,
      threshold: price,
      startDate: startDate,
      repeatDaily: repeatDaily,
      createdAt: DateTime.now(),
      isActive: true,
    );

    try {
      await _createAlert(alert);
      threshold = _currentPrice;
      repeatDaily = false;
      startDate = DateTime.now().add(const Duration(hours: 1));
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> toggleAlertActive(String id, bool isActive) {
    return _toggleAlert(id, isActive);
  }

  Future<void> deleteAlert(String id) {
    return _deleteAlert(id);
  }

  Future<void> _checkAlerts() async {
    if (_alerts.isEmpty) return;

    final now = DateTime.now();
    final Map<String, DollarQuote> quoteCache = {};

    for (final alert in _alerts) {
      if (!alert.isActive) continue;
      if (now.isBefore(alert.startDate)) continue;

      final DateTime? lastTrigger = alert.lastTriggeredAt;
      if (!alert.repeatDaily && lastTrigger != null) {
        continue;
      }
      if (alert.repeatDaily && lastTrigger != null) {
        final nextAllowed = lastTrigger.add(const Duration(days: 1));
        if (now.isBefore(nextAllowed)) {
          continue;
        }
      }

      final quote = await _ensureQuote(
        alert.currencyCode,
        alert.currencyName,
        quoteCache,
      );
      if (quote == null) continue;
      if (quote.sellPrice <= alert.threshold) {
        await _notificationService.showAlertTriggered(alert, quote.sellPrice);
        await _markTriggered(alert.id, now);
      }
    }
  }

  Future<DollarQuote?> _ensureQuote(
    String code,
    String name,
    Map<String, DollarQuote> cache,
  ) async {
    if (cache.containsKey(code)) {
      return cache[code];
    }
    try {
      final quote = await _getLatestDollarQuote(
        currencyCode: code,
        currencyName: name,
      );
      cache[code] = quote;
      return quote;
    } catch (error) {
      debugPrint('Unable to refresh quote for $code: $error');
      return null;
    }
  }

  String _generateId() => Random().nextInt(1 << 30).toString();

  @override
  void dispose() {
    _subscription?.cancel();
    _monitor?.cancel();
    super.dispose();
  }
}
