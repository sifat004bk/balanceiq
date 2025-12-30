import 'dart:ui';

import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/strings/dashboard_strings.dart';
import '../../../domain/entities/dashbaord_summary.dart'; // Required for ImageFilter
// ... other imports

class SpendingTrendChart extends StatelessWidget {
  final List<SpendingTrendPoint> spendingTrend;

  const SpendingTrendChart({
    super.key,
    required this.spendingTrend,
  });

  @override
  Widget build(BuildContext context) {
    if (spendingTrend.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final maxAmount =
        spendingTrend.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    final xMax = spendingTrend.isNotEmpty ? spendingTrend.length.toDouble() : 30.0;
    
    // Calculate smart interval based on data length
    // If <= 30 days, show every 5 days
    // If > 30 days, calculate interval to show roughly 6-7 labels
    double interval = 5;
    if (xMax > 30) {
      interval = (xMax / 6).ceilToDouble();
    }

    return Container(
      // ... (existing container code)
      child: ClipRRect(
        // ...
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... (Title code remains same)
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: RepaintBoundary(
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: interval,
                              getTitlesWidget: (value, meta) {
                                final intVal = value.toInt();
                                if (intVal == 1 || intVal % interval.toInt() == 0 || intVal == xMax.toInt()) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      intVal.toString(),
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withValues(alpha: 0.8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
                        maxX: xMax,
                        minY: 0,
                        maxY: maxAmount * 1.2,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spendingTrend
                                .map((p) => FlSpot(p.day.toDouble(), p.amount))
                                .toList(),
                            // ... (rest of LineChartBarData)
                            isCurved: true,
                            curveSmoothness: 0.4,
                            color: colorScheme.primary,
                            barWidth: 3.5,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.2),
                                  colorScheme.primary.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (spot) => colorScheme
                                .inverseSurface
                                .withValues(alpha: 0.9),
                            tooltipRoundedRadius: 12,
                            getTooltipItems: (touchedSpots) {
                              final currencyCubit = sl<CurrencyCubit>();
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  currencyCubit.formatAmount(spot.y),
                                  textTheme.labelLarge!.copyWith(
                                    color: colorScheme.onInverseSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
