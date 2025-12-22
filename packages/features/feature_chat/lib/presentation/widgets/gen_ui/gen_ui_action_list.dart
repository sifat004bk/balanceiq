import 'package:feature_chat/constants/chat_strings.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class GenUIActionList extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUIActionList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String?;
    final actions = (data['actions'] as List).cast<Map<String, dynamic>>();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actions.map((action) {
              return ActionChip(
                avatar: Icon(
                  _getIconForAction(action['action']),
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: Text(
                  action['label'] ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  SnackbarUtils.showInfo(
                    context,
                    GetIt.I<ChatStrings>()
                        .actionTriggered(action['action']?.toString() ?? ''),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getIconForAction(String? action) {
    if (action == null) return Icons.touch_app;
    if (action.contains('budget')) return Icons.pie_chart;
    if (action.contains('limit')) return Icons.speed;
    if (action.contains('view')) return Icons.visibility;
    return Icons.arrow_forward;
  }
}
