import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingTrendChart extends StatelessWidget {
  final List<SpendingTrendPoint> spendingTrend;

  const SpendingTrendChart({
    super.key,
    required this.spendingTrend,
  });

  @override
  Widget build(BuildContext context) {
    if (spendingTrend.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final maxAmount = spendingTrend.isEmpty
        ? 100.0
        : spendingTrend.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.dashboard.spendingTrend,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        if (value == 1 ||
                            value == 5 ||
                            value == 10 ||
                            value == 15 ||
                            value == 20 ||
                            value == 25 ||
                            value == 30) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              value.toInt().toString(),
                              style: textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppPalette.neutralGrey
                                    : AppPalette.neutralGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 30,
                minY: 0,
                maxY: maxAmount * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: spendingTrend
                        .map((point) =>
                            FlSpot(point.day.toDouble(), point.amount))
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppPalette.trustBlue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppPalette.trustBlue.withOpacity(0.3),
                          AppPalette.trustBlue.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        AppPalette.trustBlue.withOpacity(0.9),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          'Day ${spot.x.toInt()}\n\$${spot.y.toStringAsFixed(2)}',
                          TextStyle(
                            color: AppPalette.neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
  }
}
