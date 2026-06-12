import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:dollar_now/date_time_utils.dart';
import 'package:dollar_now/model/cotacao_dolar.dart';
import 'package:dollar_now/service/olinda_service.dart';

class DollarHistoricalChart extends StatefulWidget {
  @override
  _DollarHistoricalChartState createState() => _DollarHistoricalChartState();
}

class _DollarHistoricalChartState extends State<DollarHistoricalChart> {
  late Future<List<CotacaoDolar>> _historicalDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchHistoricalData();
  }

  void _fetchHistoricalData() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    
    _historicalDataFuture = OlindaService().fetchCotacaoDolarPeriodo(
      dataInicial: DateTimeUtils.usFormat(weekAgo),
      dataFinalCotacao: DateTimeUtils.usFormat(now),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CotacaoDolar>>(
      future: _historicalDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.green));
        } else if (snapshot.hasError) {
          return Center(child: Text('Falha ao carregar histórico', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Sem dados históricos para este período.'));
        }

        final data = snapshot.data!;
        // Sort data chronologically just in case the API doesn't
        data.sort((a, b) => a.dataHoraCotacao!.compareTo(b.dataHoraCotacao!));

        List<FlSpot> spots = [];
        double minY = double.infinity;
        double maxY = double.negativeInfinity;

        for (int i = 0; i < data.length; i++) {
          final price = data[i].cotacaoVenda ?? 0.0;
          spots.add(FlSpot(i.toDouble(), price));
          if (price < minY) minY = price;
          if (price > maxY) maxY = price;
        }

        // Add padding to Y axis limits to make chart look better
        minY = minY - 0.05;
        maxY = maxY + 0.05;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            gradient: LinearGradient(
              colors: [
                Color(0xff2c274c),
                Color(0xff46426c),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Tendência do Dólar (7 Dias)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 0.05,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(color: Colors.white10, strokeWidth: 1);
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(color: Colors.white10, strokeWidth: 1);
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < 0 || value.toInt() >= data.length) return SizedBox();
                            final date = data[value.toInt()].dataHoraCotacao;
                            if (date == null) return SizedBox();
                            // Only show every other day to avoid crowding
                            if (value.toInt() % 2 != 0 && data.length > 4) return SizedBox();
                            final formatted = '${date.day}/${date.month}';
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(formatted, style: TextStyle(color: Colors.white70, fontSize: 12)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.05,
                          getTitlesWidget: (value, meta) {
                            return Text('R\$${value.toStringAsFixed(2)}', style: TextStyle(color: Colors.white70, fontSize: 12));
                          },
                          reservedSize: 42,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white10, width: 1),
                    ),
                    minX: 0,
                    maxX: (data.length - 1).toDouble(),
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.greenAccent,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.greenAccent.withAlpha(50),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            return LineTooltipItem(
                              'R\$ ${touchedSpot.y.toStringAsFixed(3)}',
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
