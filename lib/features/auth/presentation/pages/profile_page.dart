import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/currency/currency_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/tour/tour.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../subscription/presentation/cubit/subscription_cubit.dart';
import '../../../subscription/presentation/cubit/subscription_state.dart';
import '../cubit/session/session_cubit.dart';
import '../cubit/signup/signup_cubit.dart';
import '../widgets/profile/profile_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TutorialCoachMark? _tutorialCoachMark;
  bool _emailVerifyTourShown = false;
  bool _subscriptionTourShown = false;

  // Tour keys
  final GlobalKey _emailVerifyKey = GlobalKey();
  final GlobalKey _subscriptionCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Refresh user profile using SessionCubit
    context.read<SessionCubit>().refreshUserProfile();

    // Check if we should show tour after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTour();
    });
  }

  @override
  void dispose() {
    _tutorialCoachMark?.finish();
    super.dispose();
  }

  void _checkAndShowTour() {
    final tourCubit = context.read<ProductTourCubit>();
    final tourState = tourCubit.state;

    if (tourState is TourActive) {
      if (tourState.currentStep == TourStep.profileEmailVerify) {
        _showEmailVerifyTour();
      } else if (tourState.currentStep == TourStep.profileSubscription) {
        _showSubscriptionTour();
      }
    }
  }

  void _showEmailVerifyTour() {
    if (_emailVerifyTourShown) return;
    if (_emailVerifyKey.currentContext == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showEmailVerifyTour();
      });
      return;
    }

    _emailVerifyTourShown = true;
    final tourCubit = context.read<ProductTourCubit>();

    final targets = [
      TargetFocus(
        identify: 'email_verify',
        keyTarget: _emailVerifyKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: false,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TourTooltipContent(
                icon: Icons.email_outlined,
                title: 'Verify Your Email',
                description:
                    'Click the button to send a verification email. This unlocks all features!',
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
      onClickOverlay: (target) {},
      onFinish: () {
        // Tour tooltip dismissed
      },
      onSkip: () {
        tourCubit.skipTour();
        return true;
      },
    );

    _tutorialCoachMark!.show(context: context);
  }

  void _showSubscriptionTour() {
    if (_subscriptionTourShown) return;
    if (_subscriptionCardKey.currentContext == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showSubscriptionTour();
      });
      return;
    }

    _subscriptionTourShown = true;
    final tourCubit = context.read<ProductTourCubit>();

    final targets = [
      TargetFocus(
        identify: 'subscription',
        keyTarget: _subscriptionCardKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: false,
        enableTargetTab: true,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return TourTooltipContent(
                icon: Icons.card_membership_outlined,
                title: 'Choose a Plan',
                description:
                    'Subscribe to start tracking your finances. We have a free plan to get you started!',
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
      onClickOverlay: (target) {},
      onFinish: () {
        // Tour tooltip dismissed
      },
      onSkip: () {
        tourCubit.skipTour();
        return true;
      },
    );

    _tutorialCoachMark!.show(context: context);
  }

  void _handleEmailVerificationClick(dynamic user) {
    final tourCubit = context.read<ProductTourCubit>();

    // Send verification email using SignupCubit
    context.read<SignupCubit>().sendEmailVerification(user);

    // If tour is active at email verify step, advance to modal
    if (tourCubit.isAtStep(TourStep.profileEmailVerify)) {
      tourCubit.onEmailVerificationClicked();
    }
  }

  void _showEmailSentModal() {
    final tourCubit = context.read<ProductTourCubit>();

    EmailSentModal.show(
      context,
      onContinue: () {
        Navigator.of(context).pop(); // Close modal
        tourCubit.acknowledgeEmailSent();
        // Show subscription tour after a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _showSubscriptionTour();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SubscriptionCubit>()..loadSubscriptionStatus(),
        ),
        // Provide SignupCubit locally for verification feature in Profile
        BlocProvider(
          create: (_) => sl<SignupCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SessionCubit, SessionState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.of(context).pushReplacementNamed('/login');
              } else if (state is SessionError) {
                SnackbarUtils.showError(context, state.message);
              }
            },
          ),
          BlocListener<ProductTourCubit, ProductTourState>(
            listener: (context, tourState) {
              if (tourState is TourActive && !tourState.isTransitioning) {
                if (tourState.currentStep == TourStep.profileEmailVerify) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showEmailVerifyTour();
                  });
                } else if (tourState.currentStep == TourStep.emailSentModal) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showEmailSentModal();
                  });
                } else if (tourState.currentStep ==
                    TourStep.profileSubscription) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showSubscriptionTour();
                  });
                }
              }
            },
          ),
        ],
        child: Scaffold(
          body: BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state is SessionLoading) {
                return const ProfileShimmer();
              }

              if (state is Authenticated) {
                final user = state.user;
                return _buildProfileContent(context, user);
              }

              return Center(
                child: Text(AppStrings.auth.signingIn),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, dynamic user) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverSafeArea(
              bottom: false,
              sliver: SliverToBoxAdapter(
                child: SizedBox(height: 5),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Email Verification Banner (if not verified)
                    if (!user.isEmailVerified)
                      Container(
                        key: _emailVerifyKey,
                        child: EmailVerificationBanner(
                          user: user,
                          onVerificationClick: () =>
                              _handleEmailVerificationClick(user),
                        ),
                      ),
                    // Profile Header with dynamic subscription badge
                    BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      builder: (context, subState) {
                        return ProfileHeader(
                          user: user,
                          subscriptionStatus:
                              subState is SubscriptionStatusLoaded
                                  ? subState.status
                                  : null,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    // Subscription Card with real data
                    Container(
                      key: _subscriptionCardKey,
                      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                        builder: (context, subState) {
                          if (subState is SubscriptionStatusLoading) {
                            return const SubscriptionCardLoading();
                          }
                          if (subState is SubscriptionStatusLoaded) {
                            return SubscriptionCard(status: subState.status);
                          }
                          if (subState is SubscriptionError) {
                            return SubscriptionCardError(
                                message: subState.message);
                          }
                          return const SubscriptionCardLoading();
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Menu Items
                    ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Account Details',
                      onTap: () {
                        SnackbarUtils.showComingSoon(
                            context, AppStrings.profile.accountDetails);
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Security',
                      onTap: () {
                        Navigator.pushNamed(context, '/change-password');
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {
                        SnackbarUtils.showComingSoon(
                            context, AppStrings.profile.notifications);
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      onTap: () {
                        SnackbarUtils.showComingSoon(
                            context, AppStrings.profile.appearance);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Currency Selector
                    BlocBuilder<CurrencyCubit, CurrencyState>(
                      bloc: sl<CurrencyCubit>(),
                      builder: (context, currencyState) {
                        return ProfileMenuItem(
                          icon: Icons.currency_exchange_outlined,
                          title: AppStrings.profile.currency,
                          subtitle:
                              '${currencyState.currencySymbol} ${currencyState.currencyName}',
                          onTap: () {
                            showCurrencyPicker(
                              context: context,
                              theme: CurrencyPickerThemeData(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                subtitleTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                                flagSize: 28,
                                inputDecoration: InputDecoration(
                                  hintText: 'Search currency',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              showFlag: true,
                              showCurrencyName: true,
                              showCurrencyCode: true,
                              onSelect: (Currency currency) {
                                sl<CurrencyCubit>().setCurrency(currency);
                                SnackbarUtils.showSuccess(
                                  context,
                                  'Currency changed to ${currency.symbol} ${currency.name}',
                                );
                              },
                              favorite: ['BDT', 'USD', 'EUR', 'GBP', 'INR'],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        SnackbarUtils.showComingSoon(
                            context, AppStrings.profile.helpCenter);
                      },
                    ),
                    const SizedBox(height: 40),
                    // Log Out Button
                    const LogOutButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}
