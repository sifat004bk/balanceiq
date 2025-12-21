import 'package:balance_iq/features/chat/presentation/widgets/message_bubble_widgets/user_message_bubble.dart';
import 'package:balance_iq/features/chat/presentation/widgets/message_bubble_widgets/chat_message_image_view.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:balance_iq/features/chat/domain/entities/message.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('UserMessageBubble', () {
    final message = Message(
      id: '1',
      userId: 'user1',
      botId: 'bot1',
      sender: 'user',
      content: 'Hello World',
      timestamp: DateTime.now(),
    );

    testWidgets('renders content correctly', (tester) async {
      await tester.pumpApp(
        UserMessageBubble(message: message),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('shows image when imageUrl is present', (tester) async {
      final messageWithImage = message.copyWith(
        imageUrl: 'assets/test_image.png',
      );

      await tester.pumpApp(
        UserMessageBubble(message: messageWithImage),
      );

      expect(find.byType(ChatMessageImageView), findsOneWidget);
    });

    testWidgets('does not show image when imageUrl is null', (tester) async {
      final messageNoImage = message.copyWith(imageUrl: null);

      await tester.pumpApp(
        UserMessageBubble(message: messageNoImage),
      );

      expect(find.byType(ChatMessageImageView), findsNothing);
    });
  });
}
