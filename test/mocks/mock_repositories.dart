import 'package:balance_iq/features/auth/domain/repositories/auth_repository.dart';
import 'package:balance_iq/features/chat/domain/repositories/chat_feedback_repository.dart';
import 'package:balance_iq/features/chat/domain/repositories/chat_repository.dart';
import 'package:balance_iq/features/chat/domain/repositories/message_usage_repository.dart';
import 'package:balance_iq/features/home/domain/repositories/transaction_repository.dart';
import 'package:balance_iq/features/home/domain/repository/dashboard_repository.dart';
import 'package:balance_iq/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockChatRepository extends Mock implements ChatRepository {}

class MockChatFeedbackRepository extends Mock
    implements ChatFeedbackRepository {}

class MockMessageUsageRepository extends Mock
    implements MessageUsageRepository {}

class MockDashboardRepository extends Mock implements DashboardRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}
