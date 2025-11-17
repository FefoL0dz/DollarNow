import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dollar_quote.dart';
import '../providers/dollar_quote_provider.dart';
import 'error_view.dart';
import 'loading_view.dart';
import 'quote_history_chart.dart';

class QuoteHistorySection extends StatelessWidget {
  const QuoteHistorySection({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final DollarQuoteViewState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final history = state.history;
    if (state.isHistoryLoading && history.isEmpty) {
      return const LoadingView(message: 'Carregando histórico recente...');
    }

    if (state.historyErrorMessage != null && history.isEmpty) {
      return ErrorView(message: state.historyErrorMessage!, onRetry: onRetry);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico dos últimos ${state.historyDays} dias',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: QuoteHistoryChart(history: history),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Valores em ${state.selectedCurrency.code}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        _VariationRow(history: history),
        if (state.historyErrorMessage != null) ...[
          const SizedBox(height: 12),
          _HistoryWarningBanner(message: state.historyErrorMessage!),
        ],
      ],
    );
  }
}

class _VariationRow extends StatelessWidget {
  const _VariationRow({required this.history});

  final List<DollarQuote> history;

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) {
      return const SizedBox.shrink();
    }

    final latest = history.last;
    final previous = history[history.length - 2];
    final latestMid = _midPrice(latest);
    final previousMid = _midPrice(previous);
    final delta = latestMid - previousMid;
    final percent = (delta / previousMid) * 100;
    final isPositive = delta >= 0;
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${isPositive ? 'Alta' : 'Queda'} de ${formatter.format(delta.abs())} (${percent.toStringAsFixed(2)}%) desde a última cotação.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  double _midPrice(DollarQuote quote) => (quote.buyPrice + quote.sellPrice) / 2;
}

class _HistoryWarningBanner extends StatelessWidget {
  const _HistoryWarningBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
