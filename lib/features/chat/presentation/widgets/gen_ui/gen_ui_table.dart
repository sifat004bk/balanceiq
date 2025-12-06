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
              child: Row(
                children: columns
                    .map((col) => Expanded(
                          child: Text(
                            col,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: GeminiColors.primaryColor(context),
                              fontSize: 13,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            // Table Body
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowHeight: 0, // Hide default header
                  horizontalMargin: 16,
                  columnSpacing: 12,
                  dividerThickness: 0.5,
                  columns: columns
                      .map((col) => const DataColumn(label: SizedBox.shrink()))
                      .toList(),
                  rows: rows.asMap().entries.map((entry) {
                    final index = entry.key;
                    final row = entry.value;
                    final isEven = index % 2 == 0;
                    return DataRow(
                      color: WidgetStateProperty.all(
                        isEven
                            ? Colors.transparent
                            : GeminiColors.primaryColor(context).withOpacity(0.02),
                      ),
                      cells: row.map((cell) => DataCell(Text(
                        cell,
                        style: TextStyle(
                          color: GeminiColors.aiMessageText(context),
                          fontSize: 13,
                        ),
                      ))).toList(),
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
