# Architecture Guide

## Overview

BalanceIQ follows **Clean Architecture** principles with clear separation between business logic, data access, and presentation. This makes the codebase:
- **Testable**: Business logic independent of UI
- **Maintainable**: Changes in one layer don't affect others
- **Scalable**: Easy to add new features
- **Framework-independent**: Can swap UI or database without touching business logic

## Clean Architecture Layers

```
┌─────────────────────────────────────────────┐
│         PRESENTATION LAYER                  │
│   • Pages (UI screens)                      │
│   • Widgets (reusable UI components)        │
│   • Cubits (state management)               │
│   • States (UI states)                      │
└──────────────┬──────────────────────────────┘
               │ depends on
               ▼
┌─────────────────────────────────────────────┐
│         DOMAIN LAYER                        │
│   • Entities (business objects)             │
│   • Repositories (interfaces)               │
│   • Use Cases (business logic)              │
└──────────────┬──────────────────────────────┘
               │ depends on
               ▼
┌─────────────────────────────────────────────┐
│         DATA LAYER                          │
│   • Models (JSON serialization)             │
│   • Repository Implementations              │
│   • Data Sources (API, Database)            │
└─────────────────────────────────────────────┘
```

**Dependency Rule**: Dependencies point **inward**. Inner layers don't know about outer layers.

## Folder Structure

```
lib/
├── core/                          # Shared infrastructure
│   ├── constants/
│   │   └── app_constants.dart    # App-wide constants
│   ├── database/
│   │   └── database_helper.dart  # SQLite singleton
│   ├── di/
│   │   └── injection_container.dart  # GetIt setup
│   ├── error/
│   │   └── failures.dart         # Error types
│   ├── theme/
│   │   ├── app_theme.dart        # Theme definitions
│   │   ├── theme_cubit.dart      # Theme state management
│   │   └── theme_state.dart      # Theme states
│   └── utils/                     # Utility functions
│
└── features/                      # Feature modules
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_local_datasource.dart    # SharedPreferences
    │   │   │   └── auth_remote_datasource.dart   # Firebase Auth
    │   │   ├── models/
    │   │   │   └── user_model.dart               # JSON ↔ User
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart     # Implementation
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user.dart                     # User entity
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart          # Interface
    │   │   └── usecases/
    │   │       ├── sign_in_with_google.dart
    │   │       ├── sign_in_with_apple.dart
    │   │       └── sign_out.dart
    │   │
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── auth_cubit.dart               # State management
    │       │   └── auth_state.dart               # States
    │       └── pages/
    │           ├── new_onboarding_page.dart
    │           ├── new_login_page.dart
    │           └── new_signup_page.dart
    │
    ├── chat/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── chat_local_datasource.dart    # SQLite
    │   │   │   └── chat_remote_datasource.dart   # n8n webhook
    │   │   ├── models/
    │   │   │   └── message_model.dart
    │   │   └── repositories/
    │   │       └── chat_repository_impl.dart
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── message.dart
    │   │   ├── repositories/
    │   │   │   └── chat_repository.dart
    │   │   └── usecases/
    │   │       ├── get_messages.dart
    │   │       └── send_message.dart
    │   │
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── chat_cubit.dart
    │       │   └── chat_state.dart
    │       ├── pages/
    │       │   └── chat_page.dart
    │       └── widgets/
    │           ├── message_list.dart
    │           ├── message_bubble.dart
    │           └── chat_input.dart
    │
    └── home/
        ├── data/
        │   ├── datasources/
        │   │   └── remote_datasource/
        │   │       └── dashboard_remote_datasource.dart
        │   ├── models/
        │   │   └── dashboard_summary_response.dart
        │   └── repositories/
        │       └── dashboard_repository_impl.dart
        │
        ├── domain/
        │   ├── entities/
        │   │   └── dashbaord_summary.dart
        │   ├── repositories/
        │   │   └── dashboard_repository.dart
        │   └── usecases/
        │       └── get_user_dashbaord.dart
        │
        └── presentation/
            ├── cubit/
            │   ├── dashboard_cubit.dart
            │   └── dashboard_state.dart
            ├── pages/
            │   ├── home_page.dart
            │   ├── welcome_page.dart
            │   └── error_page.dart
            └── widgets/
                ├── home_appbar.dart
                ├── balance_card_widget.dart
                ├── spending_trend_chart.dart
                └── ... (8 more widgets)
```

