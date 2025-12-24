import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:feature_auth/constants/auth_strings.dart';
import 'package:dolfin_core/currency/currency_cubit.dart';
import 'package:dolfin_core/tour/product_tour_cubit.dart';
import 'package:dolfin_core/tour/product_tour_state.dart';
import 'package:dolfin_core/tour/email_sent_modal.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:feature_subscription/presentation/cubit/subscription_cubit.dart';
import 'package:feature_subscription/presentation/cubit/subscription_state.dart';
import "package:feature_auth/presentation/cubit/session/session_cubit.dart";
import "package:feature_auth/presentation/cubit/signup/signup_cubit.dart";
import '../widgets/profile/profile_widgets.dart';
import '../mixins/profile_tour_mixin.dart';
import '../widgets/profile/subscription_card_states.dart';
import 'webview_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with ProfileTourMixin, WidgetsBindingObserver {
  bool _hasOpenedCurrencyPicker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<SessionCubit>().refreshUserProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowTour();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disposeTour();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh user profile when app resumes to check if email was verified
    if (state == AppLifecycleState.resumed) {
      context.read<SessionCubit>().refreshUserProfile();
    }
  }

  void _handleEmailVerificationClick(BuildContext ctx, dynamic user) {
    final tourCubit = ctx.read<ProductTourCubit>();

    // Send verification email using SignupCubit
    ctx.read<SignupCubit>().sendEmailVerification(user);

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
          if (mounted) showSubscriptionTour();
        });
      },
    );
  }

  void _checkAndShowCurrencyPicker() {
    if (_hasOpenedCurrencyPicker) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['action'] == 'open_currency_selector') {
      _hasOpenedCurrencyPicker = true;
      final returnToChat = args['returnToChat'] == true;
      _showCurrencyPicker(context, returnToChat: returnToChat);
    }
  }

  void _showCurrencyPicker(BuildContext context, {bool returnToChat = false}) {
    showCurrencyPicker(
      context: context,
      theme: CurrencyPickerThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Theme.of(context).colorScheme.onSurface,
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
        GetIt.instance<CurrencyCubit>().setCurrency(currency);
        // Sync with backend
        context.read<SessionCubit>().updateUserCurrency(currency.code);

        SnackbarUtils.showSuccess(
          context,
          'Currency changed to ${currency.symbol} ${currency.name}',
        );

        // If navigated from chat, return after selection
        if (returnToChat) {
          Navigator.pop(context);
        }
      },
      favorite: ['BDT', 'USD', 'EUR', 'GBP', 'INR'],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check for arguments after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowCurrencyPicker();
    });

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              GetIt.instance<SubscriptionCubit>()..loadSubscriptionStatus(),
        ),
        // Provide SignupCubit locally for verification feature in Profile
        BlocProvider(
          create: (_) => GetIt.instance<SignupCubit>(),
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
                    showEmailVerifyTour();
                  });
                } else if (tourState.currentStep == TourStep.emailSentModal) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showEmailSentModal();
                  });
                } else if (tourState.currentStep ==
                    TourStep.profileSubscription) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showSubscriptionTour();
                  });
                }
              }
            },
          ),
        ],
        child: Scaffold(
          body: BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state is SessionLoading || state is SessionInitial) {
                return const ProfileShimmer();
              }

              if (state is Authenticated) {
                final user = state.user;
                return _buildProfileContent(context, user);
              }

              return Center(
                child: Text(GetIt.I<AuthStrings>().signingIn),
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
            const SliverSafeArea(
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
                        key: emailVerifyKey,
                        child: EmailVerificationBanner(
                          user: user,
                          onVerificationClick: () =>
                              _handleEmailVerificationClick(context, user),
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
                      key: subscriptionCardKey,
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
                        SnackbarUtils.showComingSoon(context,
                            GetIt.I<AuthStrings>().profile.accountDetails);
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
                        SnackbarUtils.showComingSoon(context,
                            GetIt.I<AuthStrings>().profile.notifications);
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      onTap: () {
                        SnackbarUtils.showComingSoon(
                            context, GetIt.I<AuthStrings>().profile.appearance);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Currency Selector
                    BlocBuilder<CurrencyCubit, CurrencyState>(
                      bloc: GetIt.instance<CurrencyCubit>(),
                      builder: (context, currencyState) {
                        return ProfileMenuItem(
                          icon: Icons.currency_exchange_outlined,
                          title: GetIt.I<AuthStrings>().profile.currency,
                          subtitle: currencyState.isCurrencySet
                              ? '${currencyState.currencySymbol} ${currencyState.currencyName}'
                              : 'Select Currency',
                          onTap: () => _showCurrencyPicker(context),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: () {
                        SnackbarUtils.showComingSoon(
                            context, GetIt.I<AuthStrings>().profile.helpCenter);
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.privacy_tip_outlined,
                      title: GetIt.I<AuthStrings>().profile.privacyPolicy,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              title:
                                  GetIt.I<AuthStrings>().profile.privacyPolicy,
                              url: 'https://dolfinmind.com/privacy-policy',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.description_outlined,
                      title: GetIt.I<AuthStrings>().profile.termsOfService,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              title:
                                  GetIt.I<AuthStrings>().profile.termsOfService,
                              url: 'https://dolfinmind.com/terms-of-service',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.delete_outline,
                      title: GetIt.I<AuthStrings>().profile.deleteAccount,
                      iconColor: Theme.of(context).colorScheme.error,
                      titleColor: Theme.of(context).colorScheme.error,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              title:
                                  GetIt.I<AuthStrings>().profile.deleteAccount,
                              url: 'https://dolfinmind.com/delete-account',
                            ),
                          ),
                        );
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
