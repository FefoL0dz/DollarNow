import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/currency.dart';
import '../providers/dollar_quote_provider.dart';
import 'error_view.dart';
import 'loading_view.dart';

class CurrencyCarousel extends StatefulWidget {
  const CurrencyCarousel({
    super.key,
    required this.provider,
    required this.onRetry,
  });

  final DollarQuoteProvider provider;
  final VoidCallback onRetry;

  @override
  State<CurrencyCarousel> createState() => _CurrencyCarouselState();
}

class _CurrencyCarouselState extends State<CurrencyCarousel> {
  late PageController _controller;
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  bool _isInternalChange = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.82);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncInitialPage();
  }

  @override
  void didUpdateWidget(covariant CurrencyCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncInitialPage();
  }

  void _syncInitialPage() {
    final currencies = widget.provider.state.currencies;
    final selected = widget.provider.state.selectedCurrency;
    if (selected == null) {
      return;
    }
    final index = currencies.indexWhere(
      (currency) => currency.code == selected.code,
    );
    if (index != -1 && index != _currentIndex && _controller.hasClients) {
      _isInternalChange = true;
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      _currentIndex = index;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.provider.state;
    if (state.isCurrencyLoading && state.currencies.isEmpty) {
      return const LoadingView(message: 'Buscando moedas disponíveis...');
    }

    if (state.currencyErrorMessage != null && state.currencies.isEmpty) {
      return ErrorView(
        message: state.currencyErrorMessage!,
        onRetry: widget.onRetry,
      );
    }

    final currencies = state.currencies;
    if (currencies.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: _controller,
        itemCount: currencies.length,
        onPageChanged: (index) {
          _currentIndex = index;
          if (_isInternalChange) {
            _isInternalChange = false;
            return;
          }
          widget.provider.selectCurrency(currencies[index]);
        },
        itemBuilder: (context, index) {
          final currency = currencies[index];
          final accent = widget.provider.accentFor(currency);
          final isSelected = currency.code == state.selectedCurrency?.code;
          final quote =
              widget.provider.quoteForCurrency(currency.code) ??
              (isSelected ? state.quote : null);
          return AnimatedScale(
            duration: const Duration(milliseconds: 250),
            scale: isSelected ? 1 : 0.94,
            child: GestureDetector(
              onTap: () => widget.provider.selectCurrency(currency),
              child: _CurrencyCard(
                currency: currency,
                isSelected: isSelected,
                accent: accent,
                quoteText: quote != null
                    ? _currencyFormatter.format(quote.sellPrice)
                    : 'Toque para carregar',
                lastUpdated: quote?.quotationTime,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.currency,
    required this.isSelected,
    required this.accent,
    required this.quoteText,
    this.lastUpdated,
  });

  final Currency currency;
  final bool isSelected;
  final CurrencyAccent accent;
  final String quoteText;
  final DateTime? lastUpdated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: accent.gradient.length == 1
              ? [accent.gradient.first, accent.gradient.first]
              : accent.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.gradient.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accent.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currency.code,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: accent.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle,
                  color: accent.onPrimary,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quoteText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: accent.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (lastUpdated != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Atualizado em ${DateFormat('dd/MM HH:mm').format(lastUpdated!)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: accent.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
