import 'package:balance_iq/features/chat/presentation/widgets/floating_chat_input_widgets/chat_send_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('ChatSendButton', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        ChatSendButton(
          onTap: () {},
          isEnabled: true,
          isDark: false,
        ),
      );
      expect(find.byType(ChatSendButton), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    });

    testWidgets('calls onTap when enabled and tapped', (tester) async {
      bool tapped = false;
      await tester.pumpApp(
        ChatSendButton(
          onTap: () => tapped = true,
          isEnabled: true,
          isDark: false,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ChatSendButton), warnIfMissed: false);
      expect(tapped, true);
    });

    testWidgets('does not call onTap when disabled', (tester) async {
      bool tapped = false;
      await tester.pumpApp(
        ChatSendButton(
          onTap: () => tapped = true,
          isEnabled: false,
          isDark: false,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ChatSendButton), warnIfMissed: false);
      expect(tapped, false);
    });
  });
}
