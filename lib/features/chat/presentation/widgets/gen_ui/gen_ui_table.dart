import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/gemini_colors.dart';
import '../../domain/entities/chart_data.dart';

class GenUITable extends StatelessWidget {
  final TableData data;

  const GenUITable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (!data.isValid) return const SizedBox.shrink();

    final columns = data.columnNames;
    final rows = data.rows;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: GeminiColors.divider(context).withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GeminiColors.primaryColor(context).withOpacity(0.15),
                    GeminiColors.primaryColor(context).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: columns
                      .map((col) => Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                              col.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GeminiColors.primaryColor(context),
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                      ))
                      .toList(),
                ),
              ),
            ),
            // Table Body
            Expanded(
              child: Scrollbar(
                 thumbVisibility: true,
                 trackVisibility: true,
                 thickness: 4,
                 radius: const Radius.circular(4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      headingRowHeight: 0, // Hide default header as we built a custom one
                      horizontalMargin: 16,
                      columnSpacing: 24,
                      dividerThickness: 0.5,
                      showCheckboxColumn: false,
                      columns: columns
                          .map((col) => const DataColumn(label: SizedBox.shrink()))
                          .toList(),
                      rows: rows.asMap().entries.map((entry) {
                        final index = entry.key;
                        final rowMap = entry.value;
                        final isEven = index % 2 == 0;
                        
                        return DataRow(
                          color: WidgetStateProperty.all(
                            isEven
                                ? Colors.transparent
                                : GeminiColors.primaryColor(context).withOpacity(0.02),
                          ),
                          cells: columns.map((colName) {
                            final cellValue = rowMap[colName]?.toString() ?? '';
                            return DataCell(
                              Text(
                                cellValue,
                                style: TextStyle(
                                  color: GeminiColors.aiMessageText(context),
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
