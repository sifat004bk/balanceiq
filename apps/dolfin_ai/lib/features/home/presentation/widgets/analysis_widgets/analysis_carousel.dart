import 'package:flutter/material.dart';

import '../../../domain/entities/dashbaord_summary.dart';
import 'category_bar_chart.dart';
import 'income_expense_pie_chart.dart';
import 'spending_trend_chart.dart';

class AnalysisCarousel extends StatefulWidget {
  final DashboardSummary summary;

  const AnalysisCarousel({
    super.key,
    required this.summary,
  });

  @override
  State<AnalysisCarousel> createState() => _AnalysisCarouselState();
}

class _AnalysisCarouselState extends State<AnalysisCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only show available charts
    final charts = <Widget>[];

    // 1. Spending Trend (Always show if data exists? Or show empty state?)
    // Assuming summary.spendingTrend might be empty but we show it anyway to be consistent
    // if non-empty, use it.
    if (widget.summary.spendingTrend.isNotEmpty) {
      charts
          .add(SpendingTrendChart(spendingTrend: widget.summary.spendingTrend));
    }

    // 2. Pie Chart (If income/expense exists)
    if (widget.summary.totalIncome > 0 || widget.summary.totalExpense > 0) {
      charts.add(IncomeExpensePieChart(
        totalIncome: widget.summary.totalIncome,
        totalExpense: widget.summary.totalExpense,
      ));
    }

    // 3. Bar Chart (If categories exist)
    if (widget.summary.categories.isNotEmpty) {
      charts.add(CategoryBarChart(categories: widget.summary.categories));
    }

    if (charts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 220, // Fixed height for carousel
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: charts.map((chart) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: chart,
              );
            }).toList(),
          ),
        ),
        if (charts.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(charts.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
