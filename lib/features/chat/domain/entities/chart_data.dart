import 'package:equatable/equatable.dart';

/// Dataset for chart rendering
class ChartDataset extends Equatable {
  final String label;
  final List<num> data;

  const ChartDataset({
    required this.label,
    required this.data,
  });

  factory ChartDataset.fromJson(Map<String, dynamic> json) {
    return ChartDataset(
      label: json['label'] as String,
      data: (json['data'] as List).map((e) => e as num).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'data': data,
    };
  }

  @override
  List<Object?> get props => [label, data];

  @override
  String toString() =>
      'ChartDataset(label: $label, dataPoints: ${data.length})';
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

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      labels: (json['labels'] as List).map((e) => e as String).toList(),
      datasets: (json['datasets'] as List)
          .map((e) => ChartDataset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'datasets': datasets.map((e) => e.toJson()).toList(),
    };
  }

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
/// Table data entity for rendering tables
/// Represents a list of rows where each row is a map of column name to value
class GenUITableData extends Equatable {
  final List<Map<String, dynamic>> rows;

  const GenUITableData({
    required this.rows,
  });

  factory GenUITableData.fromJson(Map<String, dynamic> json) {
    // Handle both 'rows' key or direct list if simplified structure
    if (json.containsKey('rows')) {
      return GenUITableData(
        rows: (json['rows'] as List).cast<Map<String, dynamic>>(),
      );
    }
    // Fallback if structure is different
    return const GenUITableData(rows: []);
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
    };
  }

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
  String toString() => 'GenUITableData(rows: $rowCount, columns: $columnCount)';
}
