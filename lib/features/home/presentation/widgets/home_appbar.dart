import 'package:balance_iq/core/theme/app_palette.dart';
import 'package:balance_iq/core/widgets/glass_presets.dart';
import 'package:balance_iq/core/theme/theme_cubit.dart';
import 'package:balance_iq/core/theme/theme_state.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppbar extends StatelessWidget {
  final VoidCallback onTapProfileIcon;
  final String profileUrl;
  final String displayDate;
  final GlobalKey? profileIconKey;

  const HomeAppbar({
    super.key,
    required this.summary,
    required this.onTapProfileIcon,
    required this.profileUrl,
    required this.displayDate,
    this.onTapDateRange,
    this.profileIconKey,
  });

  final DashboardSummary summary;
  final VoidCallback? onTapDateRange;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              Icon(
                Icons.arrow_drop_down_rounded,
                color: Theme.of(context).textTheme.titleMedium?.color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: InkWell(
          key: profileIconKey,
          onTap: onTapProfileIcon,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isDark
                  ? LinearGradient(colors: [
                      AppPalette.trustBlue,
                      AppPalette.trustBlue.withOpacity(0.8)
                    ])
                  : LinearGradient(colors: [
                      AppPalette.trustBlue,
                      AppPalette.trustBlue.withOpacity(0.8)
                    ]),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppPalette.trustBlue : AppPalette.trustBlue)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: profileUrl.isEmpty
                  ? Icon(
                      Icons.person_rounded,
                      size: 20,
                      color:
                          isDark ? AppPalette.trustBlue : AppPalette.trustBlue,
                    )
                  : ClipOval(
                      child: Image.network(
                        profileUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person_rounded,
                            size: 20,
                            color: isDark
                                ? AppPalette.trustBlue
                                : AppPalette.trustBlue,
                          );
                        },
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
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size: 20,
                    color: isDark ? AppPalette.trustBlue : AppPalette.trustBlue,
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
