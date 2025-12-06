import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'gen_ui_chart.dart';
import 'gen_ui_table.dart';
import 'gen_ui_metric_card.dart';
import 'gen_ui_progress.dart';
import 'gen_ui_action_buttons.dart';
import 'gen_ui_animated_wrapper.dart';

class GenUICodeBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    // The element text content contains the code block content
    final String content = element.textContent;

    try {
      final jsonMap = jsonDecode(content);
      return null; // This base class won't be used directly.
    } catch (e) {
      return Text('Error parsing Gen UI: $e',
          style: const TextStyle(color: Colors.red));
    }
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
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUIChart(data: jsonMap),
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
      return GenUIAnimatedWrapper(
        delay: 100,
        child: GenUITable(data: jsonMap),
      );
    } catch (e) {
      return Text('Error rendering table: $e',
          style: const TextStyle(color: Colors.red));
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
