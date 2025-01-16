import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineCharts extends StatefulWidget {
  const LineCharts({
    required this.spots,
    super.key,
    this.gradientColor1,
    this.gradientColor2,
    this.gradientColor3,
    this.indicatorStrokeColor,
  });

  final List<FlSpot> spots; // Accept the spots data
  final Color? gradientColor1;
  final Color? gradientColor2;
  final Color? gradientColor3;
  final Color? indicatorStrokeColor;

  @override
  State<LineCharts> createState() => _LineChartsState();
}

class _LineChartsState extends State<LineCharts> {
  @override
  Widget build(BuildContext context) {
    // Calculate min and max Y dynamically
    final minY = widget.spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = widget.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    // Calculate min and max X dynamically
    final minX = widget.spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final maxX = widget.spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: widget.spots,
            isCurved: true,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  widget.gradientColor1 ?? Colors.cyan.withOpacity(0.4),
                  widget.gradientColor2 ?? Colors.blue.withOpacity(0.4),
                  widget.gradientColor3 ?? Colors.purple.withOpacity(0.4),
                ],
              ),
            ),
            gradient: LinearGradient(
              colors: [
                widget.gradientColor1 ?? Colors.cyan,
                widget.gradientColor2 ?? Colors.blue,
                widget.gradientColor3 ?? Colors.purple,
              ],
            ),
          ),
        ],
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(), // Sequential x-axis labels
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
      ),
    );
  }
}
