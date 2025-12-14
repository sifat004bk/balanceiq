import 'dart:ui';
import 'package:balance_iq/core/theme/app_theme.dart';
import 'package:balance_iq/features/home/presentation/widgets/custom_calendar_date_range_picker.dart';
import 'package:flutter/material.dart';

class DateSelectorBottomSheet extends StatefulWidget {
  final Function(DateTime start, DateTime end) onDateSelected;

  const DateSelectorBottomSheet({
    super.key,
    required this.onDateSelected,
  });

  @override
  State<DateSelectorBottomSheet> createState() => _DateSelectorBottomSheetState();
}

class _DateSelectorBottomSheetState extends State<DateSelectorBottomSheet> {
  String? _selectedPreset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 32, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppTheme.surfaceDark,
                  AppTheme.backgroundDark,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : LinearGradient(
                colors: [
                  AppTheme.surfaceLight,
                  AppTheme.backgroundLight,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
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
                gradient: isDark
                    ? AppTheme.primaryGradientDark
                    : AppTheme.primaryGradientLight,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // Title with text shadow
          Text(
            'Select Period',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              letterSpacing: -0.5,
              shadows: isDark
                  ? [
                      Shadow(
                        color: AppTheme.primaryDark.withOpacity(0.3),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
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
                  (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                      .withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          InkWell(
            onTap: () async {
              Navigator.pop(context);
              
              final now = DateTime.now();
              
              // Show custom calendar picker
              await showDialog(
                context: context,
                builder: (context) => CustomCalendarDateRangePicker(
                  minDate: DateTime(2020),
                  maxDate: now.add(const Duration(days: 365)),
                  onDateRangeSelected: (startDate, endDate) {
                    widget.onDateSelected(startDate, endDate);
                  },
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        colors: [
                          AppTheme.surfaceVariantDark.withOpacity(0.5),
                          AppTheme.surfaceVariantDark.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          AppTheme.surfaceVariantLight,
                          AppTheme.surfaceVariantLight.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? AppTheme.primaryGradientDark
                          : AppTheme.primaryGradientLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                              .withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.date_range_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Custom Range',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? AppTheme.textSubtleDark : AppTheme.textSubtleLight,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                ? (isDark
                    ? AppTheme.primaryGradientDark
                    : AppTheme.primaryGradientLight)
                : null,
            color: isSelected
                ? null
                : (isDark
                    ? AppTheme.surfaceVariantDark.withOpacity(0.5)
                    : AppTheme.surfaceVariantLight),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected
                  ? (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                  : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08)),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
                          .withOpacity(0.3),
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
                      ? Colors.white
                      : (isDark ? AppTheme.textDarkTheme : AppTheme.textLightTheme),
                ),
          ),
        ),
      ),
    );
  }
}
