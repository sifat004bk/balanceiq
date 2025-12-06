# Chat Architecture v2.0 - Implementation Guide

**Status**: ✅ Approved for Implementation
**Version**: 2.0
**Date**: 2025-12-05
**Estimated Implementation**: 12 hours

---

## Quick Reference (TL;DR for Agents)

### Core Decisions
- **Cache Strategy**: SQLite-first, API background sync
- **Scroll Pattern**: `ListView(reverse: true)` for chat UX
- **Deduplication**: Composite UNIQUE constraint + `ConflictAlgorithm.ignore`
- **Pagination**: API-side only, DB is stateless cache
- **Concurrency**: Operation queue in Cubit for DB writes
- **Security**: `flutter_secure_storage` for JWT tokens

### Key Files to Modify
```
lib/features/chat/
├── data/
│   ├── datasources/chat_local_data_source.dart  # Add saveMessages()
│   ├── datasources/chat_remote_data_source.dart # Add getChatHistory()
│   └── repositories/chat_repository_impl.dart   # Add sync logic
├── domain/
│   └── usecases/get_chat_history.dart           # New use case
└── presentation/
    ├── cubit/chat_cubit.dart                     # Refactor load logic
    └── pages/chat_page.dart                      # Remove AppBar, add reverse ListView

lib/core/database/database_helper.dart            # Schema migration
```

---

## 1. Database Schema

### Messages Table (Updated)
```sql
CREATE TABLE messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bot_id TEXT NOT NULL,
  message TEXT NOT NULL,
  sender TEXT NOT NULL,              -- 'user' or 'bot'
  timestamp TEXT NOT NULL,            -- Local timestamp (ISO 8601)
  image_path TEXT,

  -- Sync fields
  server_created_at TEXT,             -- Source of truth for ordering
  is_synced INTEGER DEFAULT 0,        -- 0=pending, 1=confirmed
  sync_status TEXT DEFAULT 'pending', -- 'pending'|'sent'|'failed'
  api_message_id TEXT,                -- Backend message ID

  -- Deduplication
  CONSTRAINT unique_message UNIQUE (bot_id, sender, server_created_at, message)
);

-- Performance index
CREATE INDEX idx_messages_bot_time ON messages(bot_id, server_created_at DESC);
```

### Migration Script
```dart
// lib/core/database/database_helper.dart
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
      ALTER TABLE messages ADD COLUMN server_created_at TEXT;
      ALTER TABLE messages ADD COLUMN is_synced INTEGER DEFAULT 0;
      ALTER TABLE messages ADD COLUMN sync_status TEXT DEFAULT 'pending';
      ALTER TABLE messages ADD COLUMN api_message_id TEXT;
    ''');

    // Add unique constraint (recreate table for SQLite < 3.35)
    await db.execute('''
      CREATE TABLE messages_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bot_id TEXT NOT NULL,
        message TEXT NOT NULL,
        sender TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        image_path TEXT,
        server_created_at TEXT,
        is_synced INTEGER DEFAULT 0,
        sync_status TEXT DEFAULT 'pending',
        api_message_id TEXT,
        CONSTRAINT unique_message UNIQUE (bot_id, sender, server_created_at, message)
      );
    ''');
    await db.execute('INSERT INTO messages_new SELECT * FROM messages;');
    await db.execute('DROP TABLE messages;');
    await db.execute('ALTER TABLE messages_new RENAME TO messages;');
    await db.execute('CREATE INDEX idx_messages_bot_time ON messages(bot_id, server_created_at DESC);');
  }
}
```

---

## 2. API Contract

### GET /api/finance-guru/chat-history

**Request**:
```dart
final response = await dio.get(
  '${AppConstants.backendBaseUrl}/api/finance-guru/chat-history',
  queryParameters: {
    'page': 1,          // Page number (1-indexed)
    'limit': 10,        // Messages per page
  },
  options: Options(
    headers: {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    },
  ),
);
```

**Response** (200 OK):
```json
{
  "success": true,
  "message": "Chat history retrieved successfully",
  "data": {
    "userId": 123,
    "conversations": [
      {
        "userMessage": "What is my balance?",
        "aiResponse": "Your current balance is 45,500 BDT...",
        "createdAt": "2025-12-03T10:30:00Z"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "limit": 10,
      "returned": 10,
      "hasNext": true,
      "nextPage": 2
    }
  },
  "timestamp": 1733220600000
}
```

---

## 3. Implementation Patterns

### 3.1 Local Data Source (Idempotent Save)

