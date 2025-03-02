
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' show pow, log, max;
import '../../../core/utils/constants.dart';
import '../../../data/models/candle_data.dart';


// TODO optimize and simplify the representation of the FL Chart
/// A widget that displays a line chart of forex candle data using the FL Chart package.
/// zooming and panning are false, 
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
  final bool _isPanEnabled = false;
  final bool _isScaleEnabled = false;
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
    final double yRange = maxY - minY;

    // Determine fixed number of labels to show on Y axis
    const int numberOfYLabels = 6; // Always show 6 labels

    // Calculate interval between labels
    final double yInterval = yRange / (numberOfYLabels - 1);

    // Round the interval to a nice number
    final double roundedInterval = _roundToNiceNumber(yInterval);

    // Recalculate min and max Y to align with the rounded interval
    double roundedMinY = (minY / roundedInterval).floor() * roundedInterval;
    double roundedMaxY = roundedMinY + roundedInterval * (numberOfYLabels - 1);

    // Ensure the actual data range is within the rounded range
    if (minY < roundedMinY) roundedMinY -= roundedInterval;
    if (maxY > roundedMaxY) roundedMaxY += roundedInterval;

    // Determine decimal places for Y labels
    int decimalPlaces;
    if (roundedInterval < 0.0001) {
      decimalPlaces = 6;
    } else if (roundedInterval < 0.001)
      decimalPlaces = 5;
    else if (roundedInterval < 0.01)
      decimalPlaces = 4;
    else if (roundedInterval < 0.1)
      decimalPlaces = 3;
    else if (roundedInterval < 1)
      decimalPlaces = 2;
    else
      decimalPlaces = 0;

    // Increase spacing between Y-axis labels
    const double leftReservedSize = 80.0;

    // Calculate visible data range
    final int dataLength = widget.data.length;

    // Limit horizontal offset to prevent scrolling too far
    _horizontalOffset =
        _horizontalOffset.clamp(0.0, dataLength - (dataLength / _currentScale));

    // Calculate visible range
    final double visiblePoints = dataLength / _currentScale;
    double minX = _horizontalOffset;
    double maxX = _horizontalOffset + visiblePoints;

    // Ensure maxX doesn't exceed data length
    if (maxX > dataLength) {
      maxX = dataLength.toDouble();
      minX = max(0, maxX - visiblePoints);
    }

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
                // Clamp the offset to prevent scrolling beyond data bounds
                _horizontalOffset = _horizontalOffset.clamp(
                    0.0, dataLength - (dataLength / _currentScale));
              });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(
            right:
                16.0), // Add right padding to prevent chart from touching edge
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
                    final index = barSpot.x.toInt();

                    // Check if index is within bounds
                    if (index < 0 || index >= widget.data.length) {
                      return null;
                    }

                    final date = widget.data[index].date;

                    String formattedDate;
                    if (widget.resolution == '15' ||
                        widget.resolution == '60') {
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
                  interval: roundedInterval, // Use our calculated interval
                  getTitlesWidget: (double value, TitleMeta meta) {
                    // Format the label with appropriate precision
                    final String formattedValue =
                        value.toStringAsFixed(decimalPlaces);

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
                      step = _currentScale < 2.0
                          ? 6
                          : 3; // Every 6 hours or 3 hours
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
                    if (widget.resolution == '15' ||
                        widget.resolution == '60') {
                      // For minute and hour charts, show time
                      label =
                          '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                    } else if (widget.resolution == '240') {
                      // For 4-hour charts, show day and time
                      label = '${date.day}/${date.hour}:00';
                    } else {
            
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
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              horizontalInterval:
                  roundedInterval, // Use our calculated interval for grid lines
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
            minY: roundedMinY,
            maxY: roundedMaxY,
            minX: minX,
            maxX: maxX,
            clipData:
                const FlClipData.all(), // Ensure chart is clipped to its bounds
          ),
        ),
      ),
    );
  }

  // Helper method to round a number to a "nice" value for axis labels
  double _roundToNiceNumber(double value) {
    // Find the magnitude (power of 10) of the value
    final num exponent = (value > 0) ? (log(value) / log(10)).floor() : 0;
    final double power = pow(10, exponent).toDouble();

    // Normalize the value between 1 and 10
    final double normalized = value / power;

    // Round to a nice number (1, 2, 5, 10)
    double niceNormalized;
    if (normalized < 1.5) {
      niceNormalized = 1;
    } else if (normalized < 3)
      niceNormalized = 2;
    else if (normalized < 7)
      niceNormalized = 5;
    else
      niceNormalized = 10;

    // Scale back to the original magnitude
    return niceNormalized * power;
  }

  List<FlSpot> _getChartData() {
    final List<FlSpot> spots = [];
    for (int i = 0; i < widget.data.length; i++) {
      // Use index as x-coordinate and closing price as y-coordinate
      spots.add(FlSpot(i.toDouble(), widget.data[i].close));
    }
    return spots;
  }
}
