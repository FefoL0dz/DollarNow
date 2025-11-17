import 'package:flutter/material.dart';

import '../providers/dollar_quote_provider.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({super.key, required this.provider});

  final DollarQuoteProvider provider;

  @override
  Widget build(BuildContext context) {
    final state = provider.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Moeda', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.supportedCurrencies.map((currency) {
            final isSelected = currency.code == state.selectedCurrency.code;
            return ChoiceChip(
              label: Text('${currency.name} (${currency.code})'),
              selected: isSelected,
              onSelected: (_) => provider.selectCurrency(currency),
            );
          }).toList(),
        ),
      ],
    );
  }
}
