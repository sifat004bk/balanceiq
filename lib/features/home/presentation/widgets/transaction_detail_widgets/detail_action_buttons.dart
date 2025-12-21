import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Delete and Save/Edit action buttons
class DetailActionButtons extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onDelete;
  final VoidCallback onSaveOrEdit;

  const DetailActionButtons({
    super.key,
    required this.isEditMode,
    required this.onDelete,
    required this.onSaveOrEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 20),
              label: Text(AppStrings.common.delete),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms)
                .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 300.ms),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onSaveOrEdit,
              icon: Icon(isEditMode ? Icons.check : Icons.edit, size: 20),
              label: Text(isEditMode
                  ? AppStrings.common.saveChanges
                  : AppStrings.common.edit),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 450.ms, duration: 300.ms)
                .slideY(begin: 0.2, end: 0, delay: 450.ms, duration: 300.ms),
          ),
        ],
      ),
    );
  }
}
