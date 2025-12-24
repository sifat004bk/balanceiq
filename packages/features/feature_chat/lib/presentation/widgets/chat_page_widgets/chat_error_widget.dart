import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dolfin_core/constants/core_strings.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_ui_kit/theme/app_typography.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/chat_state.dart';

class ChatErrorWidget extends StatelessWidget {
  final ChatError state;
  final String botId;

  const ChatErrorWidget({
    super.key,
    required this.state,
    required this.botId,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '[ChatDebug] ChatErrorWidget build started for type: ${state.errorType}');
    final errorConfig = _getErrorConfig(context);
    debugPrint(
        '[ChatDebug] ChatErrorWidget config retrieved: ${errorConfig.title}');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconContainer(errorConfig),
              const SizedBox(height: 24),
              _buildTitle(errorConfig, colorScheme),
              const SizedBox(height: 12),
              _buildDescription(context, errorConfig),
              const SizedBox(height: 32),
              _buildActionButton(context, errorConfig, colorScheme),
              if (state.messages?.isNotEmpty == true)
                _buildBackToChatButton(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  _ErrorConfig _getErrorConfig(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state.errorType) {
      case ChatErrorType.emailNotVerified:
        return _ErrorConfig(
          title: _getSafeString(
              () => GetIt.I<ChatStrings>().emailVerificationRequired,
              'Email Verification Required'),
          description: _getSafeString(
              () => GetIt.I<ChatStrings>().emailVerificationMessage,
              'Please verify your email address to use the chat feature.'),
          icon: Icons.email_outlined,
          iconColor: colorScheme.tertiary,
          buttonText: _getSafeString(
              () => GetIt.I<ChatStrings>().verifyEmailButton, 'Verify Email'),
          onButtonPressed: () => Navigator.pushNamed(context, '/profile'),
        );
      case ChatErrorType.subscriptionRequired:
        return _ErrorConfig(
          title: _getSafeString(
              () => GetIt.I<ChatStrings>().subscriptionRequired,
              'Subscription Required'),
          description: _getSafeString(
              () => GetIt.I<ChatStrings>().subscriptionRequiredMessage,
              'You need an active subscription plan to use the chat feature.'),
          icon: Icons.card_membership_outlined,
          iconColor: colorScheme.primary,
          buttonText: _getSafeString(
              () => GetIt.I<ChatStrings>().viewPlans, 'View Plans'),
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/subscription-plans'),
        );
      case ChatErrorType.subscriptionExpired:
        return _ErrorConfig(
          title: _getSafeString(
              () => GetIt.I<ChatStrings>().subscriptionExpired,
              'Subscription Expired'),
          description: _getSafeString(
              () => GetIt.I<ChatStrings>().subscriptionExpiredMessage,
              'Your subscription has expired. Please renew to continue using the chat feature.'),
          icon: Icons.timer_off_outlined,
          iconColor: colorScheme.error,
          buttonText: _getSafeString(
              () => GetIt.I<ChatStrings>().renewSubscription,
              'Renew Subscription'),
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/manage-subscription'),
        );
      case ChatErrorType.messageLimitExceeded:
        return _ErrorConfig(
          title: _getSafeString(
              () => GetIt.I<ChatStrings>().messageLimitExceeded,
              'Message Limit Exceeded'),
          description: state.message.isNotEmpty
              ? state.message
              : _getSafeString(
                  () => GetIt.I<ChatStrings>().messageLimitExceededMessage,
                  'You have reached your daily message limit. Resets at midnight.'),
          icon: Icons.token_outlined,
          iconColor: colorScheme.secondary,
          buttonText: _getSafeString(
              () => GetIt.I<ChatStrings>().upgradePlan, 'Upgrade Plan'),
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/subscription-plans'),
        );
      case ChatErrorType.rateLimitExceeded:
        return _ErrorConfig(
          title: _getSafeString(() => GetIt.I<ChatStrings>().tooManyRequests,
              'Too Many Requests'),
          description: _getSafeString(
              () => GetIt.I<ChatStrings>().rateLimitMessage,
              'Please wait a moment before sending more messages.'),
          icon: Icons.schedule_outlined,
          iconColor: colorScheme.primary,
          buttonText: GetIt.I<CoreStrings>().common.gotIt,
          onButtonPressed: () =>
              context.read<ChatCubit>().loadChatHistory(botId),
        );
      case ChatErrorType.currencyRequired:
        return _ErrorConfig(
          title: _getSafeString(() => GetIt.I<ChatStrings>().currencyRequired,
              'Currency Required'),
          description: _getSafeString(
              () => GetIt.I<ChatStrings>().currencyRequiredMessage,
              'Please set your preferred currency in your profile settings before using the chat feature.'),
          icon: Icons.currency_exchange,
          iconColor: colorScheme.secondary,
          buttonText: _getSafeString(
              () => GetIt.I<ChatStrings>().setCurrency, 'Set Currency'),
          onButtonPressed: () {
            Navigator.pushNamed(
              context,
              '/profile',
              arguments: {
                'action': 'open_currency_selector',
                'returnToChat': true
              },
            ).then((_) {
              // Reload chat after returning from profile
              context.read<ChatCubit>().loadChatHistory(botId);
            });
          },
        );
      default:
        return _ErrorConfig(
          title: GetIt.I<CoreStrings>().errors.somethingWentWrong,
          description: state.message.isNotEmpty
              ? state.message
              : GetIt.I<CoreStrings>().errors.tryAgainLater,
          icon: Icons.error_outline,
          iconColor: colorScheme.error,
          buttonText: GetIt.I<CoreStrings>().common.retry,
          onButtonPressed: () =>
              context.read<ChatCubit>().loadChatHistory(botId),
        );
    }
  }

  String _getSafeString(String Function() getter, String fallback) {
    try {
      return getter();
    } catch (_) {
      return fallback;
    }
  }

  Widget _buildIconContainer(_ErrorConfig config) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: config.iconColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        config.icon,
        size: 48,
        color: config.iconColor,
      ),
    );
  }

  Widget _buildTitle(_ErrorConfig config, ColorScheme colorScheme) {
    return Text(
      config.title,
      style: AppTypography.titleLargeBold.copyWith(
        color: colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context, _ErrorConfig config) {
    return Text(
      config.description,
      style: AppTypography.bodyMedium.copyWith(
        color: Theme.of(context).hintColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    _ErrorConfig config,
    ColorScheme colorScheme,
  ) {
    return ElevatedButton(
      onPressed: config.onButtonPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        config.buttonText,
        style: AppTypography.buttonMedium,
      ),
    );
  }

  Widget _buildBackToChatButton(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.read<ChatCubit>().loadChatHistory(botId),
          child: Text(
            GetIt.I<ChatStrings>().backToChat,
            style: AppTypography.bodyMedium.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorConfig {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback onButtonPressed;

  _ErrorConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
    required this.onButtonPressed,
  });
}
