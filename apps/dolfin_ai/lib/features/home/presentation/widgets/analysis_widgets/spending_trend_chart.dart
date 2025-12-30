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
    } else if (totalDays <= 120) {
      // Weekly: Group by ISO week (roughly)
      // Simple way: Key = "Year-Week"
      Map<String, _ChartPoint> groups = {};
      for (var p in sortedTrend) {
        // W1, W2 format
        // Reset week number relative to start? Or just global week?
        // Let's make it relative to the dataset for "W1, W2" feel
        // Or simpler: "W{index + 1}"
        // But we need to group by actual week first.
        // Let's use the group key index for labeling.

        final daysSinceEpoch = p.date.difference(DateTime(1970, 1, 1)).inDays;
        final weekNum = (daysSinceEpoch / 7).floor();
        final key = weekNum.toString();

        if (!groups.containsKey(key)) {
          // We will fix labels later based on group index in list
          // For now, store a placeholder or the week start date
          groups[key] =
              _ChartPoint(amount: 0, label: '', date: p.date, count: 0);
        }
        final current = groups[key]!;

        groups[key] = _ChartPoint(
          amount: current.amount + p.amount,
          label: '', // Will update
          date: current.date,
          count: current.count + 1,
        );
      }

      // Post-process labels for Weekly to be "W1", "W2"...
      int wIndex = 1;
      aggregatedPoints = groups.values.map((p) {
        // Option 1: W1, W2...
        // Option 2: Jan W1, Jan W2... (More informative)
        // User asked for "w1, w2 or jan, feb".
        // Let's go with "Mmm Wn" if month changes, else "Wn"?
        // Or strictly "W1, W2" as requested.
        // Let's use simple tight "W$wIndex"
        final label = 'W${wIndex++}';
        return _ChartPoint(amount: p.amount, label: label, date: p.date);
      }).toList();
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
          label: current.label, // Month name already set
          date: current.date,
        );
      }
      aggregatedPoints = groups.values.toList();
    }

    // Double check we have points
    if (aggregatedPoints.isEmpty) return const SizedBox.shrink();

    // Determine frequency label
    String frequencyLabel = '';
    if (totalDays <= 35) {
      frequencyLabel = ' (per day)';
    } else if (totalDays <= 120) {
      frequencyLabel = ' (per week)';
    } else {
      frequencyLabel = ' (per month)';
    }

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

    // Calculate visible indices for labels (Prioritize Last)
    final Set<int> visibleIndices = {};
    if (aggregatedPoints.isNotEmpty) {
      if (aggregatedPoints.length <= 7) {
        // Show all
        for (int i = 0; i < aggregatedPoints.length; i++) {
          visibleIndices.add(i);
        }
      } else {
        // Show ~5 labels, prioritizing the last one
        // Step size
        final step = (aggregatedPoints.length / 5).ceil();
        // Always add last
        visibleIndices.add(aggregatedPoints.length - 1);

        // Add others backwards
        for (int i = aggregatedPoints.length - 1 - step; i >= 0; i -= step) {
          visibleIndices.add(i);
        }
      }
    }

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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                        Row(
                          children: [
                            // Legend: Spending
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Spending',
                              style: textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Legend: Average
                            Container(
                              width:
                                  12, // slightly wider for dash effect representation
                              height: 2,
                              color: colorScheme.tertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Avg: ${currencyCubit.formatAmount(averageAmount)}$frequencyLabel',
                              style: textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Optional: Add trend indicator here later
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 ||
                                  index >= aggregatedPoints.length) {
                                return const SizedBox.shrink();
                              }

                              if (visibleIndices.contains(index)) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    aggregatedPoints[index].label,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .hintColor
                                          .withValues(alpha: 0.8),
                                      fontSize: 10,
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
                      minX: 0,
                      maxX: xMax,
                      minY: 0,
                      maxY: maxAmount * 1.05,
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: averageAmount,
                            color: colorScheme.tertiary.withValues(alpha: 0.5),
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
                          spots: aggregatedPoints
                              .asMap()
                              .entries
                              .map((e) =>
                                  FlSpot(e.key.toDouble(), e.value.amount))
                              .toList(),
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: colorScheme.primary,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            checkToShowDot: (spot, barData) {
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
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) =>
                              colorScheme.inverseSurface.withValues(alpha: 0.9),
                          tooltipRoundedRadius: 16,
                          tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          getTooltipItems: (touchedSpots) {
                            if (touchedSpots.isNotEmpty) {
                              HapticFeedback.lightImpact();
                            }
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                currencyCubit.formatAmount(spot.y),
                                textTheme.labelLarge!.copyWith(
                                  color: colorScheme.onInverseSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '\n${aggregatedPoints[spot.x.toInt()].label}',
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
                        getTouchedSpotIndicator: (barData, spotIndexes) {
                          return spotIndexes.map((spotIndex) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.5),
                                strokeWidth: 2,
                                dashArray: [5, 5],
                              ),
                              FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
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
                      ),
                    ),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
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
