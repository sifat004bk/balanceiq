import '../../domain/entities/chart_data.dart';

/// Data model for ChartDataset
class ChartDatasetModel extends ChartDataset {
  const ChartDatasetModel({
    required super.label,
    required super.data,
  });

  factory ChartDatasetModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return ChartDatasetModel(
      label: json['label'] as String? ?? '',
      data: dataList.map((e) => (e as num)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'data': data,
    };
  }

  factory ChartDatasetModel.fromEntity(ChartDataset entity) {
    return ChartDatasetModel(
      label: entity.label,
      data: entity.data,
    );
  }
}

/// Data model for GraphData
class GraphDataModel extends GraphData {
  const GraphDataModel({
    required super.labels,
    required super.datasets,
  });

  factory GraphDataModel.fromJson(Map<String, dynamic> json) {
    final labelsList = json['labels'] as List<dynamic>? ?? [];
    final datasetsList = json['datasets'] as List<dynamic>? ?? [];

    return GraphDataModel(
      labels: labelsList.map((e) => e.toString()).toList(),
      datasets: datasetsList
          .map((e) => ChartDatasetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'datasets': datasets
          .map((d) => ChartDatasetModel.fromEntity(d).toJson())
          .toList(),
    };
  }

  factory GraphDataModel.fromEntity(GraphData entity) {
    return GraphDataModel(
      labels: entity.labels,
      datasets: entity.datasets,
    );
  }

  GraphData toEntity() {
    return GraphData(
      labels: labels,
      datasets: datasets,
    );
  }
}

/// Data model for TableData
class TableDataModel extends GenUITableData {
  const TableDataModel({
    required super.rows,
  });

  factory TableDataModel.fromList(List<dynamic> json) {
    return TableDataModel(
      rows: json
          .map((row) => Map<String, dynamic>.from(row as Map<dynamic, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
    };
  }

  factory TableDataModel.fromEntity(GenUITableData entity) {
    return TableDataModel(
      rows: entity.rows,
    );
  }

  GenUITableData toEntity() {
    return GenUITableData(
      rows: rows,
    );
  }
}
