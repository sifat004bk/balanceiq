import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import '../../../domain/entities/chart_data.dart' as charts;
import 'gen_ui_chart.dart';
import 'gen_ui_table.dart';
import 'gen_ui_metric_card.dart';
import 'gen_ui_progress.dart';
import 'gen_ui_action_buttons.dart';
import 'gen_ui_animated_wrapper.dart';
import 'gen_ui_stats.dart';
import 'gen_ui_insight_card.dart';
import 'gen_ui_summary_card.dart';
import 'gen_ui_action_list.dart';

class GenUICodeBuilder extends MarkdownElementBuilder {
  // Base class not used directly
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return null;
  }
}

class GenUIChartBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      
      final graphData = charts.GraphData.fromJson(jsonMap);
      final graphType = charts.GraphType.fromString(jsonMap['type'] as String?);
      final title = jsonMap['title'] as String?;

      if (graphType == null) {
          return const Text('Error rendering chart: Missing or invalid chart type', style: TextStyle(color: Colors.red));
      }

      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIChart(
            data: graphData, 
            type: graphType,
            title: title,
        ),
      );
    } catch (e) {
      return Text('Error rendering chart: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUITableBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      
      // If the JSON is directly the TableData structure
      final tableData = charts.GenUITableData.fromJson(jsonMap);

      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUITable(data: tableData),
      );
    } catch (e) {
      // Fallback for potential legacy format or errors
      return Text('Error rendering table: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUISummaryCardBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUISummaryCard(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering summary card: $e', style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUIActionListBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIActionList(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering action list: $e', style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUIMetricCardBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIMetricCard(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering metric card: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUIProgressBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIProgress(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering progress: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUIActionButtonsBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 150,
        child: GenUIActionButtons(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering action buttons: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUIStatsBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIStats(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering stats: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}

class GenUIInsightCardBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    try {
      final content = element.textContent;
      final jsonMap = jsonDecode(content);
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIInsightCard(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering insight card: $e',
          style: const TextStyle(color: Colors.red));
    }
  }
}