```dart
// lib/features/chat/data/datasources/chat_local_data_source.dart

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages({String? botId, int limit = 20});
  Future<void> saveMessages(List<MessageModel> messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final DatabaseHelper db;

  @override
  Future<List<MessageModel>> getMessages({String? botId, int limit = 20}) async {
    final database = await db.database;
    final maps = await database.query(
      'messages',
      where: botId != null ? 'bot_id = ?' : null,
      whereArgs: botId != null ? [botId] : null,
      orderBy: 'server_created_at DESC',
      limit: limit,
    );
    return maps.map((map) => MessageModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveMessages(List<MessageModel> messages) async {
    final database = await db.database;
    await database.transaction((txn) async {
      for (var msg in messages) {
        await txn.insert(
          'messages',
          msg.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore, // Ignore duplicates
        );
      }
    });
  }
}
```

### 3.2 Remote Data Source

```dart
// lib/features/chat/data/datasources/chat_remote_data_source.dart

abstract class ChatRemoteDataSource {
  Future<ChatHistoryResponseModel> getChatHistory({
    required int page,
    required int limit,
    required String token,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  @override
  Future<ChatHistoryResponseModel> getChatHistory({
    required int page,
    required int limit,
    required String token,
  }) async {
    final response = await dio.get(
      '${AppConstants.backendBaseUrl}/api/finance-guru/chat-history',
      queryParameters: {'page': page, 'limit': limit},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        sendTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
      ),
    );

    if (response.statusCode == 200) {
      return ChatHistoryResponseModel.fromJson(response.data);
    }
    throw ServerException('Failed to load chat history: ${response.statusCode}');
  }
}
```

### 3.3 Repository (Sync Logic)

```dart
// lib/features/chat/data/repositories/chat_repository_impl.dart

@override
Future<Either<Failure, ChatHistoryResponse>> getChatHistory({
  required int page,
  int limit = 10,
}) async {
  try {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return Left(AuthFailure('No token found'));

    final response = await remoteDataSource.getChatHistory(
      page: page,
      limit: limit,
      token: token,
    );

    // Save to cache
    final messagesToSave = _convertToMessageModels(response.conversations);
    await localDataSource.saveMessages(messagesToSave);

    return Right(response.toEntity());
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  } catch (e) {
    return Left(ServerFailure('Unexpected error: $e'));
  }
}

List<MessageModel> _convertToMessageModels(List<Conversation> conversations) {
  final messages = <MessageModel>[];
  for (var convo in conversations) {
    messages.add(MessageModel(
      botId: 'finance_guru',
      message: convo.userMessage,
      sender: 'user',
      timestamp: convo.createdAt,
      serverCreatedAt: convo.createdAt,
      isSynced: true,
    ));
    messages.add(MessageModel(
      botId: 'finance_guru',
      message: convo.aiResponse,
      sender: 'bot',
      timestamp: convo.createdAt,
      serverCreatedAt: convo.createdAt,
      isSynced: true,
    ));
  }
  return messages;
}
```

### 3.4 ChatCubit (Smart Sync)

```dart
// lib/features/chat/presentation/cubit/chat_cubit.dart

class ChatCubit extends Cubit<ChatState> {
  final GetCachedMessages getCachedMessages;
  final GetChatHistory getChatHistory;
  final SendMessage sendMessage;
  final synchronized.Lock _lock = synchronized.Lock(); // For concurrency

  int _apiPage = 0;
  bool _hasMore = true;

  ChatCubit({
    required this.getCachedMessages,
    required this.getChatHistory,
    required this.sendMessage,
  }) : super(ChatInitial());

  // Initial load: Cache first, then API sync
  Future<void> loadChatHistory() async {
    emit(ChatLoading());

    // 1. Load from cache immediately (fast UX)
    final cachedResult = await getCachedMessages(limit: 20);
    cachedResult.fold(
      (failure) {}, // Ignore cache failures
      (cached) {
        if (cached.isNotEmpty) {
          emit(ChatLoaded(messages: cached, hasMore: true));
        }
      },
    );

    // 2. Sync with API in background
    _apiPage = 1;
    final apiResult = await getChatHistory(page: _apiPage);
    apiResult.fold(
      (failure) => emit(ChatError(failure.message)),
      (response) async {
        _hasMore = response.pagination.hasNext;

        // 3. Reload from cache (now includes API data)
        final updatedResult = await getCachedMessages(limit: 20);
        updatedResult.fold(
          (failure) => emit(ChatError(failure.message)),
          (messages) => emit(ChatLoaded(messages: messages, hasMore: _hasMore)),
        );
      },
    );
  }

  // Pagination: Load older messages
  Future<void> loadMoreMessages() async {
    if (!_hasMore || state is! ChatLoaded) return;

    final currentState = state as ChatLoaded;
    if (currentState.isLoadingMore) return; // Prevent duplicate calls

    emit(ChatLoaded(
      messages: currentState.messages,
      hasMore: _hasMore,
      isLoadingMore: true,
    ));

    _apiPage++;
    final result = await getChatHistory(page: _apiPage);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (response) async {
        _hasMore = response.pagination.hasNext;

        // Reload with more messages
        final currentCount = currentState.messages.length;
        final updatedResult = await getCachedMessages(limit: currentCount + 10);
        updatedResult.fold(
          (failure) => emit(ChatError(failure.message)),
          (messages) => emit(ChatLoaded(
            messages: messages,
            hasMore: _hasMore,
            isLoadingMore: false,
          )),
        );
      },
    );
  }

  // Send new message with optimistic UI
  Future<void> sendNewMessage(String message, {String? imagePath}) async {
    await _lock.synchronized(() async {
      final currentState = state;
      if (currentState is! ChatLoaded) return;

      // Optimistic update
      final tempMessage = Message(
        id: -DateTime.now().millisecondsSinceEpoch, // Temporary ID
        botId: 'finance_guru',
        message: message,
        sender: 'user',
        timestamp: DateTime.now().toIso8601String(),
        syncStatus: 'pending',
      );

      emit(ChatLoaded(
        messages: [tempMessage, ...currentState.messages],
        hasMore: currentState.hasMore,
      ));

      // Send to API
      final result = await sendMessage(SendMessageParams(
        message: message,
        imagePath: imagePath,
      ));

      result.fold(
        (failure) {
          // Mark as failed, keep in UI
          // TODO: Update message sync_status to 'failed'
        },
        (response) async {
          // Reload to get AI response
          await loadChatHistory();
        },
      );
    });
  }
}
```

