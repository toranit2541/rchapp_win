import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    if (widget.spots.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Calculate min and max Y dynamically
    final minY = widget.spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = widget.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    // Calculate min and max X dynamically
    final minX = widget.spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final maxX = widget.spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);

    final gradientColors = [
      widget.gradientColor1 ?? Colors.cyan,
      widget.gradientColor2 ?? Colors.blue,
      widget.gradientColor3 ?? Colors.purple,
    ];

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
              gradient: LinearGradient(colors: gradientColors),
            ),
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingVerticalLine: (value) => FlLine(color: Colors.grey, strokeWidth: 1),
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey, strokeWidth: 1),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Transform.rotate(
                  angle: -90 * 3.1415926535897932 / 180, // Convert degrees to radians
                  child: Text(
                    DateFormat('MM/yyyy').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return LineTooltipItem(
                  '${DateFormat('MM/yyyy').format(date)}\n${spot.y.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

// class _LineChartsState extends State<LineCharts> {
//   @override
//   Widget build(BuildContext context) {
//     // Calculate min and max Y dynamically
//     final minY = widget.spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
//     final maxY = widget.spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
//
//     // Calculate min and max X dynamically
//     final minX = widget.spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
//     final maxX = widget.spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
//
//     return LineChart(
//       LineChartData(
//         minX: minX,
//         maxX: maxX,
//         minY: minY,
//         maxY: maxY,
//         lineBarsData: [
//           LineChartBarData(
//             spots: widget.spots,
//             isCurved: true,
//             barWidth: 4,
//             belowBarData: BarAreaData(
//               show: true,
//               gradient: LinearGradient(
//                 colors: [
//                   widget.gradientColor1 ?? Colors.cyan,
//                   widget.gradientColor2 ?? Colors.blue,
//                   widget.gradientColor3 ?? Colors.purple,
//                 ],
//               ),
//             ),
//             gradient: LinearGradient(
//               colors: [
//                 widget.gradientColor1 ?? Colors.cyan,
//                 widget.gradientColor2 ?? Colors.blue,
//                 widget.gradientColor3 ?? Colors.purple,
//               ],
//             ),
//           ),
//         ],
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: true,
//           drawHorizontalLine: true,
//           getDrawingVerticalLine: (value) {
//             return FlLine(color: Colors.grey, strokeWidth: 1);
//           },
//           getDrawingHorizontalLine: (value) {
//             return FlLine(color: Colors.grey, strokeWidth: 1);
//           },
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(color: Colors.grey, width: 1),
//         ),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 32,
//               getTitlesWidget: (value, meta) {
//                 final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//                 return Transform.rotate(
//                   angle: -90 *
//                       3.1415926535897932 /
//                       180, // Convert degrees to radians
//                   child: Text(
//                     DateFormat('MM/yyyy').format(date),
//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 );
//               },
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 28,
//               getTitlesWidget: (value, meta) {
//                 return Text(
//                   value.toStringAsFixed(0),
//                   style: const TextStyle(fontSize: 10),
//                 );
//               },
//             ),
//           ),
//         ),
//         lineTouchData: LineTouchData(
//           touchTooltipData: LineTouchTooltipData(
//             // ignore: deprecated_member_use
//             getTooltipItems: (touchedSpots) {
//               return touchedSpots.map((spot) {
//                 final date =
//                     DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
//                 return LineTooltipItem(
//                   '${DateFormat('MM/yyyy').format(date)}\n${spot.y.toStringAsFixed(2)}',
//                   const TextStyle(color: Colors.white),
//                 );
//               }).toList();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
