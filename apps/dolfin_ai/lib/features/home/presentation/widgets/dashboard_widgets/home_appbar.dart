import 'package:dolfin_ui_kit/widgets/glass_presets.dart';
import 'package:dolfin_ui_kit/theme/theme_cubit.dart';
import 'package:dolfin_ui_kit/theme/theme_state.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:balance_iq/core/icons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomeAppbar extends StatelessWidget {
  final VoidCallback onTapProfileIcon;
  final String profileUrl;
  final String displayDate;
  final GlobalKey? profileIconKey;
  final String userName;

  const HomeAppbar({
    super.key,
    required this.summary,
    required this.onTapProfileIcon,
    required this.profileUrl,
    required this.displayDate,
    this.onTapDateRange,
    this.profileIconKey,
    this.userName = '',
  });

  final DashboardSummary summary;
  final VoidCallback? onTapDateRange;

  String _getInitial() {
    if (userName.isNotEmpty) {
      return userName[0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: InkWell(
        onTap: onTapDateRange,
        borderRadius: BorderRadius.circular(50),
        child: ThemedGlass.container(
          context: context,
          preset: GlassPreset.subtle,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 50,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayDate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
              ),
              const SizedBox(width: 4),
              GetIt.I<AppIcons>().navigation.chevronDown(
                    size: 20,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
            ],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          key: profileIconKey,
          onTap: onTapProfileIcon,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(2),
            child: profileUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    backgroundImage: NetworkImage(profileUrl),
                    onBackgroundImageError: (_, __) {},
                  )
                : CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      _getInitial(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            // Check actual brightness instead of just theme mode
            // This properly handles ThemeMode.system
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return ThemedGlass.container(
              context: context,
              preset: GlassPreset.subtle,
              borderRadius: 50,
              child: InkWell(
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  child: isDark
                      ? GetIt.I<AppIcons>().dashboard.lightMode(
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          )
                      : GetIt.I<AppIcons>().dashboard.darkMode(
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
