import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/dollar_quote.dart';
import '../providers/dollar_quote_provider.dart';
import 'error_view.dart';
import 'history_range_selector.dart';
import 'last_update_chip.dart';
import 'loading_view.dart';
import 'quote_history_section.dart';
import 'currency_carousel.dart';
import 'quote_overview.dart';

class DollarQuoteBody extends StatelessWidget {
  const DollarQuoteBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Consumer<DollarQuoteProvider>(
        builder: (context, provider, _) {
          final state = provider.state;

          final selectedCurrency = state.selectedCurrency;
          if (selectedCurrency == null) {
            if (state.isCurrencyLoading) {
              return const LoadingView(message: 'Buscando moedas...');
            }

            if (state.currencyErrorMessage != null) {
              return ErrorView(
                message: state.currencyErrorMessage!,
                onRetry: provider.refreshCurrencies,
              );
            }

            return const SizedBox.shrink();
          }

          if (!state.hasData && state.isLoading) {
            return const LoadingView(message: 'Buscando cotação atual...');
          }

          if (!state.hasData && state.hasError) {
            return ErrorView(
              message: state.errorMessage!,
              onRetry: provider.loadDashboard,
            );
          }

          final quote = state.quote;
          if (quote == null) {
            return const SizedBox.shrink();
          }

          final accent = provider.accentFor(selectedCurrency);

          return RefreshIndicator(
            onRefresh: provider.loadDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.isLoading) const LinearProgressIndicator(),
                  const SizedBox(height: 12),
                  CurrencyCarousel(
                    provider: provider,
                    onRetry: provider.refreshCurrencies,
                  ),
                  const SizedBox(height: 16),
                  HistoryRangeSelector(provider: provider),
                  const SizedBox(height: 16),
                  Text(
                    'Cotação do ${selectedCurrency.name} (${selectedCurrency.code})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  LastUpdateChip(dateTime: quote.quotationTime),
                  const SizedBox(height: 24),
                  QuoteOverview(
                    buyPrice: quote.buyPrice,
                    sellPrice: quote.sellPrice,
                    accent: accent,
                  ),
                  const SizedBox(height: 24),
                  _QuoteSummaryCard(quote: quote, accent: accent),
                  const SizedBox(height: 24),
                  QuoteHistorySection(
                    state: state,
                    onRetry: provider.loadDashboard,
                    accent: accent,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: provider.loadDashboard,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar cotação'),
                    style: FilledButton.styleFrom(
                      backgroundColor: accent.primary,
                      foregroundColor: accent.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (state.hasError) ...[
                    const SizedBox(height: 16),
                    _ErrorBanner(message: state.errorMessage!),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuoteSummaryCard extends StatelessWidget {
  const _QuoteSummaryCard({required this.quote, required this.accent});

  final DollarQuote quote;
  final CurrencyAccent accent;

  @override
  Widget build(BuildContext context) {
    final spread = (quote.sellPrice - quote.buyPrice).abs();
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: accent.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do dia',
              style: theme.textTheme.titleMedium?.copyWith(
                color: accent.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Diferença entre compra e venda: R\$ ${spread.toStringAsFixed(4)}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: accent.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Valor de referência fornecido diretamente pelo Banco Central do Brasil.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: accent.onPrimary.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
