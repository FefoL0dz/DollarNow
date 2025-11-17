import 'package:flutter/material.dart';

import 'quote_value_tile.dart';

class QuoteOverview extends StatelessWidget {
  const QuoteOverview({
    super.key,
    required this.buyPrice,
    required this.sellPrice,
  });

  final double buyPrice;
  final double sellPrice;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 480;
        final children = [
          QuoteValueTile(label: 'Compra', value: buyPrice),
          QuoteValueTile(
            label: 'Venda',
            value: sellPrice,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
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
