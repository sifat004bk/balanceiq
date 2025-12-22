import 'package:flutter/material.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';

class GenUIActionButtons extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIActionButtons({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final actions = (data['actions'] as List).cast<Map<String, dynamic>>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions.map((action) {
          final label = action['label'] as String;
          final iconName = action['icon'] as String?;
          final style = action['style'] as String? ?? 'primary';

          return _buildActionButton(context, label, iconName, style);
        }).toList(),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String? iconName,
    String style,
  ) {
    final isPrimary = style == 'primary';
    final backgroundColor =
        isPrimary ? Theme.of(context).colorScheme.primary : Colors.transparent;
    final foregroundColor = isPrimary
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.primary;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      elevation: isPrimary ? 2 : 0,
      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      child: InkWell(
        onTap: () {
          // Show feedback for button tap
          SnackbarUtils.showInfo(
            context,
            '$label - ${GetIt.I<ChatStrings>().comingSoon}',
            duration: const Duration(seconds: 2),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isPrimary
                ? null
                : Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconName != null) ...[
                Icon(_getIcon(iconName), size: 18, color: foregroundColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'add':
        return Icons.add;
      case 'view':
        return Icons.visibility;
      case 'edit':
        return Icons.edit;
      case 'chart':
        return Icons.bar_chart;
      case 'details':
        return Icons.info_outline;
      case 'history':
        return Icons.history;
      case 'settings':
        return Icons.settings;
      case 'refresh':
        return Icons.refresh;
      case 'download':
        return Icons.download;
      case 'share':
        return Icons.share;
      default:
        return Icons.touch_app;
    }
  }
}
