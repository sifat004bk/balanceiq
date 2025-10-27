import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_state.dart';

class ProfileModal extends StatefulWidget {
  final User user;

  const ProfileModal({
    super.key,
    required this.user,
  });

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  bool _isSettingsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer for centering
                  Text(
                    'Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Main content - centered
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  children: [
                    // User Avatar - Large and centered
                    Stack(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.transparent,
                            backgroundImage: widget.user.photoUrl != null
                                ? CachedNetworkImageProvider(
                                    widget.user.photoUrl!,
                                    cacheKey: 'profile_${widget.user.id}',
                                  )
                                : null,
                            child: widget.user.photoUrl == null
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '?',
                                        style: const TextStyle(
                                          fontSize: 56,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        // Camera icon overlay (optional - commented out for now)
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       color: isDark ? Colors.grey[800] : Colors.grey[300],
                        //       shape: BoxShape.circle,
                        //       border: Border.all(
                        //         color: Theme.of(context).scaffoldBackgroundColor,
                        //         width: 3,
                        //       ),
                        //     ),
                        //     child: Icon(
                        //       Icons.photo_camera,
                        //       size: 20,
                        //       color: isDark ? Colors.grey[300] : Colors.grey[700],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // User name
                    Text(
                      'Hi, ${widget.user.name}!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    // User email
                    Text(
                      widget.user.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Options List
                    _buildOptionItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Manage your account',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account management coming soon')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.people_outline,
                      title: 'Switch account',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account switching coming soon')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.manage_accounts,
                      title: 'Manage subscription',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Subscription management coming soon')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.upgrade,
                      title: 'Upgrade to Next Level',
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upgrade options coming soon')),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Expandable Settings Section
                    _buildExpandableSettings(context),
                    const SizedBox(height: 12),
                    _buildOptionItem(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: () => _showLogoutConfirmation(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? Colors.grey[800] : Colors.grey[200])?.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Settings header (clickable to expand/collapse)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isSettingsExpanded = !_isSettingsExpanded;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isSettingsExpanded ? 0.25 : 0.0, // 90 degrees when expanded
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildThemeOptionForSettings(context),
            crossFadeState: _isSettingsExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOptionForSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final currentThemeMode = state is ThemeLoaded ? state.themeMode : ThemeMode.system;

        IconData themeIcon;

        switch (currentThemeMode) {
          case ThemeMode.light:
            themeIcon = Icons.light_mode;
            break;
          case ThemeMode.dark:
            themeIcon = Icons.dark_mode;
            break;
          case ThemeMode.system:
            themeIcon = Icons.brightness_auto;
            break;
        }

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showThemeDialog(context, currentThemeMode),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: (isDark ? Colors.grey[900] : Colors.grey[300])?.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40), // Indent for sub-item
                  const Expanded(
                    child: Text(
                      'Choose Theme',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    themeIcon,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: (isDark ? Colors.grey[800] : Colors.grey[200])?.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : (isDark ? Colors.grey[400] : Colors.grey[700]),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDestructive ? Colors.red : null,
                        fontSize: 16,
                      ),
                ),
              ),
              if (!isDestructive)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[600],
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentMode) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Choose Theme',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              // Light Mode Option
              _buildThemeDialogOption(
                context: dialogContext,
                title: 'Light Mode',
                icon: Icons.light_mode,
                isSelected: currentMode == ThemeMode.light,
                onTap: () {
                  themeCubit.setLightMode();
                  Navigator.pop(dialogContext);
                },
              ),
              const SizedBox(height: 12),
              // Dark Mode Option
              _buildThemeDialogOption(
                context: dialogContext,
                title: 'Dark Mode',
                icon: Icons.dark_mode,
                isSelected: currentMode == ThemeMode.dark,
                onTap: () {
                  themeCubit.setDarkMode();
                  Navigator.pop(dialogContext);
                },
              ),
              const SizedBox(height: 12),
              // System Theme Option
              _buildThemeDialogOption(
                context: dialogContext,
                title: 'System Theme',
                icon: Icons.brightness_auto,
                isSelected: currentMode == ThemeMode.system,
                onTap: () {
                  themeCubit.setSystemMode();
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeDialogOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : (isDark ? Colors.grey[800] : Colors.grey[200])?.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : (isDark ? Colors.grey[400] : Colors.grey[700]),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isSelected ? Theme.of(context).primaryColor : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'Are you sure you want to log out?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'You will be returned to the login screen.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Yes, Log Out Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Close dialog
                    Navigator.pop(context); // Close profile modal
                    authCubit.logout(); // Then logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Yes, Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isDark ? Colors.grey[800] : Colors.grey[200])?.withValues(alpha: 0.6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Show profile modal with slide animation from right
void showProfileModal(BuildContext context, User user) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProfileModal(user: user),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}
