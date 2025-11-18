import 'package:flutter/material.dart';

import '../providers/dollar_quote_provider.dart';

class HistoryRangeSelector extends StatelessWidget {
  const HistoryRangeSelector({super.key, required this.provider});

  final DollarQuoteProvider provider;

  @override
  Widget build(BuildContext context) {
    final state = provider.state;
    final accent = provider.currentAccent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Período do gráfico',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: provider.supportedHistoryRanges.map((days) {
            final isSelected = days == state.historyDays;
            return ChoiceChip(
              label: Text('$days dias'),
              selected: isSelected,
              onSelected: (_) => provider.selectHistoryRange(days),
              labelStyle: TextStyle(
                color: isSelected ? accent.onPrimary : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
              selectedColor: accent.primary,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: accent.primary.withValues(alpha: 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
