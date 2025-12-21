import 'package:balance_iq/features/auth/domain/entities/user.dart';
import 'package:balance_iq/features/chat/domain/entities/message.dart';

class TestFixtures {
  static final user = User(
    id: 'test_user_id',
    email: 'test@example.com',
    name: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
    authProvider: 'email',
    createdAt: DateTime(2023, 1, 1),
    isEmailVerified: true,
  );

  static final message = Message(
    id: 'test_message_id',
    userId: 'test_user_id',
    botId: 'test_bot_id',
    sender: 'user',
    content: 'Test Message Content',
    timestamp: DateTime(2023, 1, 1),
    imageUrl: 'https://example.com/image.jpg',
  );
}