## Core Components

### 1. Dependency Injection (`core/di/injection_container.dart`)

**Purpose**: Central configuration for all dependencies using GetIt service locator.

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Cubits (Factory - new instance each time)
  sl.registerFactory(() => AuthCubit(
    signInWithGoogle: sl(),
    signOut: sl(),
  ));

  sl.registerFactory(() => ChatCubit(
    getMessages: sl(),
    sendMessage: sl(),
  ));

  // Use Cases (LazySingleton - created once when first needed)
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repositories (LazySingleton)
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data Sources (LazySingleton)
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(sl()),
  );

  // External Services (LazySingleton)
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => GoogleSignIn());
}
```

**Usage in UI**:
```dart
// In main.dart
await di.init();

// In widgets
BlocProvider(
  create: (context) => di.sl<ChatCubit>(),
  child: ChatPage(),
)
```

### 2. Database Helper (`core/database/database_helper.dart`)

**Purpose**: Singleton managing SQLite database operations.

```dart
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('balance_iq.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        photo_url TEXT,
        auth_provider TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        bot_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        content TEXT NOT NULL,
        image_url TEXT,
        audio_url TEXT,
        timestamp TEXT NOT NULL,
        is_sending INTEGER NOT NULL DEFAULT 0,
        has_error INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_bot_timestamp
      ON messages(bot_id, timestamp)
    ''');
  }
}
```

### 3. State Management (Cubit Pattern)

**Why Cubit?**
- Simpler than full Bloc (no events, just methods)
- Less boilerplate
- Still reactive and testable

**Example: ChatCubit**
```dart
// lib/features/chat/presentation/cubit/chat_cubit.dart
class ChatCubit extends Cubit<ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;

  ChatCubit({required this.getMessages, required this.sendMessage})
      : super(ChatInitial());

  Future<void> loadMessages(String botId) async {
    emit(ChatLoading());

    final result = await getMessages(botId);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatLoaded(messages: messages)),
    );
  }

  Future<void> sendNewMessage(Message message) async {
    // Optimistic update - show message immediately
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(ChatLoaded(
        messages: [...currentState.messages, message],
        isSending: true,
      ));
    }

    final result = await sendMessage(message);

    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (botResponse) => loadMessages(message.botId), // Reload all messages
    );
  }
}
```

**States**:
```dart
abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isSending;

  ChatLoaded({required this.messages, this.isSending = false});

  @override
  List<Object?> get props => [messages, isSending];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
```

**Usage in UI**:
```dart
class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return LoadingIndicator();
        } else if (state is ChatLoaded) {
          return MessageList(
            messages: state.messages,
            isSending: state.isSending,
          );
        } else if (state is ChatError) {
          return ErrorWidget(message: state.message);
        }
        return SizedBox.shrink();
      },
    );
  }
}
```

## Data Flow Examples

### Example 1: User Sends Message

```
1. User types "I spent 500 taka on lunch" and taps Send
   ↓
2. ChatInput widget calls:
   context.read<ChatCubit>().sendNewMessage(message)
   ↓
3. ChatCubit:
   - Creates temporary message with UUID
   - Emits ChatLoaded with temp message (optimistic UI)
   - Calls SendMessage use case
   ↓
4. SendMessage use case calls ChatRepository.sendMessage()
   ↓
5. ChatRepositoryImpl:
   - Saves user message to SQLite (local)
   - Calls ChatRemoteDataSource.sendMessage() (API)
   ↓
6. ChatRemoteDataSource:
   - Sends POST to n8n webhook with message data
   - Receives bot response
   - Returns MessageModel
   ↓
7. ChatRepositoryImpl:
   - Saves bot response to SQLite
   - Returns bot Message entity
   ↓
8. ChatCubit:
   - Reloads all messages from database
   - Emits ChatLoaded with updated messages
   ↓
9. UI rebuilds with new messages
```

### Example 2: Loading Dashboard

```
1. HomePage loads, calls:
   context.read<DashboardCubit>().loadDashboard()
   ↓
2. DashboardCubit:
   - Emits DashboardLoading
   - Calls GetDashboardSummary use case
   ↓
3. GetDashboardSummary calls DashboardRepository.getDashboardSummary()
   ↓
4. DashboardRepositoryImpl:
   - Gets cached user from AuthLocalDataSource
   - Calls DashboardRemoteDataSource with user data
   ↓
5. DashboardRemoteDataSource:
   - Sends POST to n8n dashboard webhook
   - Receives dashboard data
   - Parses to DashboardSummaryResponse model
   ↓
6. DashboardRepositoryImpl:
   - Converts model to DashboardSummary entity
   - Returns Either<Failure, DashboardSummary>
   ↓
7. DashboardCubit:
   - Emits DashboardLoaded(summary) or DashboardError
   ↓
8. HomePage rebuilds with dashboard widgets
```

## Key Design Patterns

### 1. Repository Pattern
**Purpose**: Abstract data sources from business logic.

```dart
// Domain layer (interface)
abstract class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages(String botId);
  Future<Either<Failure, Message>> sendMessage(Message message);
}

// Data layer (implementation)
class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Message>>> getMessages(String botId) async {
    try {
      final messageModels = await localDataSource.getMessages(botId);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } catch (e) {
      return Left(DatabaseFailure('Failed to load messages'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(Message message) async {
    try {
      // 1. Save user message locally
      await localDataSource.saveMessage(MessageModel.fromEntity(message));

      // 2. Send to API
      final response = await remoteDataSource.sendMessage(message);

      // 3. Save bot response locally
      await localDataSource.saveMessage(response);

      return Right(response.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to send message'));
    }
  }
}
```

### 2. Use Case Pattern
**Purpose**: Encapsulate single business operation.

```dart
class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, Message>> call(Message message) async {
    return await repository.sendMessage(message);
  }
}

// Usage in Cubit
final result = await sendMessage(message);
```

### 3. Either Monad (dartz)
**Purpose**: Handle errors functionally without exceptions.

```dart
// Success
return Right(data);

// Failure
return Left(ServerFailure('Error message'));

// Usage
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (data) => print('Success: $data'),
);
```

## Entity vs Model

### Entity (Domain Layer)
```dart
class Message extends Equatable {
  final String id;
  final String botId;
  final String sender;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.botId,
    required this.sender,
    required this.content,
    this.imageUrl,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, botId, sender, content, imageUrl, timestamp];
}
```

### Model (Data Layer)
```dart
class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.botId,
    required super.sender,
    required super.content,
    super.imageUrl,
    required super.timestamp,
  });

  // JSON serialization
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      botId: json['bot_id'],
      sender: json['sender'],
      content: json['content'],
      imageUrl: json['image_url'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bot_id': botId,
      'sender': sender,
      'content': content,
      'image_url': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Conversion
  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      id: entity.id,
      botId: entity.botId,
      sender: entity.sender,
      content: entity.content,
      imageUrl: entity.imageUrl,
      timestamp: entity.timestamp,
    );
  }

  Message toEntity() => this;
}
```

**Why separate Entity and Model?**
- Entity: Pure business object, no JSON logic
- Model: Handles serialization/deserialization
- Domain layer stays clean and framework-independent

## Testing Strategy

### Unit Tests
Test business logic in isolation:
```dart
test('ChatCubit emits ChatLoaded when messages load successfully', () {
  // Arrange
  when(mockGetMessages.call(any)).thenAnswer((_) async => Right(messages));

  // Act
  cubit.loadMessages('balance_tracker');

  // Assert
  expect(
    cubit.stream,
    emitsInOrder([ChatLoading(), ChatLoaded(messages: messages)]),
  );
});
```

### Widget Tests
Test UI components:
```dart
testWidgets('MessageBubble displays user message correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MessageBubble(message: userMessage),
    ),
  );

  expect(find.text(userMessage.content), findsOneWidget);
  expect(find.byType(Align), findsOneWidget);
});
```

---

**Next Steps**:
- Read [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md) to learn how to add features
- Check [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) for current progress
- Review [API_INTEGRATION.md](API_INTEGRATION.md) for backend details

---

**Last Updated**: 2025-11-21