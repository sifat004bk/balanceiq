import 'dart:ui';

import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Sort data by date to ensure chronology
    final sortedTrend = List<SpendingTrendPoint>.from(spendingTrend)
      ..sort((a, b) => a.date.compareTo(b.date));

    // 2. Determine aggregation strategy
    if (sortedTrend.isEmpty) return const SizedBox.shrink();

    final startDate = sortedTrend.first.date;
    final endDate = sortedTrend.last.date;
    final totalDays = endDate.difference(startDate).inDays;

    List<_ChartPoint> aggregatedPoints = [];
    String periodLabel = '';

    if (totalDays <= 35) {
      // Daily: Show all points as is (mapped to dates)
      // Check if we need to fill gaps? For now, let's just plot available data to avoid 0-value noise if not desired.
      aggregatedPoints = sortedTrend.map((e) {
        return _ChartPoint(
          amount: e.amount,
          label: '${_getMonthName(e.date.month)} ${e.date.day}',
          date: e.date,
        );
      }).toList();
      periodLabel = 'Daily';
    } else if (totalDays <= 120) {
      // Weekly: Group by ISO week (roughly)
      // Simple way: Key = "Year-Week"
      Map<String, _ChartPoint> groups = {};
      for (var p in sortedTrend) {
        // Week number calculation (basic)
        final daysSinceEpoch = p.date.difference(DateTime(1970, 1, 1)).inDays;
        final weekNum = (daysSinceEpoch / 7).floor();
        final key = weekNum.toString();

        if (!groups.containsKey(key)) {
          groups[key] =
              _ChartPoint(amount: 0, label: '', date: p.date, count: 0);
        }
        final current = groups[key]!;
        // Update label to be start of week
        final label = '${_getMonthName(p.date.month)} ${p.date.day}';

        // Sum amount
        groups[key] = _ChartPoint(
          amount: current.amount + p.amount,
          label: current.count == 0
              ? label
              : current.label, // Keep first date as label
          date: current.date,
          count: current.count + 1,
        );
      }
      aggregatedPoints = groups.values.toList();
      periodLabel = 'Weekly';
    } else {
      // Monthly: Group by Year-Month
      Map<String, _ChartPoint> groups = {};
      for (var p in sortedTrend) {
        final key = '${p.date.year}-${p.date.month}';
        if (!groups.containsKey(key)) {
          groups[key] = _ChartPoint(
              amount: 0, label: _getMonthName(p.date.month), date: p.date);
        }
        final current = groups[key]!;
        groups[key] = _ChartPoint(
          amount: current.amount + p.amount,
          label: current.label,
          date: current.date,
        );
      }
      aggregatedPoints = groups.values.toList();
      periodLabel = 'Monthly';
    }

    // Double check we have points
    if (aggregatedPoints.isEmpty) return const SizedBox.shrink();

    // Calculate chart stats based on AGGREGATED data
    double totalAmount = 0;
    double maxAmount = 0;

    for (var p in aggregatedPoints) {
      totalAmount += p.amount;
      if (p.amount > maxAmount) maxAmount = p.amount;
    }

    final averageAmount = totalAmount / aggregatedPoints.length;
    final xMax = (aggregatedPoints.length - 1).toDouble(); // 0-based index
    final currencyCubit = sl<CurrencyCubit>();

    return Container(
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
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GetIt.I<DashboardStrings>().spendingTrend,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$periodLabel Avg: ${currencyCubit.formatAmount(averageAmount)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Optional: Add trend indicator here later
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 160,
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
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final intVal = value.toInt();
                                bool showLabel = false;

                                if (xMax <= 31) {
                                  if (xMax < 7) {
                                    showLabel = true;
                                  } else {
                                    for (int i = 0; i < 7; i++) {
                                      final point =
                                          (1 + (i * (xMax - 1) / 6)).round();
                                      if (intVal == point) {
                                        showLabel = true;
                                        break;
                                      }
                                      if (i == 6 && intVal == xMax.toInt())
                                        showLabel = true;
                                    }
                                  }
                                } else if (xMax <= 90) {
                                  if ((intVal - 1) % 7 == 0) showLabel = true;
                                } else {
                                  if ((intVal - 1) % 30 == 0) showLabel = true;
                                }

                                if (showLabel) {
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
                        maxY: maxAmount * 1.3, // More breathing room
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: averageAmount,
                              color:
                                  colorScheme.tertiary.withValues(alpha: 0.5),
                              strokeWidth: 1.5,
                              dashArray: [5, 5],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                padding:
                                    const EdgeInsets.only(right: 5, bottom: 2),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.tertiary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                                labelResolver: (line) => 'Avg',
                              ),
                            ),
                          ],
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spendingTrend
                                .map((p) => FlSpot(p.day.toDouble(), p.amount))
                                .toList(),
                            isCurved: true,
                            curveSmoothness: 0.35,
                            color: colorScheme.primary,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              checkToShowDot: (spot, barData) {
                                // Show dot for max value
                                return spot.y == maxAmount;
                              },
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: colorScheme.surface,
                                  strokeWidth: 2,
                                  strokeColor: colorScheme.primary,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.3),
                                  colorScheme.primary.withValues(alpha: 0.05),
                                  Colors.transparent,
                                ],
                                stops: const [0, 0.7, 1],
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          getTouchedSpotIndicator: (barData, spotIndexes) {
                            return spotIndexes.map((spotIndex) {
                              return TouchedSpotIndicatorData(
                                FlLine(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.5),
                                  strokeWidth: 2,
                                  dashArray: [5, 5],
                                ),
                                FlDotData(
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 6,
                                      color: colorScheme.surface,
                                      strokeWidth: 3,
                                      strokeColor: colorScheme.secondary,
                                    );
                                  },
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (spot) => colorScheme
                                .inverseSurface
                                .withValues(alpha: 0.9),
                            tooltipRoundedRadius: 16,
                            tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            getTooltipItems: (touchedSpots) {
                              // Trigger haptic only once per touch update
                              if (touchedSpots.isNotEmpty) {
                                HapticFeedback.lightImpact();
                              }
                              return touchedSpots.map((spot) {
                                // Find custom tooltip data if available, otherwise just amount
                                // We might want date here but we only have index.
                                // Assuming 'day' matches list index + 1 or similar if sequential?
                                // Actually spendingTrend has 'day' field which might not be index.
                                // But spot.x is 'day'.
                                return LineTooltipItem(
                                  currencyCubit.formatAmount(spot.y),
                                  textTheme.labelLarge!.copyWith(
                                    color: colorScheme.onInverseSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '\nDay ${spot.x.toInt()}', // Can enhance with full date if we pass it down
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onInverseSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
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

  String _getMonthName(int month) {
    const months = [
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
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}

class _ChartPoint {
  final double amount;
  final String label;
  final DateTime date;
  final int count;

  _ChartPoint({
    required this.amount,
    required this.label,
    required this.date,
    this.count = 1,
  });
}
