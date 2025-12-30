import 'package:dolfin_ui_kit/theme/app_palette.dart';
import 'package:get_it/get_it.dart';
import 'package:balance_iq/core/strings/dashboard_strings.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DateSelectorBottomSheet extends StatefulWidget {
  final Function(DateTime start, DateTime end) onDateSelected;
  final VoidCallback? onCustomRangePressed;

  const DateSelectorBottomSheet({
    super.key,
    required this.onDateSelected,
    this.onCustomRangePressed,
  });

  @override
  State<DateSelectorBottomSheet> createState() =>
      _DateSelectorBottomSheetState();
}

class _DateSelectorBottomSheetState extends State<DateSelectorBottomSheet> {
  String? _selectedPreset = 'last_30_days';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 32, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).cardColor,
            Theme.of(context).cardColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gradient Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ]),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // Title with text shadow
          Text(
            GetIt.I<DashboardStrings>().selectDateRange,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              letterSpacing: -0.5,
              shadows: [
                Shadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Presets Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildPresetChip(
                context,
                label: 'This Month',
                presetKey: 'this_month',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month, 1);
                  final end = DateTime(now.year, now.month + 1, 0);
                  widget.onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'Last Month',
                presetKey: 'last_month',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month - 1, 1);
                  final end = DateTime(now.year, now.month, 0);
                  widget.onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'Last 3 Months',
                presetKey: 'last_3_months',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month - 2, 1);
                  final end = DateTime(now.year, now.month + 1, 0);
                  widget.onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'Last 30 Days',
                presetKey: 'last_30_days',
                onTap: () {
                  final now = DateTime.now();
                  final start = now.subtract(const Duration(days: 30));
                  final end = now;
                  widget.onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
              _buildPresetChip(
                context,
                label: 'This Year',
                presetKey: 'this_year',
                onTap: () {
                  final now = DateTime.now();
                  final start = DateTime(now.year, 1, 1);
                  final end = DateTime(now.year, 12, 31);
                  widget.onDateSelected(start, end);
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Divider with gradient
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          InkWell(
            onTap: () {
              if (widget.onCustomRangePressed != null) {
                widget.onCustomRangePressed!();
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor.withValues(alpha: 0.5),
                    Theme.of(context).cardColor.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.calendar,
                      color: GetIt.instance<AppPalette>().white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      GetIt.I<DashboardStrings>().customRange,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).hintColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(
    BuildContext context, {
    required String label,
    required String presetKey,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedPreset == presetKey;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: isSelected ? 1.05 : 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPreset = presetKey;
          });
          Future.delayed(const Duration(milliseconds: 150), onTap);
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ])
                : null,
            color: isSelected ? null : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).hintColor,
                ),
          ),
        ),
      ),
    );
  }
}
