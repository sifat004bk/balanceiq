import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../domain/entities/dashbaord_summary.dart';
import 'analysis_widgets/accounts_breakdown_widget.dart';
import 'analysis_widgets/analysis_carousel.dart';
import 'analysis_widgets/category_breakdown_widget.dart';
import 'analysis_widgets/spending_trend_chart.dart';
import 'dashboard_widgets/balance_card_widget.dart';
import 'dashboard_widgets/biggest_expense_widget.dart';
import 'dashboard_widgets/biggest_income_widget.dart';
import 'dashboard_widgets/financial_ratio_widget.dart';
import 'dashboard_widgets/floating_chat_button.dart';
import 'dashboard_widgets/home_appbar.dart';
import 'dashboard_widgets/transaction_history_widget.dart';

class DashboardLayout extends StatelessWidget {
  final DashboardSummary summary;
  final Future<void> Function() onRefresh;
  final VoidCallback onTapProfileIcon;
  final VoidCallback onTapDateRange;
  final VoidCallback? onChatReturn;
  final String profileUrl;
  final String userName;
  final String displayDate;
  final GlobalKey? profileIconKey;

  const DashboardLayout({
    super.key,
    required this.summary,
    required this.onRefresh,
    required this.onTapProfileIcon,
    required this.onTapDateRange,
    this.onChatReturn,
    required this.profileUrl,
    required this.userName,
    required this.displayDate,
    this.profileIconKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LiquidPullToRefresh(
          onRefresh: onRefresh,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // --- Animated AppBar ---
              HomeAppbar(
                summary: summary,
                onTapProfileIcon: onTapProfileIcon,
                profileUrl: profileUrl,
                userName: userName,
                displayDate: displayDate,
                onTapDateRange: onTapDateRange,
                profileIconKey: profileIconKey,
              ),

              // --- Dashboard Body ---
              SliverToBoxAdapter(
                child: const SizedBox(height: 8),
              ),

              // Balance Card
              SliverToBoxAdapter(
                child: BalanceCard(
                  netBalance: summary.netBalance,
                  totalIncome: summary.totalIncome,
                  totalExpense: summary.totalExpense,
                  period: summary.period,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, curve: Curves.easeOutCubic)
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 16),
              ),

              // Analysis Carousel
              if (summary.spendingTrend.isNotEmpty ||
                  summary.categories.isNotEmpty ||
                  (summary.totalIncome > 0 || summary.totalExpense > 0)) ...[
                SliverToBoxAdapter(
                  child: AnalysisCarousel(
                    summary: summary,
                  )
                      .animate()
                      .fadeIn(
                        delay: 150.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .scaleXY(
                        begin: 0.95,
                        end: 1,
                        delay: 150.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 16),
                ),
              ],

              // Financial Ratios
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FinancialRatiosWidget(
                    expenseRatio: summary.expenseRatio,
                    savingsRate: summary.savingsRate,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: 250.ms,
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .slideX(
                      begin: -0.05,
                      end: 0,
                      delay: 250.ms,
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 16),
              ),

              // Accounts Breakdown
              if (summary.accountsBreakdown.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: AccountsBreakdownWidget(
                    accountsBreakdown: summary.accountsBreakdown,
                  )
                      .animate()
                      .fadeIn(
                        delay: 350.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        delay: 350.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 16),
                ),
              ],

              // Biggest Income & Expense (Grouped for layout coherence)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      BiggestIncomeWidget(
                        amount: summary.biggestIncomeAmount,
                        description: summary.biggestIncomeDescription,
                      )
                          .animate()
                          .fadeIn(
                            delay: 450.ms,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .slideX(
                            begin: 0.05,
                            end: 0,
                            delay: 450.ms,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      if (summary.biggestIncomeAmount > 0)
                        const SizedBox(height: 16),
                      BiggestExpenseWidget(
                        amount: summary.biggestExpenseAmount,
                        description: summary.biggestExpenseDescription,
                        category: summary.expenseCategory,
                        account: summary.expenseAccount,
                      )
                          .animate()
                          .fadeIn(
                            delay: 550.ms,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                          )
                          .slideX(
                            begin: -0.05,
                            end: 0,
                            delay: 550.ms,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                          ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: const SizedBox(height: 16),
              ),

              // Category Breakdown
              if (summary.categories.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategoryBreakdownWidget(
                      categories: summary.categories,
                    )
                        .animate()
                        .fadeIn(
                          delay: 650.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .slideY(
                          begin: 0.05,
                          end: 0,
                          delay: 650.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 16),
                ),
              ],

              // Transaction History
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120), // Bottom spacer
                  child: TransactionHistoryWidget(
                    onViewAll: () =>
                        Navigator.pushNamed(context, '/transactions'),
                  )
                      .animate()
                      .fadeIn(
                        delay: 750.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      )
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        delay: 750.ms,
                        duration: 500.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ),
              ),
            ],
          ),
        ),
        // Positioned chat button at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Hero(
            tag: 'chat_input',
            child: FloatingChatButton(onReturn: onChatReturn),
          ),
        ),
      ],
    );
  }
}
