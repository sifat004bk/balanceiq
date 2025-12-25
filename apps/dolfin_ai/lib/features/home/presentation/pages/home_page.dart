import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:balance_iq/core/di/injection_container.dart';
import 'package:balance_iq/core/tour/tour.dart';
import 'package:feature_auth/data/datasources/auth_local_datasource.dart';
import 'package:balance_iq/features/home/presentation/cubit/dashboard_state.dart';
import 'package:balance_iq/features/home/presentation/widgets/dashboard_widgets/dashboard_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../cubit/dashboard_cubit.dart';
import '../cubit/transactions_cubit.dart';
import '../widgets/calendar_widgets/date_selector_bottom_sheet.dart';
import '../widgets/dashboard_layout.dart';
import 'error_page.dart';
import 'welcome_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionsCubit>(
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

  final GlobalKey _profileIconKey = GlobalKey();
  late DashboardTourController _tourController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tourController = DashboardTourController(
        context: context,
        profileIconKey: _profileIconKey,
      );
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
    _tourController.dispose();
    super.dispose();
  }

  void _checkInitialDashboardState() {
    final state = context.read<DashboardCubit>().state;
    if (state is DashboardLoaded && !_tourCheckDone) {
      final isOnboarded = state.summary.onboarded;

      _tourController.checkAndTriggerTour(
        isOnboarded: isOnboarded,
        onTourCheckDone: () {
          _tourCheckDone = true;
        },
      );
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
            _tourController.showProfileIconTour();
          });
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
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
                      tourCubit.checkAndStartTourIfNeeded(
                          isOnboarded: isOnboarded);

                      // If tour is already active at dashboard step, show it
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted &&
                            tourCubit.isAtStep(TourStep.dashboardProfileIcon)) {
                          _tourController.showProfileIconTour();
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
                            state.message
                                .toLowerCase()
                                .contains('unauthenticated') ||
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

                    return DashboardLayout(
                      summary: summary,
                      onRefresh: _refreshDashboard,
                      onTapProfileIcon: () {
                        final tourCubit = context.read<ProductTourCubit>();
                        if (tourCubit.isAtStep(TourStep.dashboardProfileIcon)) {
                          tourCubit.onProfileIconTapped();
                        }
                        Navigator.pushNamed(context, '/profile');
                      },
                      onChatReturn: _loadDashboard,
                      profileUrl: _profileUrl ?? '',
                      userName: _userName,
                      displayDate: _getFormattedDateRange(),
                      onTapDateRange: _selectDateRange,
                      profileIconKey: _profileIconKey,
                    );
                  }

                  return const SizedBox.shrink();
                },
              ); // End BlocConsumer
            },
          ), // End BlocBuilder for CurrencyCubit
        ),
      ),
    );
  }
}
