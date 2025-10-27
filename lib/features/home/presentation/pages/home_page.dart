import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../widgets/profile_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  // User Profile Avatar
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return GestureDetector(
                          onTap: () => showProfileModal(context, state.user),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: state.user.photoUrl != null
                                ? CachedNetworkImageProvider(state.user.photoUrl!)
                                : null,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: state.user.photoUrl == null
                                ? Text(
                                    state.user.name.isNotEmpty
                                        ? state.user.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }
                      return IconButton(
                        icon: const Icon(Icons.account_circle, size: 32),
                        onPressed: () {},
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              // Choose a bot text
              Text(
                'Choose a bot to start',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              // Bot Selection Buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildBotButton(
                    context,
                    botId: AppConstants.balanceTrackerID,
                    botName: AppConstants.balanceTracker,
                    icon: AppTheme.getBotIcon(AppConstants.balanceTrackerID),
                    color: AppTheme.getBotColor(AppConstants.balanceTrackerID),
                  ),
                  _buildBotButton(
                    context,
                    botId: AppConstants.investmentGuruID,
                    botName: AppConstants.investmentGuru,
                    icon: AppTheme.getBotIcon(AppConstants.investmentGuruID),
                    color: AppTheme.getBotColor(AppConstants.investmentGuruID),
                  ),
                  _buildBotButton(
                    context,
                    botId: AppConstants.budgetPlannerID,
                    botName: AppConstants.budgetPlanner,
                    icon: AppTheme.getBotIcon(AppConstants.budgetPlannerID),
                    color: AppTheme.getBotColor(AppConstants.budgetPlannerID),
                  ),
                  _buildBotButton(
                    context,
                    botId: AppConstants.finTipsID,
                    botName: AppConstants.finTips,
                    icon: AppTheme.getBotIcon(AppConstants.finTipsID),
                    color: AppTheme.getBotColor(AppConstants.finTipsID),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotButton(
    BuildContext context, {
    required String botId,
    required String botName,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatPage(
              botId: botId,
              botName: botName,
            ),
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            botName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
