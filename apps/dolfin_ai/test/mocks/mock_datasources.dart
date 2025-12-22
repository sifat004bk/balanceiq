import 'package:feature_auth/data/datasources/auth_local_datasource.dart';
import 'package:feature_auth/data/datasources/auth_remote_datasource.dart';
import 'package:feature_chat/data/datasources/chat_feedback_datasource.dart';
import 'package:feature_chat/data/datasources/chat_local_datasource.dart';
import 'package:feature_chat/data/datasources/chat_remote_datasource.dart';
import 'package:feature_chat/data/datasources/message_usage_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/transaction_search_datasource.dart';
import 'package:feature_subscription/data/datasources/subscription_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

class MockChatLocalDataSource extends Mock implements ChatLocalDataSource {}

class MockChatFeedbackDataSource extends Mock
    implements ChatFeedbackDataSource {}

class MockMessageUsageDataSource extends Mock
    implements MessageUsageDataSource {}

class MockDashboardRemoteDataSource extends Mock
    implements DashboardRemoteDataSource {}

class MockTransactionSearchDataSource extends Mock
    implements TransactionSearchDataSource {}

class MockSubscriptionDataSource extends Mock
    implements SubscriptionDataSource {}
