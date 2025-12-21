import 'package:balance_iq/core/constants/app_strings.dart';
import 'package:balance_iq/features/chat/presentation/widgets/floating_chat_input_widgets/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('ChatTextField', () {
    late TextEditingController controller;
    late FocusNode focusNode;

    setUp(() {
      controller = TextEditingController();
      focusNode = FocusNode();
    });

    tearDown(() async {
      // Unmount the widget to detach the FocusNode
      // We can't access tester here easily in tearDown without passing it,
      // so better to do it in test or make tearDown take specific action?
      // Actually, flutter_test's setUp/tearDown don't take arguments.
      // But we can use addTearDown within the test if we need tester.
      // However, usually disposing in tearDown is fine if the test finished.
      // The issue is likely that the widget is still in the tree.
      // controller.dispose();
      // focusNode.dispose();
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ChatTextField(
            controller: controller,
            focusNode: focusNode,
            isLimitReached: false,
            isDark: false,
          ),
        ),
      );
      expect(find.byType(ChatTextField), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    testWidgets('shows general hint when limit not reached', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ChatTextField(
            controller: controller,
            focusNode: focusNode,
            isLimitReached: false,
            isDark: false,
          ),
        ),
      );
      expect(
          find.text(AppStrings.chat.inputPlaceholderGeneral), findsOneWidget);
      await tester.pumpWidget(Container()); // Dispose widget
    });

    testWidgets('shows limit reached hint when limit reached', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ChatTextField(
            controller: controller,
            focusNode: focusNode,
            isLimitReached: true,
            isDark: false,
          ),
        ),
      );
      expect(find.text(AppStrings.chat.limitReached), findsOneWidget);
      await tester.pumpWidget(Container());
    });

    testWidgets('is disabled when limit reached', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ChatTextField(
            controller: controller,
            focusNode: focusNode,
            isLimitReached: true,
            isDark: false,
          ),
        ),
      );
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, false);
      await tester.pumpWidget(Container());
    });

    testWidgets('updates text when typing', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: ChatTextField(
            controller: controller,
            focusNode: focusNode,
            isLimitReached: false,
            isDark: false,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pumpAndSettle();
      expect(controller.text, 'Hello');
      await tester.pumpWidget(Container());
    });
  });
}
