import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate to login when logged out
          Navigator.of(context).pushReplacementNamed('/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile & Settings'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Profile Header
                    _buildProfileHeader(context, user, isDark),
                    const SizedBox(height: 32),
                    // Account Section
                    _buildSection(
                      context,
                      title: 'Account',
                      items: [
                        _SettingsItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () {
                            // TODO: Navigate to edit profile page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Edit profile feature coming soon'),
                              ),
                            );
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your account password',
                          onTap: () {
                            Navigator.pushNamed(context, '/change-password');
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          subtitle: user.email,
                          trailing: null,
                        ),
                      ],
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    // Preferences Section
                    _buildSection(
                      context,
                      title: 'Preferences',
                      items: [
                        _SettingsItem(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Language settings coming soon'),
                              ),
                            );
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.currency_exchange,
                          title: 'Currency',
                          subtitle: 'BDT (৳)',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Currency settings coming soon'),
                              ),
                            );
                          },
                        ),
                      ],
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    // About Section
                    _buildSection(
                      context,
                      title: 'About',
                      items: [
                        _SettingsItem(
                          icon: Icons.info_outline,
                          title: 'App Version',
                          subtitle: '1.0.0+1',
                          trailing: null,
                        ),
                        _SettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Privacy policy coming soon'),
                              ),
                            );
                          },
                        ),
                        _SettingsItem(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Terms of service coming soon'),
                              ),
                            );
                          },
                        ),
                      ],
                      isDark: isDark,
                    ),
                    const SizedBox(height: 32),
                    // Logout Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showLogoutDialog(context);
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            }

            // Loading or other states
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    dynamic user,
    bool isDark,
  ) {
    return Column(
      children: [
        // Profile Picture
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 3,
            ),
          ),
          child: user.photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    user.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(user.name);
                    },
                  ),
                )
              : _buildDefaultAvatar(user.name),
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        // Email
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppTheme.textSubtleDark
                    : AppTheme.textSubtleLight,
              ),
        ),
        const SizedBox(height: 8),
        // Auth Provider Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getAuthProviderIcon(user.authProvider),
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                _getAuthProviderLabel(user.authProvider),
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  IconData _getAuthProviderIcon(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return Icons.g_mobiledata;
      case 'apple':
        return Icons.apple;
      default:
        return Icons.email;
    }
  }

  String _getAuthProviderLabel(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return 'Google Account';
      case 'apple':
        return 'Apple ID';
      default:
        return 'Email Account';
    }
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_SettingsItem> items,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textDarkTheme
                      : AppTheme.textLightTheme,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1F2937)
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              indent: 56,
              color: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Icon(
                  item.icon,
                  color: isDark
                      ? AppTheme.textSubtleDark
                      : const Color(0xFF6B7280),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.textDarkTheme
                        : AppTheme.textLightTheme,
                  ),
                ),
                subtitle: item.subtitle != null
                    ? Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppTheme.textSubtleDark
                              : AppTheme.textSubtleLight,
                        ),
                      )
                    : null,
                trailing: item.trailing ??
                    (item.onTap != null
                        ? Icon(
                            Icons.chevron_right,
                            color: isDark
                                ? AppTheme.textSubtleDark
                                : const Color(0xFF9CA3AF),
                          )
                        : null),
                onTap: item.onTap,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        backgroundColor: isDark
            ? const Color(0xFF1F2937)
            : Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSubtleDark
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}
