import 'package:balance_iq/features/home/presentation/widgets/calendar_widgets/calendar_date_cell.dart';
import 'package:flutter/material.dart';

class CalendarMonthView extends StatelessWidget {
  final DateTime displayedMonth;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime today;
  final Function(DateTime) onDateSelected;
  final DateTime? minDate;
  final DateTime? maxDate;

  const CalendarMonthView({
    super.key,
    required this.displayedMonth,
    this.startDate,
    this.endDate,
    required this.today,
    required this.onDateSelected,
    this.minDate,
    this.maxDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Day of week headers
        _buildDayHeaders(context),
        const SizedBox(height: 8),
        // Calendar grid
        _buildCalendarGrid(context),
      ],
    );
  }

  Widget _buildDayHeaders(BuildContext context) {
    final dayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Row(
      children: dayNames.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final firstDayOfMonth =
        DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = ((firstWeekday + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekday + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          // Empty cell or previous/next month days
          return const SizedBox.shrink();
        }

        final date =
            DateTime(displayedMonth.year, displayedMonth.month, dayNumber);
        final cellType = _getCellType(date);
        final isDisabled = _isDisabled(date);

        return CalendarDateCell(
          day: dayNumber,
          isCurrentMonth: true,
          cellType: cellType,
          isDisabled: isDisabled,
          onTap: () => onDateSelected(date),
        );
      },
    );
  }

  DateCellType _getCellType(DateTime date) {
    bool isSameDay(DateTime d1, DateTime d2) =>
        d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

    // Check if it's the start date
    if (startDate != null && isSameDay(date, startDate!)) {
      return DateCellType.startDate;
    }

    // Check if it's the end date
    if (endDate != null && isSameDay(date, endDate!)) {
      return DateCellType.endDate;
    }

    // Check if it's in range
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return DateCellType.inRange;
      }
    }

    // Check if it's today
    if (isSameDay(date, today)) {
      return DateCellType.today;
    }

    return DateCellType.normal;
  }

  bool _isDisabled(DateTime date) {
    if (minDate != null && date.isBefore(minDate!)) {
      return true;
    }
    if (maxDate != null && date.isAfter(maxDate!)) {
      return true;
    }
    return false;
  }
}
