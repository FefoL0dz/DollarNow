import 'package:flutter/material.dart';

import '../providers/dollar_quote_provider.dart';
import 'quote_value_tile.dart';

class QuoteOverview extends StatelessWidget {
  const QuoteOverview({
    super.key,
    required this.buyPrice,
    required this.sellPrice,
    required this.accent,
  });

  final double buyPrice;
  final double sellPrice;
  final CurrencyAccent accent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 480;
        final gradient = LinearGradient(
          colors: accent.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        final children = [
          QuoteValueTile(
            label: 'Compra',
            value: buyPrice,
            backgroundGradient: gradient,
            labelColor: accent.onPrimary.withValues(alpha: 0.85),
            valueColor: accent.onPrimary,
          ),
          QuoteValueTile(
            label: 'Venda',
            value: sellPrice,
            backgroundColor: accent.primary.withValues(alpha: 0.15),
            labelColor: accent.primary,
          ),
        ];

        if (isWide) {
          return Row(
            children: [
              Expanded(child: children[0]),
              const SizedBox(width: 16),
              Expanded(child: children[1]),
            ],
          );
        }

        return Column(
          children: [children[0], const SizedBox(height: 16), children[1]],
        );
      },
    );
  }
}
