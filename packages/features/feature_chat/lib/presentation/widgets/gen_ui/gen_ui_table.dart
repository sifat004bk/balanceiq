import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/chart_data.dart';

class GenUITable extends StatelessWidget {
  final GenUITableData data;

  const GenUITable({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (!data.isValid) return const SizedBox.shrink();

    final columns = data.columnNames;
    final rows = data.rows;

    // Calculate a rough minimum width based on column count to ensure horizontal scrolling
    // 10 cols * ~100px = 1000px.
    final minWidth = columns.length * 120.0;

    // Calculate required height: Header (48) + Rows (count * 48) + minimal buffer
    const double rowHeight = 48.0;
    const double headingRowHeight = 48.0;
    final double requiredHeight = headingRowHeight + (rows.length * rowHeight);

    // Cap height at 400 or use required height if smaller
    // Ensure at least enough for header + 1 row (although isValid check handles empty)
    final double containerHeight =
        requiredHeight > 400.0 ? 400.0 : requiredHeight;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: containerHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // We use DataTable2 which handles sticky headers and specific styling
            Expanded(
              child: Theme(
                // Override DataTable theme to match our custom gradient look if possible,
                // or just use the available properties of DataTable2
                data: Theme.of(context).copyWith(
                  dividerColor:
                      Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  dataTableTheme: DataTableThemeData(
                    headingRowColor:
                        WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
                child: DataTable2(
                  minWidth: minWidth,
                  horizontalMargin: 16,
                  columnSpacing: 12, // Reduced spacing to fit more
                  headingRowHeight: 48,
                  dataRowHeight: 48,
                  dividerThickness: 0.5,
                  fixedTopRows: 1, // Sticky header
                  headingRowDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.15),
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  columns: columns
                      .map((col) => DataColumn2(
                            label: Text(
                              col.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            size: ColumnSize.L, // Let them be flexible
                          ))
                      .toList(),
                  rows: rows.asMap().entries.map((entry) {
                    final index = entry.key;
                    final rowMap = entry.value;
                    final isEven = index % 2 == 0;

                    return DataRow(
                      color: WidgetStateProperty.all(
                        isEven
                            ? Colors.transparent
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.02),
                      ),
                      cells: columns.map((colName) {
                        final cellValue = rowMap[colName]?.toString() ?? '';
                        return DataCell(
                          Text(
                            cellValue,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
