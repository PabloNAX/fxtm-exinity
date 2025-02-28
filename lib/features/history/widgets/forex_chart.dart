// widgets/forex_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/candle_data.dart';

class ForexChart extends StatefulWidget {
  final List<CandleData> data;
  final String resolution;

  const ForexChart({
    Key? key,
    required this.data,
    required this.resolution,
  }) : super(key: key);

  @override
  State<ForexChart> createState() => _ForexChartState();
}

class _ForexChartState extends State<ForexChart> {
  bool _isPanEnabled = false;
  bool _isScaleEnabled = false;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  double _horizontalOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    // Calculate min and max Y values
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (var candle in widget.data) {
      if (candle.close < minY) minY = candle.close;
      if (candle.close > maxY) maxY = candle.close;
    }

    // Add padding for better display
    minY = minY - (maxY - minY) * 0.05;
    maxY = maxY + (maxY - minY) * 0.05;

    // Calculate the range of Y values
    double yRange = maxY - minY;

    // Determine how many Y-axis labels to show based on the range
    // For smaller ranges (like in daily/weekly charts), show fewer labels
    int yLabelDivisor;
    if (yRange < 0.01) {
      yLabelDivisor = 100; // Show very few labels for small ranges
    } else if (yRange < 0.05) {
      yLabelDivisor = 50; // Show few labels for medium ranges
    } else if (yRange < 0.1) {
      yLabelDivisor = 20; // Show more labels for larger ranges
    } else {
      yLabelDivisor = 10; // Show most labels for very large ranges
    }

    // Increase spacing between Y-axis labels
    const double leftReservedSize = 80.0;

    return GestureDetector(
      onScaleStart: _isScaleEnabled
          ? (details) {
              _baseScale = _currentScale;
            }
          : null,
      onScaleUpdate: _isScaleEnabled
          ? (details) {
              setState(() {
                _currentScale = (_baseScale * details.scale).clamp(1.0, 10.0);
              });
            }
          : null,
      onHorizontalDragUpdate: _isPanEnabled
          ? (details) {
              setState(() {
                _horizontalOffset += details.delta.dx / _currentScale;
              });
            }
          : null,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _getChartData(),
              dotData: const FlDotData(show: false),
              color: Colors.green,
              barWidth: 1.5,
              shadow: const Shadow(
                color: Colors.green,
                blurRadius: 2,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.2),
                    Colors.green.withOpacity(0.0),
                  ],
                  stops: const [0.5, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchSpotThreshold: 5,
            getTouchLineStart: (_, __) => -double.infinity,
            getTouchLineEnd: (_, __) => double.infinity,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  const FlLine(
                    color: Colors.red,
                    strokeWidth: 1.5,
                    dashArray: [8, 2],
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6,
                        color: Colors.green,
                        strokeWidth: 0,
                        strokeColor: Colors.green,
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final price = barSpot.y;
                  final date = widget.data[barSpot.x.toInt()].date;

                  String formattedDate;
                  if (widget.resolution == '15' || widget.resolution == '60') {
                    formattedDate =
                        '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
                  } else {
                    formattedDate = '${date.day}.${date.month}.${date.year}';
                  }

                  return LineTooltipItem(
                    '',
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: formattedDate,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: '\n${price.toStringAsFixed(5)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              drawBelowEverything: true,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: leftReservedSize,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Dynamic filtering of Y-axis labels based on the range
                  // Convert to integer representation for easier filtering
                  int valueInt = (value * 10000).round();

                  // Only show labels that are divisible by our calculated divisor
                  if (valueInt % yLabelDivisor != 0) {
                    return const SizedBox.shrink();
                  }

                  // Format the label with appropriate precision
                  String formattedValue;
                  if (yRange < 0.01) {
                    // For very small ranges, show more decimal places
                    formattedValue = value.toStringAsFixed(5);
                  } else if (yRange < 0.1) {
                    // For medium ranges
                    formattedValue = value.toStringAsFixed(4);
                  } else {
                    // For larger ranges
                    formattedValue = value.toStringAsFixed(3);
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8, // Add space between text and axis
                    child: Text(
                      formattedValue,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final int index = value.toInt();
                  if (index >= widget.data.length || index < 0) {
                    return const SizedBox.shrink();
                  }

                  // Determine step for displaying labels based on resolution and scale
                  int step;
                  if (widget.resolution == '15') {
                    step = _currentScale < 2.0
                        ? 12
                        : 6; // Every 3 hours or 1.5 hours
                  } else if (widget.resolution == '60') {
                    step =
                        _currentScale < 2.0 ? 6 : 3; // Every 6 hours or 3 hours
                  } else if (widget.resolution == '240') {
                    step = _currentScale < 2.0
                        ? 3
                        : 1; // Every 12 hours or 4 hours
                  } else if (widget.resolution == 'D') {
                    step =
                        _currentScale < 2.0 ? 5 : 2; // Every 5 days or 2 days
                  } else {
                    step = _currentScale < 2.0
                        ? 2
                        : 1; // Every 2 weeks or every week
                  }

                  if (index % step != 0) {
                    return const SizedBox.shrink();
                  }

                  final date = widget.data[index].date;
                  String label;

                  // Format label based on resolution
                  if (widget.resolution == '15' || widget.resolution == '60') {
                    // For minute and hour charts, show time
                    label =
                        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                  } else if (widget.resolution == '240') {
                    // For 4-hour charts, show day and time
                    label = '${date.day}/${date.hour}:00';
                  } else {
                    // For daily and weekly charts, show date
                    final monthNames = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec'
                    ];
                    final monthName = monthNames[date.month - 1];
                    label = '$monthName ${date.day}';
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Transform.rotate(
                      angle: -45 * 3.14 / 180,
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval:
                0.01, // Add this to control horizontal grid lines
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          minY: minY,
          maxY: maxY,
          minX: _horizontalOffset,
          maxX: _horizontalOffset + widget.data.length / _currentScale,
        ),
      ),
    );
  }

  List<FlSpot> _getChartData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.data.length; i++) {
      // Use index as x-coordinate and closing price as y-coordinate
      spots.add(FlSpot(i.toDouble(), widget.data[i].close));
    }
    return spots;
  }
}
