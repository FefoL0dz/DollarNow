import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuoteValueTile extends StatelessWidget {
  QuoteValueTile({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor,
  }) : _currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  final String label;
  final double value;
  final Color? backgroundColor;
  final NumberFormat _currencyFormatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currencyFormatter.format(value),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
