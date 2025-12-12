import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/core/theme/theme_cubit.dart';
import 'package:balance_iq/core/theme/theme_state.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppbar extends StatelessWidget {
  final VoidCallback onTapProfileIcon;
  final String profileUrl;
  final String displayDate;

  const HomeAppbar({
    super.key,
    required this.summary,
    required this.onTapProfileIcon,
    required this.profileUrl,
    required this.displayDate,
    this.onTapDateRange,
  });

  final DashboardSummary summary;
  final VoidCallback? onTapDateRange;

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
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayDate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.27,
                    ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: InkWell(
          onTap: onTapProfileIcon,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: profileUrl.isEmpty
                ? Icon(
                    Icons.person,
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileUrl),
                    backgroundColor: Colors.transparent,
                  ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDark = themeState is ThemeLoaded &&
                themeState.themeMode == ThemeMode.dark;

            return Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: InkWell(
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                borderRadius: BorderRadius.circular(50),
                child: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  size: 20,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
