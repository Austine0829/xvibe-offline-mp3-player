import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_analytics_view_model.dart';

class VibesPercentagesPieChart extends StatelessWidget {
  final IAnalyticsViewModel analyticsViewModel;

  const VibesPercentagesPieChart({
    super.key,
    required this.analyticsViewModel
  });

  static final List<Color> _color = [
    Color.fromARGB(255, 255, 167, 126),
    Color.fromARGB(255, 255, 223, 116),
    Color.fromARGB(255, 217, 255, 114),
    Color.fromARGB(255, 155, 255, 238),
    Color.fromARGB(255, 255, 181, 230),
  ];

  static final Color _textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: SizedBox(
          height: 250,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 232, 155, 255),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white24,
                width: 1
              )
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          ...List.generate(analyticsViewModel.getVibesPercentages.length, (index) {
                            return  PieChartSectionData(
                              value: analyticsViewModel.getVibesPercentages[index].percentage, 
                              color: _color[index], 
                              title: "${analyticsViewModel.getVibesPercentages[index].percentage.toStringAsFixed(1)}%", 
                              titleStyle: TextStyle(color: _textColor)
                            );
                          })
                        ],
                        centerSpaceRadius: 50,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(analyticsViewModel.getVibesPercentages.length, (index) {
                      return  _legendItem(
                        _color[index], 
                        analyticsViewModel.getVibesPercentages[index].vibe, 
                      );
                    })
                  ],
                ),
              ],
            ),
          ) 
        ),
      );
  }
}

Widget _legendItem(Color color, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17),
    child: Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black)),
      ],
    ),
  );
}