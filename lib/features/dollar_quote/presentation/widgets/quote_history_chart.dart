import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/dollar_quote.dart';

class QuoteHistoryChart extends StatelessWidget {
  QuoteHistoryChart({super.key, required this.history})
    : _dateFormatter = DateFormat('dd/MM');

  final List<DollarQuote> history;
  final DateFormat _dateFormatter;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    final prices = history.map((quote) => quote.sellPrice).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);
    final spots = history
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.sellPrice))
        .toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (history.length - 1).toDouble(),
        minY: minPrice * 0.995,
        maxY: maxPrice * 1.005,
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final index = value.round();
                if (index < 0 || index >= history.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _dateFormatter.format(history[index].quotationTime),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
