import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  final VoidCallback onTapProfileIcon, onTapNotificationIcon;
  final String profileUrl;

  const HomeAppbar({
    super.key,
    required this.summary,
    required this.onTapProfileIcon,
    required this.onTapNotificationIcon,
    required this.profileUrl,
  });

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        summary.period,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.27,
            ),
      ),
      // TODO: Add user profile picture and onpressed to settings
      leading: Padding(
        padding: const EdgeInsets.only(left: 12), // little breathing room
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
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: InkWell(
            onTap: onTapNotificationIcon,
            child: Icon(
              Icons.notifications_outlined,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
