import 'package:balance_iq/features/auth/domain/entities/user.dart';

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
}
