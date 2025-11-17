import 'package:flutter/material.dart';

import '../providers/dollar_quote_provider.dart';

class HistoryRangeSelector extends StatelessWidget {
  const HistoryRangeSelector({super.key, required this.provider});

  final DollarQuoteProvider provider;

  @override
  Widget build(BuildContext context) {
    final state = provider.state;
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
            );
          }).toList(),
        ),
      ],
    );
  }
}
