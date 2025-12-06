import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/gemini_colors.dart';

class GenUITable extends StatelessWidget {
  final Map<String, dynamic> data;

  const GenUITable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final columns = (data['columns'] as List).cast<String>();
    final rows = (data['rows'] as List).map((row) => (row as List).cast<String>()).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 300, // Fixed height for scrollable table
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GeminiColors.divider(context)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600, // Ensure horizontal scrolling on small screens
          headingRowColor: WidgetStateProperty.all(
            GeminiColors.primaryColor(context).withOpacity(0.1),
          ),
          columns: columns
              .map((col) => DataColumn2(
                    label: Text(
                      col,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row.map((cell) => DataCell(Text(cell))).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