### 3.5 UI Implementation (Reverse ListView)

```dart
// lib/features/chat/presentation/pages/chat_page.dart

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          _buildCompactHeader(context),
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }

                if (state is ChatLoaded) {
                  return ListView.builder(
                    reverse: true, // Critical for chat UX
                    padding: EdgeInsets.all(16),
                    itemCount: state.messages.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Load more indicator
                      if (index == state.messages.length) {
                        if (!state.isLoadingMore) {
                          // Trigger load more
                          Future.microtask(() {
                            context.read<ChatCubit>().loadMoreMessages();
                          });
                        }
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final message = state.messages[index];
                      return MessageBubble(message: message);
                    },
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    ),
  );
}

Widget _buildCompactHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
    ),
    child: Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: 8),
        Icon(Icons.chat_bubble_outline, size: 20),
        SizedBox(width: 12),
        Text('Finance Guru', style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}
```

---

## 4. Phase-by-Phase Implementation

### Phase 1: Database & Models (2 hours)
**Files**: `database_helper.dart`, `message_model.dart`

1. Add new fields to `MessageModel`:
   ```dart
   class MessageModel {
     final String? serverCreatedAt;
     final bool isSynced;
     final String syncStatus;
     final String? apiMessageId;
     // ... existing fields
   }
   ```

2. Update `DatabaseHelper._onUpgrade()` with migration script (see §1)

3. Test migration:
   ```dart
   // In test file
   test('migration preserves existing messages', () async {
     // Add old schema messages
     // Run migration
     // Verify data integrity
   });
   ```

### Phase 2: Data Layer (2 hours)
**Files**: `chat_local_data_source.dart`, `chat_remote_data_source.dart`, `chat_repository_impl.dart`

1. Implement `saveMessages()` with transaction (see §3.1)
2. Implement `getChatHistory()` API call (see §3.2)
3. Add `getChatHistory()` to repository (see §3.3)
4. Create `ChatHistoryResponse` model matching API contract

### Phase 3: State Management (3 hours)
**Files**: `chat_cubit.dart`, `get_chat_history.dart`

1. Add `synchronized` package: `flutter pub add synchronized`
2. Create `GetChatHistory` use case
3. Refactor `ChatCubit` (see §3.4):
   - Replace `loadMessages()` with `loadChatHistory()`
   - Add `loadMoreMessages()`
   - Add `_lock` for concurrency
4. Update DI in `injection_container.dart`:
   ```dart
   sl.registerFactory(() => ChatCubit(
     getCachedMessages: sl(),
     getChatHistory: sl(),
     sendMessage: sl(),
   ));
   ```

### Phase 4: UI Implementation (3 hours)
**Files**: `chat_page.dart`

1. Remove `AppBar` widget
2. Add `_buildCompactHeader()` (see §3.5)
3. Replace `ListView` with `ListView.builder(reverse: true)`
4. Add pagination trigger in `itemBuilder`
5. Test scroll behavior

### Phase 5: Testing & Polish (2 hours)

1. **Unit Tests**:
   ```bash
   flutter test test/features/chat/data/datasources/
   flutter test test/features/chat/domain/usecases/
   ```

