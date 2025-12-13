import 'package:equatable/equatable.dart';

/// Dataset for chart rendering
class ChartDataset extends Equatable {
  final String label;
  final List<num> data;

  const ChartDataset({
    required this.label,
    required this.data,
  });

  @override
  List<Object?> get props => [label, data];

  @override
  String toString() => 'ChartDataset(label: $label, dataPoints: ${data.length})';
}

/// Graph/Chart data entity for rendering visualizations
/// Compatible with Chart.js format
class GraphData extends Equatable {
  final List<String> labels;
  final List<ChartDataset> datasets;

  const GraphData({
    required this.labels,
    required this.datasets,
  });

  @override
  List<Object?> get props => [labels, datasets];

  /// Check if graph data is valid for rendering
  bool get isValid => labels.isNotEmpty && datasets.isNotEmpty;

  /// Get the number of data points
  int get dataPointCount => labels.length;

  /// Get the number of datasets
  int get datasetCount => datasets.length;

  @override
  String toString() =>
      'GraphData(labels: ${labels.length}, datasets: ${datasets.length})';
}

/// Supported graph types
enum GraphType {
  line('line'),
  bar('bar');

  final String value;
  const GraphType(this.value);

  static GraphType? fromString(String? value) {
    if (value == null) return null;
    return GraphType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => GraphType.bar,
    );
  }
}

/// Table data entity for rendering tables
/// Represents a list of rows where each row is a map of column name to value
class TableData extends Equatable {
  final List<Map<String, dynamic>> rows;

  const TableData({
    required this.rows,
  });

  @override
  List<Object?> get props => [rows];

  /// Check if table data is valid for rendering
  bool get isValid => rows.isNotEmpty;

  /// Get the number of rows
  int get rowCount => rows.length;

  /// Get column names from the first row
  List<String> get columnNames {
    if (rows.isEmpty) return [];
    return rows.first.keys.toList();
  }

  /// Get column count
  int get columnCount => columnNames.length;

  @override
  String toString() => 'TableData(rows: $rowCount, columns: $columnCount)';
}
