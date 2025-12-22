import 'package:feature_chat/data/datasources/chat_feedback_datasource.dart';
import 'package:feature_chat/data/datasources/chat_local_datasource.dart';
import 'package:feature_chat/data/datasources/chat_remote_datasource.dart';
import 'package:feature_chat/data/datasources/message_usage_datasource.dart';
import 'package:feature_chat/domain/repositories/chat_feedback_repository.dart';
import 'package:feature_chat/domain/repositories/chat_repository.dart';
import 'package:feature_chat/domain/repositories/message_usage_repository.dart';
import 'package:feature_chat/domain/usecases/get_chat_history.dart';
import 'package:feature_chat/domain/usecases/get_message_usage.dart';
import 'package:feature_chat/domain/usecases/get_messages.dart';
import 'package:feature_chat/domain/usecases/send_message.dart';
import 'package:feature_chat/domain/usecases/submit_feedback.dart';
import 'package:feature_chat/domain/usecases/update_message.dart';
import 'package:mocktail/mocktail.dart';

// Data Sources
class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

class MockChatLocalDataSource extends Mock implements ChatLocalDataSource {}

class MockChatFeedbackDataSource extends Mock
    implements ChatFeedbackDataSource {}

class MockMessageUsageDataSource extends Mock
    implements MessageUsageDataSource {}

// Repositories
class MockChatRepository extends Mock implements ChatRepository {}

class MockChatFeedbackRepository extends Mock
    implements ChatFeedbackRepository {}

class MockMessageUsageRepository extends Mock
    implements MessageUsageRepository {}

// Use Cases
class MockGetChatHistory extends Mock implements GetChatHistory {}

class MockGetMessageUsage extends Mock implements GetMessageUsage {}

class MockGetMessages extends Mock implements GetMessages {}

class MockSendMessage extends Mock implements SendMessage {}

class MockSubmitFeedback extends Mock implements SubmitFeedback {}

class MockUpdateMessage extends Mock implements UpdateMessage {}
