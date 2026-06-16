import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_analytics_view_model.dart';

class SevenSpanDaysListenBarChart extends StatelessWidget {
  final IAnalyticsViewModel analyticsViewModel;

  const SevenSpanDaysListenBarChart({
    super.key,
    required this.analyticsViewModel
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 119, 249, 241),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1),
        ),
        child: SizedBox(
            child: BarChart(
              BarChartData(
                barGroups: _buildBarGroups(),
                titlesData: _buildTitles(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.black,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.black,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = analyticsViewModel.getListens[groupIndex];
                      return BarTooltipItem(
                        '${data.weekDay}, ${data.date}\n${rod.toY.toInt()} Listen/s',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return analyticsViewModel.getListens.asMap().entries.map((entry) {
      final index = entry.key;
      final listen = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: listen.count.toDouble(),
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 18,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }

  FlTitlesData _buildTitles() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTitlesWidget: (value, meta) {
            final day = analyticsViewModel.getListens[value.toInt()].weekDay;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                day,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: 10,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 11, color: Colors.black),
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}