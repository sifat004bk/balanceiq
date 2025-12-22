import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:feature_chat/constants/chat_strings.dart';
import 'package:dolfin_core/constants/core_strings.dart';
import '../../../domain/entities/message.dart';
import '../../cubit/chat_cubit.dart';

import '../gen_ui/gen_ui_builder.dart';
import '../gen_ui/gen_ui_chart.dart';
import '../gen_ui/gen_ui_table.dart';

class AiMessageContent extends StatelessWidget {
  final Message message;
  final bool isLastMessage;

  const AiMessageContent({
    super.key,
    required this.message,
    this.isLastMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content
        if (message.content.isNotEmpty)
          MarkdownBody(
            data: message.content,
            selectable: true,
            builders: {
              'ui:chart': GenUIChartBuilder(),
              'ui:table': GenUITableBuilder(),
              'ui:summary_card': GenUISummaryCardBuilder(),
              'ui:action_list': GenUIActionListBuilder(),
              'ui:metric': GenUIMetricCardBuilder(),
              'ui:progress': GenUIProgressBuilder(),
              'ui:actions': GenUIActionButtonsBuilder(),
              'ui:stats': GenUIStatsBuilder(),
              'ui:insight': GenUIInsightCardBuilder(),
            },
            styleSheet: MarkdownStyleSheet(
              p: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 16,
                height: 1.5,
              ),
              h1: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              h2: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              h3: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              h4: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              h5: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              h6: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              code: textTheme.bodyMedium?.copyWith(
                fontFamily: 'Google Sans Mono',
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
              codeblockDecoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              blockquote: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
                fontStyle: FontStyle.italic,
              ),
              blockquoteDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: colorScheme.primary,
                    width: 4,
                  ),
                ),
              ),
              listBullet: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              tableBody: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              tableHead: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              a: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              em: const TextStyle(fontStyle: FontStyle.italic),
              strong: const TextStyle(fontWeight: FontWeight.bold),
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.surfaceContainerHighest,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 4),

        // GenUI Table
        if (message.hasTable && message.tableData != null) ...[
          GenUITable(data: message.tableData!),
          const SizedBox(height: 4),
        ],

        // GenUI Chart
        if (message.graphType != null && message.graphData != null) ...[
          GenUIChart(data: message.graphData!, type: message.graphType!),
          const SizedBox(height: 4),
        ],

        // Action Type Display & Change Button
        if (message.actionType != null &&
            (message.actionType!.toLowerCase() == 'record_income' ||
                message.actionType!.toLowerCase() == 'record_expense')) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatActionType(message.actionType!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).hintColor,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                if (isLastMessage) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showActionTypeOptions(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        GetIt.I<ChatStrings>().change,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }

  String _formatActionType(String type) {
    switch (type.toLowerCase()) {
      case 'record_income':
        return GetIt.I<ChatStrings>().recordedIncome;
      case 'record_expense':
        return GetIt.I<ChatStrings>().recordedExpense;
      default:
        return '';
    }
  }

  void _showActionTypeOptions(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  GetIt.I<ChatStrings>().changeActionType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading:
                      const Icon(Icons.arrow_downward, color: Colors.green),
                  title: Text(GetIt.I<CoreStrings>().dashboard.income),
                  onTap: () {
                    Navigator.pop(context);
                    _sendCorrectionMessage(chatCubit, 'income');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward, color: Colors.red),
                  title: Text(GetIt.I<CoreStrings>().dashboard.expense),
                  onTap: () {
                    Navigator.pop(context);
                    _sendCorrectionMessage(chatCubit, 'expense');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendCorrectionMessage(ChatCubit chatCubit, String newType) {
    final correctionText =
        "change the actiontype of the last entry as $newType";
    chatCubit.sendNewMessage(
      botId: message.botId,
      content: correctionText,
    );
  }
}
