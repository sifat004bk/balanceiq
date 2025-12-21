import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../core/theme/app_palette.dart';
import '../../../domain/entities/chart_data.dart';

class GenUIChart extends StatelessWidget {
  final GraphData data;
  final GraphType type;
  final String? title;

  const GenUIChart({
    super.key,
    required this.data,
    required this.type,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (!data.isValid) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Theme.of(context).cardColor,
                  Theme.of(context).cardColor.withValues(alpha: 0.8),
                ]
              : [
                  Colors.white,
                  Colors.grey.shade50,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 10,
              offset: const Offset(-2, -2),
              spreadRadius: 0,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: type == GraphType.bar
                          ? AppPalette.chartBarColors[0]
                          : AppPalette.chartLineGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
          ],
          SizedBox(
            height: 220,
            child: _buildChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    switch (type) {
      case GraphType.bar:
        return _buildBarChart(context);
      case GraphType.line:
        return _buildLineChart(context);
    }
  }

  Widget _buildBarChart(BuildContext context) {
    final dataset = data.datasets.first;
    final labels = data.labels;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxValue() * 1.25,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => AppPalette.getTooltipColor(isDark),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                tooltipMargin: 12,
                tooltipRoundedRadius: 12,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final label =
                      groupIndex < labels.length ? labels[groupIndex] : '';
                  return BarTooltipItem(
                    '$label\n',
                    TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: _formatNumber(rod.toY),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < labels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          _truncateLabel(labels[value.toInt()]),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getMaxValue() / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(dataset.data.length, (index) {
              if (index >= labels.length) return null;

              final val = dataset.data[index].toDouble();
              final animatedValue = val * animationValue;

              final barColors = AppPalette
                  .chartBarColors[index % AppPalette.chartBarColors.length];

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: animatedValue,
                    gradient: LinearGradient(
                      colors: barColors,
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    width: 22,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: _getMaxValue() * 1.25,
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.15),
                    ),
                  ),
                ],
              );
            }).whereType<BarChartGroupData>().toList(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 400),
          swapAnimationCurve: Curves.easeOutCubic,
        );
      },
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final dataset = data.datasets.first;
    final labels = data.labels;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spots = List.generate(dataset.data.length, (index) {
      return FlSpot(index.toDouble(), dataset.data[index].toDouble());
    });

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, animationValue, child) {
        final animatedSpots = spots.map((spot) {
          return FlSpot(spot.x, spot.y * animationValue);
        }).toList();

        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getMaxValue() / 4,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < labels.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          _truncateLabel(labels[value.toInt()]),
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                  interval: 1,
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: animatedSpots,
                isCurved: true,
                curveSmoothness: 0.35,
                gradient: LinearGradient(
                  colors: AppPalette.chartLineGradient,
                ),
                barWidth: 4,
                isStrokeCapRound: true,
                shadow: Shadow(
                  color:
                      AppPalette.chartLineGradient.first.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeColor: AppPalette.chartLineGradient.first,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppPalette.chartLineGradient.first
                          .withValues(alpha: 0.25),
                      AppPalette.chartLineGradient.last.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) =>
                    AppPalette.getTooltipColor(isDark),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                tooltipRoundedRadius: 12,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final label = spot.x.toInt() < labels.length
                        ? labels[spot.x.toInt()]
                        : '';
                    return LineTooltipItem(
                      '$label\n',
                      TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: _formatNumber(spot.y),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
              touchSpotThreshold: 20,
            ),
          ),
        );
      },
    );
  }

  double _getMaxValue() {
    double max = 0;
    for (var dataset in data.datasets) {
      for (var val in dataset.data) {
        if (val.toDouble() > max) max = val.toDouble();
      }
    }
    if (max == 0) return 10;
    return max;
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }

  String _truncateLabel(String label) {
    if (label.length > 8) {
      return '${label.substring(0, 6)}...';
    }
    return label;
  }
}
