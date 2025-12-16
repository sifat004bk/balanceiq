import 'package:balance_iq/core/tour/tour_content_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/constants/design_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/tour/tour.dart';
import '../../../subscription/domain/entities/subscription_status.dart';
import '../../../subscription/presentation/cubit/subscription_cubit.dart';
import '../../../subscription/presentation/cubit/subscription_state.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

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
    context.read<AuthCubit>().getUserProfile();

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

  void _handleEmailVerificationClick() {
    final tourCubit = context.read<ProductTourCubit>();

    // Send verification email
    context.read<AuthCubit>().sendEmailVerification();

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SubscriptionCubit>()..loadSubscriptionStatus(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.of(context).pushReplacementNamed('/login');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red.shade700,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
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
          backgroundColor:
              isDark ? AppPalette.surfaceDark : AppPalette.surfaceLight,
          body: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) {
              // Don't rebuild for intermediate verification states
              // The banner widget handles those separately
              if (current is VerificationEmailSending ||
                  current is VerificationEmailSent ||
                  current is VerificationEmailError) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return _buildProfileShimmer(isDark);
              }

              if (state is AuthAuthenticated) {
                final user = state.user;
                return _buildProfileContent(context, user, isDark, colorScheme);
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

  Widget _buildProfileContent(
    BuildContext context,
    dynamic user,
    bool isDark,
    ColorScheme colorScheme,
  ) {
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
                        child: _buildEmailVerificationBanner(
                            context, user, isDark),
                      ),
                    // Profile Header with dynamic subscription badge
                    BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      builder: (context, subState) {
                        SubscriptionStatus? status;
                        if (subState is SubscriptionStatusLoaded) {
                          status = subState.status;
                        }
                        return _buildProfileHeader(user, isDark, status);
                      },
                    ),
                    const SizedBox(height: 40),
                    // Subscription Card with real data
                    Container(
                      key: _subscriptionCardKey,
                      child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                        builder: (context, subState) {
                          if (subState is SubscriptionStatusLoading) {
                            return _buildSubscriptionCardLoading(isDark);
                          }
                          if (subState is SubscriptionStatusLoaded) {
                            return _buildSubscriptionCard(
                                context, isDark, subState.status);
                          }
                          if (subState is SubscriptionError) {
                            return _buildSubscriptionCardError(
                                context, isDark, subState.message);
                          }
                          return _buildSubscriptionCardLoading(isDark);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Menu Items
                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Account Details',
                      isDark: isDark,
                      onTap: () {
                        // TODO: Navigate to account details
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${AppStrings.profile.accountDetails} ${AppStrings.common.comingSoon}')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Security',
                      isDark: isDark,
                      onTap: () {
                        Navigator.pushNamed(context, '/change-password');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      isDark: isDark,
                      onTap: () {
                        // TODO: Navigate to notifications
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${AppStrings.profile.notifications} ${AppStrings.common.comingSoon}')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      isDark: isDark,
                      onTap: () {
                        // TODO: Navigate to appearance settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${AppStrings.profile.appearance} ${AppStrings.common.comingSoon}')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      isDark: isDark,
                      onTap: () {
                        // TODO: Navigate to help center
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  '${AppStrings.profile.helpCenter} ${AppStrings.common.comingSoon}')),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    // Log Out Button
                    _buildLogOutButton(context, isDark),
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
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailVerificationBanner(
    BuildContext context,
    dynamic user,
    bool isDark,
  ) {
    // Use design system colors
    final backgroundColor = isDark
        ? AppPalette.sparkOrange.withOpacity(0.15)
        : AppPalette.sparkOrange.withOpacity(0.1);
    final borderColor = isDark
        ? AppPalette.sparkOrange.withOpacity(0.3)
        : AppPalette.sparkOrange.withOpacity(0.3);
    final iconBgColor = isDark
        ? AppPalette.sparkOrange.withOpacity(0.2)
        : AppPalette.sparkOrange.withOpacity(0.15);
    final titleColor = isDark ? Colors.white : const Color(0xFFE65100);
    final subtitleColor =
        isDark ? Colors.white.withValues(alpha: 0.7) : AppPalette.sparkOrange;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerificationEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppStrings.auth.emailSent} ${state.email}'),
              backgroundColor: AppPalette.incomeGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(DesignConstants.radiusMedium),
              ),
            ),
          );
        } else if (state is VerificationEmailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppPalette.expenseRed,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(DesignConstants.radiusMedium),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSending = state is VerificationEmailSending;

        return Container(
          margin: EdgeInsets.only(bottom: DesignConstants.space6),
          padding: EdgeInsets.all(DesignConstants.space4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(DesignConstants.radiusLarge),
            border: Border.all(
              color: borderColor,
              width: DesignConstants.glassBorderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(DesignConstants.space2),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius:
                          BorderRadius.circular(DesignConstants.radiusSmall),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: AppPalette.sparkOrange,
                      size: DesignConstants.iconSizeLarge,
                    ),
                  ),
                  SizedBox(width: DesignConstants.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify your email',
                          style: TextStyle(
                            fontSize: DesignConstants.fontSizeL,
                            fontWeight: DesignConstants.fontWeightSemiBold,
                            color: titleColor,
                          ),
                        ),
                        SizedBox(height: DesignConstants.space1),
                        Text(
                          'Please verify your email to access all features',
                          style: TextStyle(
                            fontSize: DesignConstants.fontSizeS,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: DesignConstants.space4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () {
                          _handleEmailVerificationClick();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.sparkOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppPalette.sparkOrange.withOpacity(0.5),
                    padding:
                        EdgeInsets.symmetric(vertical: DesignConstants.space3),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DesignConstants.radiusMedium),
                    ),
                    elevation: 0,
                  ),
                  child: isSending
                      ? SizedBox(
                          height: DesignConstants.loadingIndicatorSmall,
                          width: DesignConstants.loadingIndicatorSmall,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Send Verification Email',
                          style: TextStyle(
                            fontSize: DesignConstants.fontSizeM,
                            fontWeight: DesignConstants.fontWeightSemiBold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
      dynamic user, bool isDark, SubscriptionStatus? status) {
    final hasSubscription = status?.hasActiveSubscription ?? false;
    final planName = status?.subscription?.plan.displayName ?? '';

    return Column(
      children: [
        // Avatar with glow effect
        // Avatar with glow effect
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.trustBlue.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppPalette.trustBlue,
                    width: 3,
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFC2A1),
                      Color(0xFFFFD8B8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                ),
              ),
            ),
            if (user.isEmailVerified)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    color: AppPalette.incomeGreen,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        // User Name with Subscription Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            if (hasSubscription)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: hasSubscription
                      ? AppPalette.trustBlue.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasSubscription
                        ? AppPalette.trustBlue
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasSubscription ? Icons.star : null,
                      size: 16,
                      color: hasSubscription
                          ? AppPalette.trustBlue
                          : Colors.transparent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      planName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: hasSubscription
                            ? AppPalette.trustBlue
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        // Email
        Text(
          user.email,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCardLoading(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 80,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCardError(
      BuildContext context, bool isDark, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300, size: 32),
          const SizedBox(height: 8),
          Text(
            'Failed to load subscription',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () =>
                context.read<SubscriptionCubit>().loadSubscriptionStatus(),
            child: Text(AppStrings.common.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
      BuildContext context, bool isDark, SubscriptionStatus status) {
    if (!status.hasActiveSubscription) {
      return _buildNoSubscriptionCard(context, isDark);
    }

    final subscription = status.subscription!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Subscription',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              if (subscription.isExpiringSoon)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning,
                          size: 14, color: Colors.orange.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '${subscription.daysRemaining} days left',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan: ${subscription.plan.displayName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Renews on ${subscription.formattedEndDate}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                      context, '/manage-subscription');
                  if (result == true && context.mounted) {
                    context.read<SubscriptionCubit>().loadSubscriptionStatus();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.trustBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileShimmer(bool isDark) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 56), // Approximate AppBar height
              // Avatar Shimmer
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 24),
              // Name Shimmer
              Container(
                width: 200,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              // Email Shimmer
              Container(
                width: 150,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 40),
              // Subscription Card Shimmer
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 32),
              // Menu Items Shimmer
              for (int i = 0; i < 5; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoSubscriptionCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1C23) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Subscription',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Active Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Subscribe to unlock premium features',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  final result =
                      await Navigator.pushNamed(context, '/subscription-plans');
                  if (result == true && context.mounted) {
                    context.read<SubscriptionCubit>().loadSubscriptionStatus();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.trustBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Subscribe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1C23) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppPalette.trustBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppPalette.trustBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOutButton(BuildContext context, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Show confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppStrings.profile.logOut),
              content: Text(AppStrings.profile.logOutConfirm),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppStrings.common.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<AuthCubit>().logout();
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDark ? const Color(0xFF2D1F1F) : Colors.red.shade50,
          foregroundColor: Colors.red.shade700,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 20,
              color: Colors.red.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
