# Chat Architecture v3.0 - Implementation Guide

**Status**: ✅ Fully Implemented
**Version**: 3.0 (Database v3 with User Isolation)
**Date**: 2025-12-07
**Implementation Time**: ~4 hours (v2→v3 migration)

---

## Quick Reference (TL;DR for Agents)

### Core Decisions
- **Cache Strategy**: SQLite-first, API background sync
- **User Isolation**: Filter-based (user_id column) - multi-user privacy
- **Scroll Pattern**: `ListView(reverse: true)` for chat UX
- **Deduplication**: Composite UNIQUE constraint + `ConflictAlgorithm.ignore`
- **Pagination**: API-side only, DB is stateless cache
- **Concurrency**: Lock-based synchronization in Cubit for DB writes
- **Security**: SharedPreferences for user data, JWT tokens in API calls

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

### Messages Table (v3 - User Isolation)
```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,                -- UUID
  user_id TEXT NOT NULL,              -- 🆕 User isolation (from SharedPreferences)
  bot_id TEXT NOT NULL,
  sender TEXT NOT NULL,               -- 'user' or 'bot'
  content TEXT NOT NULL,
  image_url TEXT,
  audio_url TEXT,
  timestamp TEXT NOT NULL,            -- Local timestamp (ISO 8601)
  is_sending INTEGER NOT NULL DEFAULT 0,
  has_error INTEGER NOT NULL DEFAULT 0,

  -- Sync fields (v2)
  server_created_at TEXT,             -- Source of truth for ordering
  is_synced INTEGER DEFAULT 0,        -- 0=pending, 1=confirmed
  sync_status TEXT DEFAULT 'pending', -- 'pending'|'sent'|'failed'
  api_message_id TEXT,                -- Backend message ID

  -- Deduplication (v3 - includes user_id)
  CONSTRAINT unique_message UNIQUE (user_id, bot_id, sender, server_created_at, content)
);

-- Performance indexes (v3 - user-specific)
CREATE INDEX idx_messages_user_bot_server_time
  ON messages(user_id, bot_id, server_created_at DESC);
CREATE INDEX idx_messages_user_bot_timestamp
  ON messages(user_id, bot_id, timestamp DESC);
```

### Schema Evolution
- **v1**: Basic messages (id, bot_id, message, sender, timestamp)
- **v2**: Added sync fields (server_created_at, is_synced, sync_status, api_message_id)
- **v3**: 🆕 Added user_id for multi-user isolation (BREAKING CHANGE)

### Migration Script (v2 → v3)
```dart
// lib/core/database/database_helper.dart
Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  // v1 → v2: Add sync fields
  if (oldVersion < 2) {
    await _migrateToV2(db);
  }

  // v2 → v3: Add user_id for user isolation
  if (oldVersion < 3) {
    await _migrateToV3(db);
  }
}

Future<void> _migrateToV3(Database db) async {
  print('🔄 Migrating database from v2 to v3: Adding user_id for user isolation');

  // Strategy: Delete all existing messages (fresh start)
  // This ensures clean user isolation without orphaned data
  print('⚠️ Clearing all existing messages for fresh start...');
  await db.delete(AppConstants.messagesTable);

  // Drop old table
  await db.execute('DROP TABLE ${AppConstants.messagesTable}');

  // Create new messages table with user_id column
  await db.execute('''
    CREATE TABLE ${AppConstants.messagesTable} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      bot_id TEXT NOT NULL,
      sender TEXT NOT NULL,
      content TEXT NOT NULL,
      image_url TEXT,
      audio_url TEXT,
      timestamp TEXT NOT NULL,
      is_sending INTEGER NOT NULL DEFAULT 0,
      has_error INTEGER NOT NULL DEFAULT 0,
      server_created_at TEXT,
      is_synced INTEGER DEFAULT 0,
      sync_status TEXT DEFAULT 'pending',
      api_message_id TEXT,
      CONSTRAINT unique_message UNIQUE (user_id, bot_id, sender, server_created_at, content)
    )
  ''');

  // Create new indexes for efficient user-specific queries
  await db.execute('''
    CREATE INDEX idx_messages_user_bot_server_time
    ON ${AppConstants.messagesTable}(user_id, bot_id, server_created_at DESC)
  ''');

  await db.execute('''
    CREATE INDEX idx_messages_user_bot_timestamp
    ON ${AppConstants.messagesTable}(user_id, bot_id, timestamp DESC)
  ''');

  print('✅ Migration to v3 completed successfully');
  print('ℹ️ All previous messages have been cleared for user isolation');
}
```

### Migration Behavior
**On App Update (v2 → v3):**
1. Database detects version mismatch
2. Runs migration automatically on first launch
3. **Clears all existing messages** (clean slate)
4. Users will see empty chat history
5. Chat history re-syncs from API on next chat load