2. **Integration Tests**:
   - Offline mode: Airplane mode → open chat → see cached messages
   - Pagination: Scroll up → load 50+ messages → verify smooth scroll
   - Deduplication: Force sync twice → verify no duplicates
   - Performance: Load 1,000 messages → verify < 1s load time

3. **Load Testing**:
   ```dart
   // Generate 1000 test messages
   for (int i = 0; i < 1000; i++) {
     await db.insert('messages', testMessage(i).toMap());
   }
   // Open chat page → verify performance
   ```

---

## 5. Common Pitfalls & Solutions

### ❌ Pitfall 1: Scroll Position Jumps
**Problem**: Adding messages shifts scroll position
**Solution**: Use `reverse: true` ListView (not `Axis.reverse`)

### ❌ Pitfall 2: Duplicate Messages
**Problem**: Same message inserted multiple times
**Solution**: Composite UNIQUE constraint + `ConflictAlgorithm.ignore`

### ❌ Pitfall 3: Race Conditions
**Problem**: Sending message while loading history
**Solution**: Wrap critical sections with `_lock.synchronized()`

### ❌ Pitfall 4: Memory Leaks
**Problem**: ScrollController not disposed
**Solution**: Always dispose in `State.dispose()`:
```dart
@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}
```

### ❌ Pitfall 5: Stale Cache
**Problem**: API changes not reflected in UI
**Solution**: Always reload from DB after API sync

---

## 6. Performance Benchmarks

### Target Metrics
- **Initial load (cached)**: < 500ms
- **API sync (page 1)**: < 2s
- **Pagination load**: < 1s
- **Scroll framerate**: 60fps
- **Query time (1000 msgs)**: < 100ms

### Monitoring
```dart
final stopwatch = Stopwatch()..start();
final messages = await localDataSource.getMessages();
stopwatch.stop();
print('🕐 DB query: ${stopwatch.elapsedMilliseconds}ms');
```

---

## 7. Security Checklist

- ✅ JWT stored in `flutter_secure_storage`
- ✅ HTTPS for all API calls
- ✅ Input validation (max 5000 chars)
- ✅ SQL injection prevented (parameterized queries)
- ⚠️ Encryption at rest: Deferred to post-MVP
- ⚠️ Certificate pinning: Deferred to post-MVP

---

## 8. Post-MVP Enhancements

1. **Message Windowing**: Keep only 100 messages in memory, lazy-load rest
2. **Incremental Sync**: Sync only since `last_sync_timestamp`
3. **Message Search**: Full-text search with FTS5
4. **Encryption**: Column-level encryption with `sqlcipher_flutter_libs`
5. **Real-time**: WebSocket for instant message delivery

---

## 9. Troubleshooting

### Issue: "UNIQUE constraint failed"
**Cause**: Duplicate message with same `(bot_id, sender, server_created_at, message)`
**Fix**: This is expected. The message is already in DB (idempotent operation).

### Issue: Scroll jumps to bottom after load more
**Cause**: Not using `reverse: true`
**Fix**: Ensure `ListView.builder(reverse: true, ...)`

### Issue: Messages not syncing
**Cause**: JWT token expired
**Fix**: Add token refresh logic in repository layer

### Issue: Performance degradation with 500+ messages
**Cause**: Loading all messages without LIMIT
**Fix**: Always use `LIMIT` in queries (see §3.1)

---

## 10. Dependencies

**Required packages** (already in `pubspec.yaml`):
```yaml
dependencies:
  sqflite: ^2.3.3          # SQLite database
  dio: ^5.7.0              # HTTP client
  flutter_bloc: ^8.1.6     # State management
  dartz: ^0.10.1           # Functional programming
  get_it: ^8.0.2           # Dependency injection
  flutter_secure_storage: ^9.2.2  # Secure JWT storage

dev_dependencies:
  synchronized: ^3.1.0     # Concurrency control
```

---

## Quick Start Checklist

Before implementation, verify:
- [ ] Read this document completely
- [ ] Review existing code structure in `lib/features/chat/`
- [ ] Backup current database (if production)
- [ ] Create feature branch: `git checkout -b feature/chat-pagination-v2`
- [ ] Run tests before changes: `flutter test`

After implementation:
- [ ] All 5 phases complete
- [ ] Tests passing: `flutter test`
- [ ] Manual testing on iOS and Android
- [ ] Performance benchmarks met
- [ ] Update `projectcontext/IMPLEMENTATION_STATUS.md`
- [ ] Git commit with descriptive message

---

**Document Version**: 2.0
**Last Updated**: 2025-12-05
**Author**: Development Team
**Status**: ✅ Approved for Implementation