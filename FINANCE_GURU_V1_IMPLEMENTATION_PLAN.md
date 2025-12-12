# Finance Guru v1 API Implementation Plan

**Date**: 2025-12-12
**Status**: Ready for Implementation
**Estimated Time**: 4-6 hours

---

## Executive Summary

This plan outlines the necessary updates to adapt the BalanceIQ Flutter app to the Finance Guru v1 API specifications. The main changes involve:

1. **API Endpoint Updates**: Migrate chat and chat history endpoints to v1
2. **Data Model Updates**: Add `id` and `feedback` fields to chat history conversations
3. **Query Parameter Updates**: Change `limit` to `size` for chat history pagination
4. **No Breaking Changes**: All existing functionality remains compatible

---

## Table of Contents

1. [Changes Overview](#changes-overview)
2. [Detailed Implementation Steps](#detailed-implementation-steps)
3. [Files to Create](#files-to-create)
4. [Files to Modify](#files-to-modify)
5. [Testing Plan](#testing-plan)
6. [Rollback Strategy](#rollback-strategy)

---

## Changes Overview

### 1. API Endpoint Changes

| Current Endpoint | New Endpoint | Impact |
|-----------------|--------------|--------|
| `POST /api/finance-guru/chat` | `POST /api/finance-guru/v1/chat` | Update API constants |
| `GET /api/finance-guru/chat-history` | `GET /api/finance-guru/v1/chat-history` | Update API constants |

### 2. Data Model Changes

#### Chat History Conversation Entity/Model

**Add New Fields:**
- `id` (int) - Unique conversation ID, required for submitting feedback
- `feedback` (String?) - User feedback: "LIKE", "DISLIKE", or null

**Query Parameter Change:**
- Rename `limit` parameter to `size` in chat history queries

### 3. Existing Features (Already Implemented - No Changes Needed)

✅ **Transaction Search** - Already uses `/api/finance-guru/v1/transactions`
✅ **Dashboard** - Already uses `/api/finance-guru/v1/dashboard`
✅ **Token Usage** - Already defined in entities and repositories
✅ **Chat Feedback** - Already defined in entities and repositories

---

## Detailed Implementation Steps

### Phase 1: Core API Endpoint Updates (30 minutes)

#### Step 1.1: Update API Endpoints Constants

**File**: `lib/core/constants/api_endpoints.dart`

**Current:**
```dart
static String get chat => '$financeGuruBaseUrl/chat';
static String get chatHistory => '$financeGuruBaseUrl/chat-history';
```

**Update to:**
```dart
static String get chat => '$financeGuruBaseUrl/v1/chat';
static String get chatHistory => '$financeGuruBaseUrl/v1/chat-history';
```

**Impact**: All chat and chat history API calls will now use v1 endpoints

---

### Phase 2: Domain Layer Updates (1 hour)

#### Step 2.1: Update Conversation Entity

**File**: `lib/features/chat/domain/entities/chat_history_response.dart`

**Current Conversation Class:**
```dart
class Conversation extends Equatable {
  final String userMessage;
  final String aiResponse;
  final String createdAt;

  const Conversation({
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [userMessage, aiResponse, createdAt];
}
```

**Update to:**
```dart
class Conversation extends Equatable {
  final int id;                    // ✨ NEW: Conversation ID
  final String userMessage;
  final String aiResponse;
  final String createdAt;
  final String? feedback;          // ✨ NEW: User feedback (LIKE, DISLIKE, null)

  const Conversation({
    required this.id,              // ✨ NEW
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
    this.feedback,                 // ✨ NEW
  });

  @override
  List<Object?> get props => [id, userMessage, aiResponse, createdAt, feedback];

  /// Helper to check if conversation has feedback
  bool get hasFeedback => feedback != null && feedback!.isNotEmpty;

  /// Helper to check if user liked the conversation
  bool get isLiked => feedback == 'LIKE';

  /// Helper to check if user disliked the conversation
  bool get isDisliked => feedback == 'DISLIKE';
}
```

**Rationale**:
- `id` is required to submit feedback on specific conversations
- `feedback` allows UI to display current feedback state

---

### Phase 3: Data Layer Updates (1.5 hours)

#### Step 3.1: Update ConversationModel

**File**: `lib/features/chat/data/models/chat_history_response_model.dart`

**Current ConversationModel Class:**
```dart
class ConversationModel {
  final String userMessage;
  final String aiResponse;
  final String createdAt;

  ConversationModel({
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      userMessage: json['userMessage'] as String,
      aiResponse: json['aiResponse'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'createdAt': createdAt,
    };
  }

  Conversation toEntity() {
    return Conversation(
      userMessage: userMessage,
      aiResponse: aiResponse,
      createdAt: createdAt,
    );
  }
}
```

**Update to:**
```dart
class ConversationModel {
  final int id;                    // ✨ NEW
  final String userMessage;
  final String aiResponse;
  final String createdAt;
  final String? feedback;          // ✨ NEW

  ConversationModel({
    required this.id,              // ✨ NEW
    required this.userMessage,
    required this.aiResponse,
    required this.createdAt,
    this.feedback,                 // ✨ NEW
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as int,                           // ✨ NEW
      userMessage: json['userMessage'] as String,
      aiResponse: json['aiResponse'] as String,
      createdAt: json['createdAt'] as String,
      feedback: json['feedback'] as String?,           // ✨ NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,                    // ✨ NEW
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'createdAt': createdAt,
      'feedback': feedback,        // ✨ NEW
    };
  }

  Conversation toEntity() {
    return Conversation(
      id: id,                      // ✨ NEW
      userMessage: userMessage,
      aiResponse: aiResponse,
      createdAt: createdAt,
      feedback: feedback,          // ✨ NEW
    );
  }
}
```

**Additional Update**: Update `toMessageModels` method to use conversation ID:

```dart
/// Convert conversations to MessageModels for local storage
List<MessageModel> toMessageModels(String botId) {
  final messages = <MessageModel>[];

  for (var conversation in conversations) {
    // User message - use conversation ID
    messages.add(MessageModel(
      id: '${userId}_${conversation.id}_user',      // ✨ UPDATED: Use conversation.id
      userId: userId.toString(),
      botId: botId,
      sender: 'user',
      content: conversation.userMessage,
      timestamp: DateTime.parse(conversation.createdAt),
      serverCreatedAt: DateTime.parse(conversation.createdAt),
      isSynced: true,
      syncStatus: 'sent',
      conversationId: conversation.id,               // ✨ NEW: Link to conversation
    ));

    // AI response - use conversation ID
    messages.add(MessageModel(
      id: '${userId}_${conversation.id}_bot',       // ✨ UPDATED: Use conversation.id
      userId: userId.toString(),
      botId: botId,
      sender: 'bot',
      content: conversation.aiResponse,
      timestamp: DateTime.parse(conversation.createdAt).add(const Duration(milliseconds: 1)),
      serverCreatedAt: DateTime.parse(conversation.createdAt).add(const Duration(milliseconds: 1)),
      isSynced: true,
      syncStatus: 'sent',
      conversationId: conversation.id,               // ✨ NEW: Link to conversation
      feedback: conversation.feedback,               // ✨ NEW: Include feedback
    ));
  }

  return messages;
}
```

---

#### Step 3.2: Update ChatHistoryQueryParams

**File**: `lib/features/chat/data/models/chat_request_models.dart`

**Current Implementation** (assuming it exists):
```dart
class ChatHistoryQueryParams {
  final int page;
  final int limit;

  ChatHistoryQueryParams({
    required this.page,
    this.limit = 10,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page,
      'limit': limit,
    };
  }
}
```

**Update to:**
```dart
class ChatHistoryQueryParams {
  final int page;
  final int size;              // ✨ CHANGED: limit → size

  ChatHistoryQueryParams({
    required this.page,
    this.size = 20,            // ✨ CHANGED: default 20 to match API spec
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'page': page,
      'size': size,            // ✨ CHANGED: limit → size
    };
  }
}
```

---

#### Step 3.3: Update Data Source Implementation

**File**: `lib/features/chat/data/datasources/chat_finance_guru_datasource.dart`

**Update Method Call** (lines 107-110):

**Current:**
```dart
final queryParams = ChatHistoryQueryParams(
  page: page,
  limit: limit ?? 20,
);
```

**Update to:**
```dart
final queryParams = ChatHistoryQueryParams(
  page: page,
  size: limit ?? 20,          // ✨ CHANGED: limit → size parameter
);
```

---

### Phase 4: Message Model Enhancement (Optional - 1 hour)

#### Step 4.1: Add Conversation Linking to MessageModel

**File**: `lib/features/chat/data/models/message_model.dart`

**Add Optional Fields:**
```dart
class MessageModel {
  // ... existing fields ...
  final int? conversationId;     // ✨ NEW: Link to API conversation ID
  final String? feedback;        // ✨ NEW: Feedback status from API

  MessageModel({
    // ... existing parameters ...
    this.conversationId,         // ✨ NEW
    this.feedback,               // ✨ NEW
  });

  // Update fromJson to parse new fields
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      // ... existing fields ...
      conversationId: json['conversationId'] as int?,
      feedback: json['feedback'] as String?,
    );
  }

  // Update toJson to include new fields
  Map<String, dynamic> toJson() {
    return {
      // ... existing fields ...
      'conversationId': conversationId,
      'feedback': feedback,
    };
  }

  // Update copyWith to support new fields
  MessageModel copyWith({
    // ... existing parameters ...
    int? conversationId,
    String? feedback,
  }) {
    return MessageModel(
      // ... existing fields ...
      conversationId: conversationId ?? this.conversationId,
      feedback: feedback ?? this.feedback,
    );
  }
}
```

**Rationale**: Linking messages to conversation IDs enables feedback submission and better sync

---

### Phase 5: Repository & Use Case Updates (Optional - 30 minutes)

#### Step 5.1: Update GetChatHistory Use Case Signature

**File**: `lib/features/chat/domain/usecases/get_chat_history.dart`

**If using named parameters, update from `limit` to `size`:**

```dart
class GetChatHistory {
  final ChatRepository repository;

  GetChatHistory(this.repository);

  Future<Either<Failure, ChatHistoryResponse>> call({
    required String userId,
    required int page,
    int? size,                    // ✨ UPDATED: limit → size (optional)
  }) async {
    return await repository.getChatHistory(
      userId: userId,
      page: page,
      limit: size,                // Can still use limit internally if needed
    );
  }
}
```

**Note**: Internal repository methods can keep using `limit` parameter if preferred, since this is just a naming convention change.

---

### Phase 6: Mock Data Source Updates (30 minutes)

#### Step 6.1: Update ChatMockDataSource

**File**: `lib/features/chat/data/datasources/chat_mock_datasource.dart`

**Update mock chat history responses to include `id` and `feedback` fields:**

```dart
@override
Future<ChatHistoryResponseModel> getChatHistory({
  required String userId,
  required int page,
  int? limit,
}) async {
  await Future.delayed(const Duration(milliseconds: 500));

  // Mock conversations with IDs and feedback
  final mockConversations = [
    ConversationModel(
      id: 1,                                    // ✨ NEW
      userMessage: "What is my balance?",
      aiResponse: "Your current balance is ৳45,500",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      feedback: null,                           // ✨ NEW
    ),
    ConversationModel(
      id: 2,                                    // ✨ NEW
      userMessage: "I spent 500 taka on lunch",
      aiResponse: "✅ Expense recorded! Amount: ৳500, Category: Food & Dining",
      createdAt: DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
      feedback: "LIKE",                         // ✨ NEW: Example with feedback
    ),
    // ... more mock conversations ...
  ];

  return ChatHistoryResponseModel(
    userId: int.parse(userId),
    conversations: mockConversations,
    pagination: PaginationModel(
      currentPage: page,
      limit: limit ?? 20,
      returned: mockConversations.length,
      hasNext: false,
      nextPage: null,
    ),
  );
}
```

---

## Files to Create

**None** - All necessary entities and models already exist. This is purely an update operation.

---

## Files to Modify

### Critical Files (Must Update)

1. ✅ **`lib/core/constants/api_endpoints.dart`**
   - Update chat endpoint: `/chat` → `/v1/chat`
   - Update chat history endpoint: `/chat-history` → `/v1/chat-history`

2. ✅ **`lib/features/chat/domain/entities/chat_history_response.dart`**
   - Add `id` field to Conversation entity
   - Add `feedback` field to Conversation entity
   - Add helper methods for feedback checking

3. ✅ **`lib/features/chat/data/models/chat_history_response_model.dart`**
   - Add `id` field to ConversationModel
   - Add `feedback` field to ConversationModel
   - Update `fromJson`, `toJson`, and `toEntity` methods
   - Update `toMessageModels` to use conversation ID

4. ✅ **`lib/features/chat/data/models/chat_request_models.dart`**
   - Update ChatHistoryQueryParams: `limit` → `size`
   - Update default value to 20

5. ✅ **`lib/features/chat/data/datasources/chat_finance_guru_datasource.dart`**
   - Update getChatHistory method to use `size` parameter

### Optional Files (Recommended)

6. 🔵 **`lib/features/chat/data/models/message_model.dart`**
   - Add `conversationId` field (links to API conversation)
   - Add `feedback` field
   - Update serialization methods

7. 🔵 **`lib/features/chat/data/datasources/chat_mock_datasource.dart`**
   - Update mock responses with `id` and `feedback`

### Documentation Files

8. ✅ **`projectcontext/api/API_SPECIFICATION.md`** (Already Updated)
   - Updated chat endpoint to v1
   - Updated chat history endpoint to v1
   - Updated response schemas with `id` and `feedback`

---

## Testing Plan

### 1. Unit Tests (1 hour)

Create/update unit tests for:

```dart
// Test: Conversation entity with new fields
test('Conversation should have id and feedback fields', () {
  const conversation = Conversation(
    id: 123,
    userMessage: 'Test message',
    aiResponse: 'Test response',
    createdAt: '2025-12-12T10:00:00',
    feedback: 'LIKE',
  );

  expect(conversation.id, 123);
  expect(conversation.feedback, 'LIKE');
  expect(conversation.isLiked, true);
  expect(conversation.isDisliked, false);
});

// Test: ConversationModel JSON serialization
test('ConversationModel should serialize with id and feedback', () {
  final json = {
    'id': 456,
    'userMessage': 'Test',
    'aiResponse': 'Response',
    'createdAt': '2025-12-12T10:00:00',
    'feedback': null,
  };

  final model = ConversationModel.fromJson(json);
  expect(model.id, 456);
  expect(model.feedback, null);

  final serialized = model.toJson();
  expect(serialized['id'], 456);
  expect(serialized['feedback'], null);
});

// Test: ChatHistoryQueryParams with size parameter
test('ChatHistoryQueryParams should use size parameter', () {
  final params = ChatHistoryQueryParams(page: 1, size: 25);
  final queryMap = params.toQueryParams();

  expect(queryMap['page'], 1);
  expect(queryMap['size'], 25);
  expect(queryMap.containsKey('limit'), false);
});
```

### 2. Integration Tests (1 hour)

Test API integration with real/mock backend:

```dart
test('getChatHistory should return conversations with id and feedback', () async {
  final dataSource = ChatFinanceGuruDataSource(dio, sharedPreferences);

  final result = await dataSource.getChatHistory(
    userId: '123',
    page: 1,
    limit: 20,
  );

  expect(result.conversations.isNotEmpty, true);
  expect(result.conversations.first.id, isA<int>());
  expect(result.conversations.first.feedback, anyOf(isNull, isA<String>()));
});
```

### 3. Manual Testing Checklist

- [ ] Chat history loads successfully with v1 endpoint
- [ ] Conversations display with IDs
- [ ] Feedback status (if present) is visible
- [ ] Chat messages send successfully to v1 endpoint
- [ ] Pagination works with `size` parameter
- [ ] Mock mode works with updated models
- [ ] No crashes or null pointer exceptions
- [ ] UI displays feedback icons/indicators correctly (if implemented)

---

## Rollback Strategy

### If Issues Arise:

1. **Revert API Endpoints:**
   ```dart
   // In api_endpoints.dart
   static String get chat => '$financeGuruBaseUrl/chat';
   static String get chatHistory => '$financeGuruBaseUrl/chat-history';
   ```

2. **Revert Query Parameters:**
   ```dart
   // In chat_request_models.dart
   'limit': limit,  // Change back from 'size'
   ```

3. **Make New Fields Optional:**
   - If backend doesn't return `id` or `feedback`, make parsing lenient:
   ```dart
   id: json['id'] as int? ?? 0,  // Fallback to 0
   feedback: json['feedback'] as String?,  // Already optional
   ```

---

## Implementation Checklist

### Phase 1: Core Updates
- [ ] Update chat endpoint in `api_endpoints.dart`
- [ ] Update chat history endpoint in `api_endpoints.dart`

### Phase 2: Domain Layer
- [ ] Add `id` field to Conversation entity
- [ ] Add `feedback` field to Conversation entity
- [ ] Add helper methods (isLiked, isDisliked, hasFeedback)

### Phase 3: Data Layer
- [ ] Update ConversationModel with `id` and `feedback`
- [ ] Update fromJson to parse new fields
- [ ] Update toJson to serialize new fields
- [ ] Update toEntity mapping
- [ ] Update toMessageModels to use conversation IDs
- [ ] Change ChatHistoryQueryParams from `limit` to `size`
- [ ] Update datasource to use `size` parameter

### Phase 4: Optional Enhancements
- [ ] Add conversationId to MessageModel
- [ ] Add feedback to MessageModel
- [ ] Update mock data source with IDs and feedback

### Phase 5: Testing
- [ ] Write/update unit tests
- [ ] Run integration tests
- [ ] Perform manual testing
- [ ] Test in mock mode
- [ ] Test with real backend

### Phase 6: Documentation
- [ ] Update IMPLEMENTATION_STATUS.md
- [ ] Update progress.md with changes
- [ ] Update CLAUDE.md if needed

---

## Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| Backend not ready with v1 | Medium | Test with mock data first, verify API availability |
| Breaking changes in existing chats | Low | New fields are additive, not breaking |
| Null safety issues | Low | Make feedback nullable, provide defaults for id |
| UI not handling feedback | Low | Feedback is optional feature, can be added later |

---

## Success Criteria

✅ **Implementation Complete When:**

1. App successfully calls `/v1/chat` endpoint
2. App successfully calls `/v1/chat-history` endpoint with `size` parameter
3. Chat history responses include `id` and `feedback` fields
4. No runtime exceptions or crashes
5. All existing chat functionality works unchanged
6. Mock mode works with updated models
7. Unit tests pass
8. Manual testing passes

---

## Next Steps After Implementation

1. **UI Enhancement**: Add feedback buttons to chat messages
   - Thumbs up/down icons
   - Call `submitFeedback` use case on button press
   - Update UI when feedback is submitted

2. **Token Usage Dashboard**: Display token consumption
   - Show total and today's usage
   - Display usage history
   - Add usage warnings/limits

3. **Transaction Search UI**: Build transaction search page
   - Search bar with filters
   - Category and type filters
   - Date range picker
   - Results list with formatting

---

## Estimated Timeline

| Phase | Duration | Dependencies |
|-------|----------|--------------|
| Phase 1: API Endpoints | 30 mins | None |
| Phase 2: Domain Layer | 1 hour | Phase 1 |
| Phase 3: Data Layer | 1.5 hours | Phase 2 |
| Phase 4: Message Model | 1 hour | Phase 3 |
| Phase 5: Use Cases | 30 mins | Phase 3 |
| Phase 6: Mock Updates | 30 mins | Phase 3 |
| Testing | 2 hours | All phases |
| **Total** | **6-7 hours** | |

---

## Support & Resources

- **API Specification**: `projectcontext/api/API_SPECIFICATION.md`
- **Updated Specs**: `projectcontext/api/updated_finance_guru_specs/finance_guru_v1.md`
- **Architecture Guide**: `projectcontext/ARCHITECTURE.md`
- **Development Guide**: `projectcontext/DEVELOPMENT_GUIDE.md`

---

**Ready to implement? Review this plan and let me know when you're ready to proceed!**

---

*Last Updated: 2025-12-12*
*Plan Version: 1.0*
*Prepared by: Claude AI Assistant*
