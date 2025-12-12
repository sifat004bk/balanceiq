import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DateSelectorBottomSheet extends StatelessWidget {
  final Function(DateTime start, DateTime end) onDateSelected;

  const DateSelectorBottomSheet({
    super.key,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Text(
            'Select Period',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Presets Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildPresetChip(
                context,
                label: 'This Month',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month, 1);
                  final end = DateTime(now.year, now.month + 1, 0);
                  onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'Last Month',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month - 1, 1);
                  final end = DateTime(now.year, now.month, 0);
                  onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'Last 3 Months',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month - 2, 1);
                  // Current month end is usually preferred for "Last 3 Months" view (last 3 full months + current? or just rolling window?)
                  // Let's do rolling window: 3 months ago 1st to End of current month
                  final end = DateTime(now.year, now.month + 1, 0);
                  onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'This Year',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, 1, 1);
                  final end = DateTime(now.year, 12, 31);
                  onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // Custom Range Option
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.date_range, color: AppTheme.primaryColor),
            ),
            title: const Text('Custom Range'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              // Close bottom sheet first? No, await the picker result then close
              // But standard UX is usually to close sheet then open picker or open picker on top.
              // Let's open picker on top.
              Navigator.pop(context); // Close sheet
              
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: now.add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: AppTheme.primaryColor,
                            onPrimary: Colors.white,
                            surface: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null) {
                onDateSelected(picked.start, picked.end);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2E) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
