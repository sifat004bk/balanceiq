import 'package:flutter/material.dart';
import '../../../../../core/constants/gemini_colors.dart';

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
                    color: GeminiColors.textSecondary(context),
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
                  color: GeminiColors.primaryColor(context),
                ),
                label: Text(
                  action['label'] ?? '',
                  style: TextStyle(
                    color: GeminiColors.primaryColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: GeminiColors.primaryColor(context).withOpacity(0.1),
                side: BorderSide(
                  color: GeminiColors.primaryColor(context).withOpacity(0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Action triggered: ${action['action']}')),
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
