import 'dart:ui';

import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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

    return Container(
      // 1. Outer Container for the Gradient Border
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.4),
            colorScheme.primary.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.5),
        child: BackdropFilter(
          // 2. The Blur Effect
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              // 3. Semi-transparent surface color
              color: colorScheme.surface.withValues(alpha: isDark ? 0.4 : 0.7),
              borderRadius: BorderRadius.circular(22.5),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GetIt.I<DashboardStrings>().spendingTrend,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
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
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              if ([1, 5, 10, 15, 20, 25, 30]
                                  .contains(value.toInt())) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    value.toInt().toString(),
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
                      maxX: 30,
                      minY: 0,
                      maxY: maxAmount * 1.2,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spendingTrend
                              .map((p) => FlSpot(p.day.toDouble(), p.amount))
                              .toList(),
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
                          getTooltipColor: (spot) =>
                              colorScheme.inverseSurface.withValues(alpha: 0.9),
                          tooltipRoundedRadius: 12,
                          getTooltipItems: (touchedSpots) {
                            final currencyCubit = sl<CurrencyCubit>();
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '${currencyCubit.formatAmount(spot.y)}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
