import 'package:flutter/material.dart';

enum DateCellType {
  normal,
  today,
  startDate,
  endDate,
  inRange,
  disabled,
}

class CalendarDateCell extends StatelessWidget {
  final int day;
  final bool isCurrentMonth;
  final DateCellType cellType;
  final VoidCallback onTap;
  final bool isDisabled;

  const CalendarDateCell({
    super.key,
    required this.day,
    required this.isCurrentMonth,
    required this.cellType,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 1.0, end: 1.0),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: _getBackgroundGradient(context, isDark),
            color: _getBackgroundColor(context, isDark),
            borderRadius: _getBorderRadius(),
            border: _getBorder(context, isDark),
            boxShadow: _getBoxShadow(context, isDark),
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getTextColor(context, isDark),
                    fontWeight: _getFontWeight(),
                    fontSize: 15,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient? _getBackgroundGradient(BuildContext context, bool isDark) {
    if (isDisabled) return null;

    switch (cellType) {
      case DateCellType.startDate:
      case DateCellType.endDate:
        return LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return null;
    }
  }

  Color? _getBackgroundColor(BuildContext context, bool isDark) {
    if (!isCurrentMonth || isDisabled) {
      return Colors.transparent;
    }

    switch (cellType) {
      case DateCellType.startDate:
      case DateCellType.endDate:
        return null; // Uses gradient
      case DateCellType.inRange:
        return Theme.of(context).primaryColor.withOpacity(0.1);
      case DateCellType.today:
        return Colors.transparent;
      default:
        return Colors.transparent;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (cellType) {
      case DateCellType.startDate:
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        );
      case DateCellType.endDate:
        return const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        );
      case DateCellType.inRange:
        return BorderRadius.circular(4);
      default:
        return BorderRadius.circular(20);
    }
  }

  Border? _getBorder(BuildContext context, bool isDark) {
    if (cellType == DateCellType.today && isCurrentMonth) {
      return Border.all(
        color: Theme.of(context).primaryColor,
        width: 2,
      );
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow(BuildContext context, bool isDark) {
    if (cellType == DateCellType.startDate ||
        cellType == DateCellType.endDate) {
      return [
        BoxShadow(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    }

    if (cellType == DateCellType.today && isDark) {
      return [
        BoxShadow(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ];
    }

    return null;
  }

  Color _getTextColor(BuildContext context, bool isDark) {
    if (!isCurrentMonth) {
      return Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3) ??
          Colors.grey;
    }

    if (isDisabled) {
      return Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5) ??
          Colors.grey;
    }

    switch (cellType) {
      case DateCellType.startDate:
      case DateCellType.endDate:
        return Theme.of(context).colorScheme.onPrimary;
      case DateCellType.today:
        return Theme.of(context).primaryColor;
      default:
        return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    }
  }

  FontWeight _getFontWeight() {
    switch (cellType) {
      case DateCellType.startDate:
      case DateCellType.endDate:
      case DateCellType.today:
        return FontWeight.w800;
      default:
        return FontWeight.w600;
    }
  }
}
