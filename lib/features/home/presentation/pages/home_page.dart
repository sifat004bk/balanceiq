import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:balance_iq/features/chat/presentation/pages/chat_page.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_state.dart';
import 'package:balance_iq/features/home/presentation/pages/error_page.dart';
import 'package:balance_iq/features/home/presentation/widgets/accounts_breakdown_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/balance_card_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/biggest_category_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/biggest_expense_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/dashboard_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/dashboard_cubit.dart';
import '../widgets/financial_ratio_widget.dart';
import '../widgets/home_appbar.dart';
import '../widgets/spending_trend_chart.dart';
import 'welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'User';
  String? _profileUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadDashboard();
  }

  Future<void> _loadUser() async {
    final authLocalDataSource = sl<AuthLocalDataSource>();
    final cachedUser = await authLocalDataSource.getCachedUser();

    if (cachedUser != null) {
      setState(() {
        _userName = cachedUser.name;
        _profileUrl = cachedUser.photoUrl;
      });
    }
  }

  void _loadDashboard() {
    context.read<DashboardCubit>().loadDashboard();
  }

  Future<void> _refreshDashboard() async {
    await context.read<DashboardCubit>().refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const DashboardShimmer();
          }

          if (state is DashboardError) {
            if (state.message.contains('No dashboard data')) {
              return WelcomePage(
                userName: _userName,
                onGetStarted: _loadDashboard,
              );
            }
            return Error404Page(
              errorMessage: state.message,
              onRetry: _loadDashboard,
            );
          }

          if (state is DashboardLoaded) {
            final summary = state.summary;

            return RefreshIndicator(
              onRefresh: _refreshDashboard,
              color: AppTheme.primaryColor,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.2),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // --- Animated AppBar ---
                  // TODO: Add onTaps
                  HomeAppbar(
                    summary: summary,
                    onTapProfileIcon: () {},
                    onTapNotificationIcon: () {},
                    profileUrl: _profileUrl ?? '',
                  ),

                  // --- Dashboard Body ---
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Balance Card
                        BalanceCard(
                          netBalance: summary.netBalance,
                          totalIncome: summary.totalIncome,
                          totalExpense: summary.totalExpense,
                          period: summary.period,
                        ),
                        const SizedBox(height: 24),

                        // Spending Trend Chart
                        if (summary.spendingTrend.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SpendingTrendChart(
                              spendingTrend: summary.spendingTrend,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Financial Ratios
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: FinancialRatiosWidget(
                            expenseRatio: summary.expenseRatio,
                            savingsRate: summary.savingsRate,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Accounts Breakdown
                        if (summary.accountsBreakdown.isNotEmpty) ...[
                          AccountsBreakdownWidget(
                            accountsBreakdown: summary.accountsBreakdown,
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Biggest Expense & Category
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              BiggestExpenseWidget(
                                amount: summary.biggestExpenseAmount,
                                description: summary.biggestExpenseDescription,
                                category: summary.expenseCategory,
                                account: summary.expenseAccount,
                              ),
                              const SizedBox(height: 16),
                              BiggestCategoryWidget(
                                categoryName: summary.biggestCategoryName,
                                amount: summary.biggestCategoryAmount,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatPage(
                    botId: "nai kichu",
                    botName: 'BalanceIq',
                  ),
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: isDark ? AppTheme.textDark : AppTheme.backgroundDark,
              size: 36,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