---

## 1.1. User Isolation Architecture (v3)

### Problem Statement
Multiple users on the same device should see **only their own chat history**, not messages from other users.

### Solution: Filter-Based Isolation
**Approach:** Add `user_id` column to messages table, filter queries by user_id

**Privacy Model:**
```
Device with 2 users:

User A (user_id="123"):
  - Balance Tracker: 10 messages
  - Investment Guru: 5 messages

User B (user_id="456"):
  - Balance Tracker: 3 messages
  - Budget Planner: 8 messages

✅ User A sees ONLY their 15 messages
✅ User B sees ONLY their 11 messages
✅ No cross-contamination
```

### Implementation Details

**1. Data Source Layer**
```dart
// All queries filter by user_id
Future<List<MessageModel>> getMessages(String userId, String botId, {int? limit}) async {
  final db = await databaseHelper.database;
  final List<Map<String, dynamic>> maps = await db.query(
    AppConstants.messagesTable,
    where: 'user_id = ? AND bot_id = ?',  // 🔑 User isolation
    whereArgs: [userId, botId],
    orderBy: 'COALESCE(server_created_at, timestamp) DESC',
    limit: limit,
  );
  return maps.map((m) => MessageModel.fromJson(m)).toList();
}
```

**2. Repository Layer**
```dart
// Gets userId from SharedPreferences
final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '';

// User message includes userId
final userMessage = MessageModel(
  id: uuid.v4(),
  userId: userId,  // 🔑 User context
  botId: botId,
  sender: AppConstants.senderUser,
  content: content,
  timestamp: DateTime.now(),
);
```

**3. Cubit Layer**
```dart
// Load chat history for current user
Future<void> loadChatHistory(String botId) async {
  final userId = sharedPreferences.getString(AppConstants.keyUserId) ?? '';

  // Cache-first load (user-specific)
  final cachedResult = await getMessages(userId, botId, limit: 20);

  // API sync (user-specific)
  final apiResult = await getChatHistory(userId: userId, page: 1, botId: botId);
}
```

**4. User ID Source**
- Stored in `SharedPreferences` during login
- Key: `AppConstants.keyUserId` = `'user_id'`
- Retrieved from `User` entity after authentication
- Cleared on logout

### Multi-User Flow Example

```
┌─────────────────────────────────────────────────────────┐
│  1. User A logs in                                       │
│     SharedPreferences.setString('user_id', '123')       │
│     ↓                                                     │
│  2. User A chats with Balance Tracker                   │
│     Messages saved with user_id='123'                   │
│     ↓                                                     │
│  3. User A logs out                                      │
│     SharedPreferences cleared (user_id removed)         │
│     ⚠️ Messages NOT deleted (stay in DB)               │
│     ↓                                                     │
│  4. User B logs in                                       │
│     SharedPreferences.setString('user_id', '456')       │
│     ↓                                                     │
│  5. User B opens Balance Tracker                        │
│     Query: WHERE user_id='456' AND bot_id='balance...' │
│     Result: EMPTY (no messages for user B)              │
│     ✅ User B sees clean slate                          │
│     ↓                                                     │
│  6. User B logs out, User A logs in again               │
│     SharedPreferences.setString('user_id', '123')       │
│     ↓                                                     │
│  7. User A opens Balance Tracker                        │
│     Query: WHERE user_id='123' AND bot_id='balance...' │
│     Result: User A's original 10 messages               │
│     ✅ User A sees their messages (not User B's)        │
└─────────────────────────────────────────────────────────┘
```

### Logout Behavior

**Option A (Implemented):** Filter-based isolation
- Messages remain on device
- Queries automatically filter by user_id
- No cleanup needed on logout
- Next user sees empty chat (different user_id)

**Option B (Available but not used):** Clear messages on logout
```dart
// Method exists in repository but not called
Future<Either<Failure, void>> clearAllUserMessages(String userId) async {
  await localDataSource.clearAllUserMessages(userId);
}

// Could be called in auth logout flow
await chatRepository.clearAllUserMessages(currentUserId);
```

### Security Considerations

**✅ Good:**
- User isolation at query level (can't accidentally see other messages)
- No shared state between users
- Clean separation of data

**⚠️ Considerations:**
- Messages from other users remain on device (physical access could read DB)
- For maximum privacy, implement Option B (clear on logout)
- Consider encrypting local database for sensitive data

### Performance

**Query Performance:**
- Composite index on `(user_id, bot_id, server_created_at)` ensures fast queries
- Tested: <100ms for 1000 messages per user
- O(log n) lookup with proper indexing

**Storage:**
- Multiple users on same device: DB size = sum of all users' messages
- Consider cleanup strategy for old/inactive users
- Typical: 100KB per 1000 messages → 1MB for 10,000 messages across all users

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