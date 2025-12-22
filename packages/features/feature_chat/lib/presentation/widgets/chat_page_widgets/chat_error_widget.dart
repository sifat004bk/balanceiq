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
    final errorConfig = _getErrorConfig(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
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
    );
  }

  _ErrorConfig _getErrorConfig(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state.errorType) {
      case ChatErrorType.emailNotVerified:
        return _ErrorConfig(
          title: GetIt.I<ChatStrings>().emailVerificationRequired,
          description: GetIt.I<ChatStrings>().emailVerificationMessage,
          icon: Icons.email_outlined,
          iconColor: colorScheme.tertiary,
          buttonText: GetIt.I<ChatStrings>().verifyEmailButton,
          onButtonPressed: () => Navigator.pushNamed(context, '/profile'),
        );
      case ChatErrorType.subscriptionRequired:
        return _ErrorConfig(
          title: GetIt.I<ChatStrings>().subscriptionRequired,
          description: GetIt.I<ChatStrings>().subscriptionRequiredMessage,
          icon: Icons.card_membership_outlined,
          iconColor: colorScheme.primary,
          buttonText: GetIt.I<ChatStrings>().viewPlans,
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/subscription-plans'),
        );
      case ChatErrorType.subscriptionExpired:
        return _ErrorConfig(
          title: GetIt.I<ChatStrings>().subscriptionExpired,
          description: GetIt.I<ChatStrings>().subscriptionExpiredMessage,
          icon: Icons.timer_off_outlined,
          iconColor: colorScheme.error,
          buttonText: GetIt.I<ChatStrings>().renewSubscription,
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/manage-subscription'),
        );
      case ChatErrorType.messageLimitExceeded:
        return _ErrorConfig(
          title: GetIt.I<ChatStrings>().messageLimitExceeded,
          description: state.message.isNotEmpty
              ? state.message
              : GetIt.I<ChatStrings>().messageLimitExceededMessage,
          icon: Icons.token_outlined,
          iconColor: colorScheme.secondary,
          buttonText: GetIt.I<ChatStrings>().upgradePlan,
          onButtonPressed: () =>
              Navigator.pushNamed(context, '/subscription-plans'),
        );
      case ChatErrorType.rateLimitExceeded:
        return _ErrorConfig(
          title: GetIt.I<ChatStrings>().tooManyRequests,
          description: GetIt.I<ChatStrings>().rateLimitMessage,
          icon: Icons.schedule_outlined,
          iconColor: colorScheme.primary,
          buttonText: GetIt.I<CoreStrings>().common.gotIt,
          onButtonPressed: () =>
              context.read<ChatCubit>().loadChatHistory(botId),
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
