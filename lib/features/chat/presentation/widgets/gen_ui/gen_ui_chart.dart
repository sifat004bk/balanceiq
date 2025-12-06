import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/gemini_colors.dart';

class GenUIChart extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data['type'] as String?;
    final title = data['title'] as String?;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GeminiColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
          ],
          SizedBox(
            height: 200,
            child: _buildChart(context, type),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, String? type) {
    switch (type) {
      case 'pie':
        return _buildPieChart(context);
      case 'bar':
        return _buildBarChart(context);
      case 'line':
        return _buildLineChart(context);
      default:
        return Center(child: Text('Unsupported chart type: $type'));
    }
  }

  Widget _buildPieChart(BuildContext context) {
    final chartData = (data['data'] as List).cast<Map<String, dynamic>>();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        return PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                // Add touch feedback for interactivity
              },
            ),
            sections: chartData.asMap().entries.map((entry) {
              final item = entry.value;
              final value = (item['value'] as num).toDouble();
              final animatedValue = value * animationValue;
              final colorHex = item['color'] as String?;
              final color = colorHex != null
                  ? _parseColor(colorHex)
                  : GeminiColors.primaryColor(context);

              return PieChartSectionData(
                color: color,
                value: animatedValue,
                title: '${value.toInt()}',
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                badgeWidget: item['label'] != null
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          item['label'],
                          style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
                badgePositionPercentageOffset: 1.3,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final chartData = (data['data'] as List).cast<Map<String, dynamic>>();
    final useGradient = data['gradient'] == true;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxValue(chartData) * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => Theme.of(context).cardColor,
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    rod.toY.toString(),
                    TextStyle(
                      color: GeminiColors.aiMessageText(context),
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          chartData[value.toInt()]['label'] ?? '',
                          style: TextStyle(
                            fontSize: 10,
                            color: GeminiColors.textSecondary(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getMaxValue(chartData) / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: GeminiColors.divider(context).withOpacity(0.5),
                strokeWidth: 1,
                dashArray: [5, 5],
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: chartData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final targetValue = (item['value'] as num).toDouble();
              final animatedValue = targetValue * animationValue;
              final colorHex = item['color'] as String?;
              final color = colorHex != null
                  ? _parseColor(colorHex)
                  : GeminiColors.primaryColor(context);

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: animatedValue,
                    gradient: useGradient
                        ? LinearGradient(
                            colors: [color.withOpacity(0.6), color],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          )
                        : null,
                    color: useGradient ? null : color,
                    width: 18,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: _getMaxValue(chartData) * 1.2,
                      color: GeminiColors.divider(context).withOpacity(0.2),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 600),
          swapAnimationCurve: Curves.easeOutCubic,
        );
      },
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final chartData = (data['data'] as List).cast<Map<String, dynamic>>();
    
    // Assuming simple line chart where x is index
    final spots = chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final value = (item['value'] as num).toDouble();
      return FlSpot(index.toDouble(), value);
    }).toList();

    final primaryColor = GeminiColors.primaryColor(context);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: _getMaxValue(chartData) / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: GeminiColors.divider(context).withOpacity(0.5),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      chartData[value.toInt()]['label'] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        color: GeminiColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              interval: 1,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Theme.of(context).cardColor,
                  strokeWidth: 2,
                  strokeColor: primaryColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true, 
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.3),
                  primaryColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Theme.of(context).cardColor,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toString(),
                  TextStyle(
                    color: GeminiColors.aiMessageText(context),
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  double _getMaxValue(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var item in data) {
      final val = (item['value'] as num).toDouble();
      if (val > max) max = val;
    }
    return max;
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }
}
