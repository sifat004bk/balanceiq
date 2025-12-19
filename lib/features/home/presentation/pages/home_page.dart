import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/tour/tour.dart';
import 'package:balance_iq/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_state.dart';
import 'package:balance_iq/features/home/presentation/widgets/accounts_breakdown_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/balance_card_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/biggest_expense_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/category_breakdown_widget.dart';
import 'package:balance_iq/features/home/presentation/widgets/dashboard_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/transactions_cubit.dart';
import '../widgets/biggest_income_widget.dart';
import '../widgets/date_selector_bottom_sheet.dart';
import '../widgets/floating_chat_button.dart';
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
  bool _tourCheckDone = false;

  // Tour related
  final GlobalKey _profileIconKey = GlobalKey();
  TutorialCoachMark? _tutorialCoachMark;
  bool _tourShown = false;

  @override
  void initState() {
    super.initState();

    // Check initial dashboard state for tour
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialDashboardState();
    });

    _loadUser();

    // Initialize with current month's date range
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate =
        DateTime(now.year, now.month + 1, 0); // Last day of current month

    _loadDashboard();
  }

  @override
  void dispose() {
    _tutorialCoachMark?.finish();
    super.dispose();
  }

  void _showProfileIconTour() {
    if (_tourShown) return;

    // Ensure key is attached
    if (_profileIconKey.currentContext == null) {
      // Retry after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showProfileIconTour();
      });
      return;
    }

    _tourShown = true;
    final tourCubit = context.read<ProductTourCubit>();

    final targets = [
      TargetFocus(
        identify: 'profile_icon',
        keyTarget: _profileIconKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: false,
        enableTargetTab: true,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TourTooltipContent(
                icon: Icons.person_outline_rounded,
                title: AppStrings.dashboard.completeProfile,
                description: AppStrings.dashboard.verifyEmailSetup,
                buttonText: 'Got it',
                onButtonPressed: () {
                  controller.next();
                },
                showSkip: true,
                onSkip: () {
                  tourCubit.skipTour();
                  controller.skip();
                },
              );
            },
          ),
        ],
      ),
    ];

    _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.8,
      hideSkip: true,
      onClickOverlay: (target) {
        // Prevent dismissal on overlay click
      },
      onClickTarget: (target) {
        // User tapped on the profile icon
        tourCubit.onProfileIconTapped();
        Navigator.pushNamed(context, '/profile');
      },
      onFinish: () {
        // Tour step completed, navigate to profile
        tourCubit.onProfileIconTapped();
        Navigator.pushNamed(context, '/profile');
      },
      onSkip: () {
        tourCubit.skipTour();
        return true;
      },
    );

    _tutorialCoachMark!.show(context: context);
  }

  void _checkInitialDashboardState() {
    final state = context.read<DashboardCubit>().state;
    if (state is DashboardLoaded && !_tourCheckDone) {
      _tourCheckDone = true;
      final isOnboarded = state.summary.onboarded;

      final tourCubit = context.read<ProductTourCubit>();
      tourCubit.checkAndStartTourIfNeeded(isOnboarded: isOnboarded);

      // If tour is started, show the tooltip
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && tourCubit.isAtStep(TourStep.dashboardProfileIcon)) {
          _showProfileIconTour();
        }
      });
    }
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

    final transactionsFuture =
        context.read<TransactionsCubit>().loadTransactions(
              limit: 5,
              startDate: startDateStr,
              endDate: endDateStr,
            );

    await Future.wait([dashboardFuture, transactionsFuture]);
  }

  void _selectDateRange() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateSelectorBottomSheet(
        onDateSelected: (start, end) {
          setState(() {
            _startDate = start;
            _endDate = end;
          });
          _loadDashboard();
        },
      ),
    );
  }

  String _getFormattedDateRange() {
    if (_startDate == null || _endDate == null) return 'Select Date';

    final start = _startDate!;
    final end = _endDate!;
    final now = DateTime.now();

    // Check if it's the current month fully selected
    if (start.year == now.year &&
        start.month == now.month &&
        start.day == 1 &&
        end.month == now.month &&
        end.day == DateTime(now.year, now.month + 1, 0).day) {
      return DateFormat('MMMM yyyy').format(start);
    }

    // Check if it's any full month
    if (start.day == 1 &&
        end.year == start.year &&
        end.month == start.month &&
        end.day == DateTime(start.year, start.month + 1, 0).day) {
      return DateFormat('MMMM yyyy').format(start);
    }

    // Same year
    if (start.year == end.year) {
      if (start.month == end.month) {
        return '${DateFormat('MMM d').format(start)} - ${DateFormat('d, yyyy').format(end)}';
      }
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
    }

    // Different years
    return '${DateFormat('MMM d, yyyy').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductTourCubit, ProductTourState>(
      listener: (context, tourState) {
        if (tourState is TourActive &&
            tourState.currentStep == TourStep.dashboardProfileIcon &&
            !tourState.isTransitioning) {
          // Show tour after a small delay to ensure widgets are built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showProfileIconTour();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<CurrencyCubit, CurrencyState>(
          bloc: sl<CurrencyCubit>(),
          builder: (context, currencyState) {
            // This BlocBuilder ensures widgets rebuild when currency changes
            return BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state is DashboardLoaded && !_tourCheckDone) {
              _tourCheckDone = true;
              // Dashboard loaded - check if we need to start the tour
              final isOnboarded = state.summary.onboarded;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final tourCubit = context.read<ProductTourCubit>();
                tourCubit.checkAndStartTourIfNeeded(isOnboarded: isOnboarded);

                // If tour is already active at dashboard step, show it
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted &&
                      tourCubit.isAtStep(TourStep.dashboardProfileIcon)) {
                    _showProfileIconTour();
                  }
                });
              });
            }
          },
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
              final isAuthError =
                  state.message.toLowerCase().contains('unauthorized') ||
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

              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: _refreshDashboard,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).canvasColor,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        // --- Animated AppBar ---
                        HomeAppbar(
                          summary: summary,
                          onTapProfileIcon: () {
                            final tourCubit = context.read<ProductTourCubit>();
                            if (tourCubit
                                .isAtStep(TourStep.dashboardProfileIcon)) {
                              tourCubit.onProfileIconTapped();
                            }
                            Navigator.pushNamed(context, '/profile');
                          },
                          profileUrl: _profileUrl ?? '',
                          userName: _userName,
                          displayDate: _getFormattedDateRange(),
                          onTapDateRange: _selectDateRange,
                          profileIconKey: _profileIconKey,
                        ),

                        // --- Dashboard Body ---
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),

                              // Balance Card - Fade in and slide up
                              BalanceCard(
                                netBalance: summary.netBalance,
                                totalIncome: summary.totalIncome,
                                totalExpense: summary.totalExpense,
                                period: summary.period,
                              )
                                  .animate()
                                  .fadeIn(
                                      duration: 500.ms,
                                      curve: Curves.easeOutCubic)
                                  .slideY(
                                    begin: 0.1,
                                    end: 0,
                                    duration: 500.ms,
                                    curve: Curves.easeOutCubic,
                                  ),
                              const SizedBox(height: 24),

                              // Spending Trend Chart - Fade in with scale
                              if (summary.spendingTrend.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SpendingTrendChart(
                                    spendingTrend: summary.spendingTrend,
                                  ),
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
                                const SizedBox(height: 16),
                              ],

                              // Financial Ratios - Slide in from sides
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                              const SizedBox(height: 16),

                              // Accounts Breakdown - Fade in with slide
                              if (summary.accountsBreakdown.isNotEmpty) ...[
                                AccountsBreakdownWidget(
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
                                const SizedBox(height: 16),
                              ],

                              // Biggest Expense & Category
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    BiggestIncomeWidget(
                                      amount: summary.biggestIncomeAmount,
                                      description:
                                          summary.biggestIncomeDescription,
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
                                      description:
                                          summary.biggestExpenseDescription,
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
                                    const SizedBox(height: 16),
                                    if (summary.categories.isNotEmpty)
                                      CategoryBreakdownWidget(
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
                                    const SizedBox(height: 16),
                                    TransactionHistoryWidget(
                                      onViewAll: () => Navigator.pushNamed(
                                          context, '/transactions'),
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 120),
                            ],
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
                    child: const Hero(
                      tag: 'chat_input',
                      child: FloatingChatButton(),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        );  // End BlocConsumer
          },
        ),  // End BlocBuilder for CurrencyCubit
      ),
    );
  }
}
