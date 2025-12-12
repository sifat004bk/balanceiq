import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_state.dart';
import 'package:balance_iq/features/home/presentation/widgets/accounts_breakdown_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/balance_card_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/biggest_expense_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/category_breakdown_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/dashboard_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubit/dashboard_cubit.dart';
import '../cubit/transactions_cubit.dart';
import '../widgets/chat_input_button.dart';
import '../widgets/financial_ratio_widget.dart';
import '../widgets/home_appbar.dart';
import '../widgets/spending_trend_chart.dart';
import '../widgets/transaction_history_widget.dart';
import 'error_page.dart';
import 'welcome_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TransactionsCubit>()..loadTransactions(limit: 5),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String _userName = 'User';
  String? _profileUrl;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadUser();
    // We don't need to call _loadDashboard here for initial load because:
    // 1. DashboardCubit is loaded in main.dart or previous session? No, init in main doesn't load.
    //    We should check if we need to load it.
    // 2. TransactionsCubit is loaded in create.
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
    String? startDateStr;
    String? endDateStr;

    if (_startDate != null && _endDate != null) {
      startDateStr = DateFormat('yyyy-MM-dd').format(_startDate!);
      endDateStr = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    context.read<DashboardCubit>().loadDashboard(
          startDate: startDateStr,
          endDate: endDateStr,
        );
    
    // Now this works because context is under BlocProvider
    context.read<TransactionsCubit>().loadTransactions(
      limit: 5,
      startDate: startDateStr,
      endDate: endDateStr,
    );
  }

  Future<void> _refreshDashboard() async {
    String? startDateStr;
    String? endDateStr;

    if (_startDate != null && _endDate != null) {
      startDateStr = DateFormat('yyyy-MM-dd').format(_startDate!);
      endDateStr = DateFormat('yyyy-MM-dd').format(_endDate!);
    }

    final dashboardFuture = context.read<DashboardCubit>().refreshDashboard(
          startDate: startDateStr,
          endDate: endDateStr,
        );
        
    final transactionsFuture = context.read<TransactionsCubit>().loadTransactions(
      limit: 5,
      startDate: startDateStr,
      endDate: endDateStr,
    );

    await Future.wait([dashboardFuture, transactionsFuture]);
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  surface: Theme.of(context).scaffoldBackgroundColor,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
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

            // Check if error is authentication-related
            final isAuthError = state.message.toLowerCase().contains('unauthorized') ||
                state.message.toLowerCase().contains('unauthenticated') ||
                state.message.toLowerCase().contains('token') ||
                state.message.toLowerCase().contains('login');

            return Error404Page(
              errorMessage: state.message,
              isAuthError: isAuthError,
              onRetry: isAuthError
                  ? () {
                      // Navigate to login page
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  : _loadDashboard,
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
                  HomeAppbar(
                    summary: summary,
                    onTapProfileIcon: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    profileUrl: _profileUrl ?? '',
                    onTapDateRange: _selectDateRange,
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
                              if (summary.categories.isNotEmpty)
                                CategoryBreakdownWidget(
                                  categories: summary.categories,
                                ),
                              const SizedBox(height: 16),
                              TransactionHistoryWidget(
                                onViewAll: () => Navigator.pushNamed(context, '/transactions'),
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
      bottomSheet: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (previous, current) => current is DashboardLoaded,
        builder: (context, state) {
          if (state is DashboardLoaded) {
            return Hero(
              tag: 'chat_input',
              child: ChatInputButton(),
            );
          }

          return SizedBox.shrink();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
