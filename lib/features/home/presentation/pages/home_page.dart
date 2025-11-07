import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../widgets/profile_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, isDark),

                  // Premium Card
                  _buildPremiumCard(context, isDark),

                  // Feature Grid
                  _buildFeatureGrid(context, isDark),

                  // Bottom padding to avoid overlap with bottom nav
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Floating Chat Button
            Positioned(
              bottom: 120,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to default chat bot
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        botId: AppConstants.balanceTrackerID,
                        botName: AppConstants.balanceTracker,
                      ),
                    ),
                  );
                },
                backgroundColor: AppTheme.primaryColor,
                child: Icon(
                  Icons.chat,
                  color: isDark ? AppTheme.backgroundDark : AppTheme.backgroundDark,
                ),
              ),
            ),

            // Bottom Navigation Bar
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildBottomNav(context, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(
                Icons.hub,
                color: AppTheme.primaryColor,
                size: 32,
              ),
            ],
          ),

          // Welcome text
          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String userName = 'User';
                if (state is AuthAuthenticated) {
                  userName = state.user.name.split(' ').first;
                }
                return Text(
                  'Welcome, $userName!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),

          // Profile Button
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
                    backgroundColor: AppTheme.primaryColor,
                    child: state.user.photoUrl == null
                        ? Icon(
                            Icons.account_circle,
                            size: 24,
                            color: isDark ? AppTheme.textDarkTheme : AppTheme.textLightTheme,
                          )
                        : null,
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.account_circle, size: 24),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF193326) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unlock All Features',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upgrade to Premium for exclusive access to FinanceGuru and more.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppTheme.textSubtleDark
                            : AppTheme.textSubtleLight,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to premium/payment page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: isDark
                      ? AppTheme.backgroundDark
                      : AppTheme.backgroundDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Go Premium',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildFeatureCard(
            context,
            isDark,
            title: 'FinanceGuru',
            subtitle: 'Your personal finance AI.',
            icon: Icons.account_balance,
            isPremium: true,
            botId: AppConstants.balanceTrackerID,
          ),
          _buildFeatureCard(
            context,
            isDark,
            title: 'WooCommerce',
            subtitle: 'Automate your e-commerce.',
            icon: Icons.shopping_cart,
            isPremium: false,
            botId: AppConstants.investmentGuruID,
          ),
          _buildFeatureCard(
            context,
            isDark,
            title: 'Scia Media',
            subtitle: 'Content creation on autopilot.',
            icon: Icons.camera_roll,
            isPremium: true,
            botId: AppConstants.budgetPlannerID,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isPremium,
    required String botId,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to chat with this bot
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatPage(
              botId: botId,
              botName: title,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF193326) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPremium
                ? (isDark
                    ? AppTheme.primaryColor.withValues(alpha: 0.3)
                    : Colors.transparent)
                : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
          ),
          boxShadow: isPremium
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium badge
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? AppTheme.primaryColor.withValues(alpha: 0.2)
                        : (isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPremium ? 'Premium' : 'Free',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isPremium
                          ? AppTheme.primaryColor
                          : (isDark
                              ? AppTheme.textSubtleDark
                              : AppTheme.textSubtleLight),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Icon
            Icon(
              icon,
              color: isPremium ? AppTheme.primaryColor : (isDark ? AppTheme.textDarkTheme : AppTheme.textLightTheme),
              size: 32,
            ),

            const Spacer(),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppTheme.textSubtleDark
                        : AppTheme.textSubtleLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDark
                ? const Color(0xFF1E1E1E)
                : Colors.white)
            .withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            isDark,
            icon: Icons.home,
            label: 'Home',
            index: 0,
          ),
          _buildNavItem(
            context,
            isDark,
            icon: Icons.bolt,
            label: 'Automations',
            index: 1,
          ),
          _buildNavItem(
            context,
            isDark,
            icon: Icons.person,
            label: 'Profile',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          // TODO: Handle navigation to different sections
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryColor
                    : (isDark
                        ? AppTheme.textSubtleDark
                        : AppTheme.textSubtleLight),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : (isDark
                          ? AppTheme.textSubtleDark
                          : AppTheme.textSubtleLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
