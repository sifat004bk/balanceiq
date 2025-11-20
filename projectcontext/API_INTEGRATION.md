# API Integration Guide

This document details the n8n webhook integration and API contracts for BalanceIQ.

## Overview

BalanceIQ uses **n8n workflows** as its backend, communicating via RESTful webhook endpoints. All AI processing, data storage, and business logic happen in n8n.

**Architecture**:
```
Flutter App → HTTP POST → n8n Webhook → AI Processing → PostgreSQL
                                     ↓
                              Response JSON → Flutter App
```

## Configuration

### Environment Variables

**File**: `.env` (root directory)
```bash
# Chat API (send messages, get responses)
N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/balance-iq

# Dashboard API (get financial summary)
N8N_DASHBOARD_URL=https://your-n8n-instance.com/webhook-test/get-user-dashboard
```

### App Constants

**File**: `lib/core/constants/app_constants.dart`
```dart
class AppConstants {
  // API URLs from .env
  static String get n8nWebhookUrl => dotenv.get(
        'N8N_WEBHOOK_URL',
        fallback: 'https://primary-production-7383b.up.railway.app/webhook/balance-iq',
      );

  static String get n8nDashboardUrl => dotenv.get(
        'N8N_DASHBOARD_URL',
        fallback: 'https://primary-production-7383b.up.railway.app/webhook-test/get-user-dashboard',
      );

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Bot Configuration
  static const String botID = 'balance_tracker';
  static const String botName = 'BalanceIQ';
}
```

## API Endpoints

### 1. Chat API (Send Message)

**Endpoint**: `POST {N8N_WEBHOOK_URL}`

**Purpose**: Send user messages (text, image, audio) and receive AI responses

#### Request Format

**Headers**:
```
Content-Type: application/json
```

**Body**:
```json
{
  "user_id": "8130001838",
  "bot_id": "balance_tracker",
  "content": "I spent 500 taka on lunch",
  "text": "I spent 500 taka on lunch",
  "message": "I spent 500 taka on lunch",
  "first_name": "John",
  "last_name": "Doe",
  "username": "johndoe@example.com",
  "image_base64": "data:image/jpeg;base64,/9j/4AAQSkZJRg...",
  "audio_base64": "data:audio/mp3;base64,SUQzBAAAAAAAI..."
}
```

**Field Details**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_id` | string | Yes | Unique user identifier |
| `bot_id` | string | Yes | Always "balance_tracker" |
| `content` | string | Yes | User message text |
| `text` | string | Yes | Same as content (legacy) |
| `message` | string | Yes | Same as content (legacy) |
| `first_name` | string | Yes | User's first name |
| `last_name` | string | Yes | User's last name |
| `username` | string | Yes | User's email |
| `image_base64` | string | No | Base64 encoded image |
| `audio_base64` | string | No | Base64 encoded audio |

**Image Format**:
- Prefix: `data:image/jpeg;base64,` or `data:image/png;base64,`
- Max size: 10 MB
- Encoding: Base64

**Audio Format**:
- Prefix: `data:audio/mp3;base64,`
- Max size: 25 MB
- Encoding: Base64

#### Response Format

**Success (200 OK)**:

n8n returns either an **array** or **object**:

**Option 1: Array Response** (default n8n behavior):
```json
[
  {
    "id": "msg_67890",
    "message": "Added 500 BDT lunch expense under Food & Dining category!",
    "response": null,
    "image_url": null,
    "audio_url": null
  }
]
```

**Option 2: Object Response**:
```json
{
  "id": "msg_67890",
  "message": "Added 500 BDT lunch expense under Food & Dining category!",
  "response": "Added 500 BDT lunch expense under Food & Dining category!",
  "image_url": null,
  "audio_url": null
}
```

**Response Fields**:
| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Message ID |
| `message` | string | Bot response text |
| `response` | string | Alternative response field |
| `image_url` | string? | URL to response image |
| `audio_url` | string? | URL to response audio |

**Error Responses**:
```json
{
  "error": "Invalid user_id",
  "message": "User not found"
}
```

#### Code Implementation

**File**: `lib/features/chat/data/datasources/chat_remote_datasource.dart`

```dart
Future<MessageModel> sendMessage(Message message) async {
  try {
    // Get user info
    final user = await authLocalDataSource.getCachedUser();

    // Prepare request body
    final data = {
      'user_id': user.id,
      'bot_id': message.botId,
      'content': message.content,
      'text': message.content,
      'message': message.content,
      'first_name': user.name.split(' ').first,
      'last_name': user.name.split(' ').last,
      'username': user.email,
    };

    // Add media if present
    if (message.imageUrl != null) {
      data['image_base64'] = await _encodeImageToBase64(message.imageUrl!);
    }
    if (message.audioUrl != null) {
      data['audio_base64'] = await _encodeAudioToBase64(message.audioUrl!);
    }

    // Send request
    final response = await dio.post(
      AppConstants.n8nWebhookUrl,
      data: data,
      options: Options(
        headers: {'Content-Type': 'application/json'},
        sendTimeout: AppConstants.sendTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
      ),
    );

    // Parse response (handle both array and object)
    dynamic responseData = response.data;
    if (responseData is List && responseData.isNotEmpty) {
      responseData = responseData[0];
    }

    return MessageModel(
      id: responseData['id'] ?? const Uuid().v4(),
      botId: message.botId,
      sender: 'bot',
      content: responseData['message'] ?? responseData['response'] ?? 'No response',
      timestamp: DateTime.now(),
    );
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('Connection timeout');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Receive timeout');
    } else {
      throw Exception('Network error: ${e.message}');
    }
  }
}
```

### 2. Dashboard API (Get Financial Summary)

**Endpoint**: `POST {N8N_DASHBOARD_URL}`

**Purpose**: Retrieve user's financial summary for dashboard display

#### Request Format

**Headers**:
```
Content-Type: application/json
```

**Body**:
```json
{
  "user_id": "8130001838",
  "bot_id": "balance_tracker",
  "first_name": "John",
  "last_name": "Doe",
  "username": "johndoe@example.com"
}
```

**Field Details**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_id` | string | Yes | Unique user identifier |
| `bot_id` | string | Yes | Always "balance_tracker" |
| `first_name` | string | Yes | User's first name |
| `last_name` | string | Yes | User's last name |
| `username` | string | Yes | User's email |

#### Response Format

**Success (200 OK)**:
```json
{
  "data": [
    {
      "total_income": 50000.00,
      "total_expense": 32000.00,
      "net_balance": 18000.00,
      "expense_ratio": 64.0,
      "savings_rate": 36.0,
      "income_transactions": 3,
      "expense_transactions": 45,
      "avg_income": 16666.67,
      "avg_expense": 711.11,
      "spending_trend": [
        {"date": "2025-11-01", "amount": 1200.00},
        {"date": "2025-11-02", "amount": 850.00},
        ...
      ],
      "categories": {
        "Food & Dining": 8500.00,
        "Transportation": 4200.00,
        "Shopping": 6800.00,
        "Bills & Utilities": 5500.00,
        "Entertainment": 2800.00,
        "Others": 4200.00
      },
      "accounts_breakdown": {
        "Cash": 5000.00,
        "bKash": 8000.00,
        "Bank - Dutch Bangla": 5000.00
      },
      "biggest_expense_amount": 3500.00,
      "biggest_expense_description": "Grocery shopping",
      "expense_category": "Food & Dining",
      "expense_account": "bKash",
      "biggest_category_name": "Food & Dining",
      "biggest_category_amount": 8500.00,
      "period": "November 2025",
      "days_remaining_in_month": 9
    }
  ]
}
```

**Response Fields**:
| Field | Type | Description |
|-------|------|-------------|
| `total_income` | number | Total income for period |
| `total_expense` | number | Total expenses for period |
| `net_balance` | number | Income - Expenses |
| `expense_ratio` | number | Expenses/Income % |
| `savings_rate` | number | Savings/Income % |
| `income_transactions` | number | Number of income entries |
| `expense_transactions` | number | Number of expense entries |
| `avg_income` | number | Average income per transaction |
| `avg_expense` | number | Average expense per transaction |
| `spending_trend` | array | Daily spending data (30 days) |
| `categories` | object | Category-wise spending |
| `accounts_breakdown` | object | Balance per account |
| `biggest_expense_amount` | number | Largest single expense |
| `biggest_expense_description` | string | Description of largest expense |
| `expense_category` | string | Category of largest expense |
| `expense_account` | string | Account of largest expense |
| `biggest_category_name` | string | Category with most spending |
| `biggest_category_amount` | number | Total of biggest category |
| `period` | string | Period name (e.g., "November 2025") |
| `days_remaining_in_month` | number | Days left in current month |

**Error Responses**:
```json
{
  "error": "User not found",
  "message": "No data available for user"
}
```

#### Code Implementation

**File**: `lib/features/home/data/datasources/remote_datasource/dashboard_remote_datasource.dart`

```dart
Future<DashboardSummaryResponse> getDashboardSummary({
  required String userId,
  required String botId,
  required String firstName,
  required String lastName,
  required String username,
}) async {
  try {
    final response = await dio.post(
      AppConstants.n8nDashboardUrl,
      data: {
        'user_id': userId,
        'bot_id': botId,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
        sendTimeout: AppConstants.sendTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
      ),
    );

    // Parse response
    final data = response.data['data'][0];
    return DashboardSummaryResponse.fromJson(data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      throw Exception('Dashboard service not found');
    } else if (e.response?.statusCode == 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Failed to load dashboard: ${e.message}');
    }
  }
}
```

## Data Flow

### Chat Message Flow

```
1. User sends message from ChatInput widget
   ↓
2. ChatCubit.sendNewMessage()
   - Creates temporary message
   - Emits ChatLoaded (optimistic UI)
   ↓
3. SendMessage use case
   ↓
4. ChatRepositoryImpl.sendMessage()
   - Saves user message to SQLite
   - Calls remote data source
   ↓
5. ChatRemoteDataSource.sendMessage()
   - Encodes media to Base64
   - Sends POST to n8n
   - Waits for response
   ↓
6. n8n Workflow
   - Receives message
   - Extracts expense data (if image: OCR)
   - Categorizes transaction
   - Updates PostgreSQL
   - Generates AI response
   - Returns JSON
   ↓
7. ChatRemoteDataSource parses response
   ↓
8. ChatRepositoryImpl saves bot message to SQLite
   ↓
9. ChatCubit reloads messages
   ↓
10. UI updates with bot response
```

### Dashboard Load Flow

```
1. HomePage loads
   ↓
2. DashboardCubit.loadDashboard()
   ↓
3. GetDashboardSummary use case
   ↓
4. DashboardRepositoryImpl.getDashboardSummary()
   - Gets cached user
   - Calls remote data source
   ↓
5. DashboardRemoteDataSource.getDashboardSummary()
   - Sends POST to n8n
   - Waits for response
   ↓
6. n8n Workflow
   - Queries PostgreSQL for user transactions
   - Calculates financial metrics
   - Aggregates spending trends
   - Returns JSON
   ↓
7. DashboardRemoteDataSource parses response
   ↓
8. DashboardRepositoryImpl converts to entity
   ↓
9. DashboardCubit emits DashboardLoaded
   ↓
10. HomePage rebuilds with dashboard widgets
```

## Error Handling

### Connection Errors
```dart
try {
  // API call
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    return Left(ServerFailure('Connection timeout. Check your internet.'));
  } else if (e.type == DioExceptionType.receiveTimeout) {
    return Left(ServerFailure('Server took too long to respond.'));
  } else if (e.type == DioExceptionType.connectionError) {
    return Left(ServerFailure('No internet connection.'));
  } else {
    return Left(ServerFailure('Network error: ${e.message}'));
  }
}
```

### API Errors
```dart
if (response.statusCode == 404) {
  return Left(ServerFailure('Service not found'));
} else if (response.statusCode == 500) {
  return Left(ServerFailure('Server error. Try again later.'));
} else {
  return Left(ServerFailure('Unexpected error'));
}
```

### Data Validation
```dart
try {
  final data = response.data['data'][0];
  if (data == null) {
    return Left(ServerFailure('No dashboard data available'));
  }
  return Right(DashboardSummaryResponse.fromJson(data));
} on FormatException {
  return Left(ServerFailure('Invalid data format'));
}
```

## Testing API Integration

### Using Postman/Insomnia

**Test Chat API**:
```bash
POST https://your-n8n-instance.com/webhook/balance-iq
Content-Type: application/json

{
  "user_id": "test_123",
  "bot_id": "balance_tracker",
  "content": "I spent 500 taka on lunch",
  "text": "I spent 500 taka on lunch",
  "message": "I spent 500 taka on lunch",
  "first_name": "Test",
  "last_name": "User",
  "username": "test@example.com"
}
```

**Test Dashboard API**:
```bash
POST https://your-n8n-instance.com/webhook-test/get-user-dashboard
Content-Type: application/json

{
  "user_id": "test_123",
  "bot_id": "balance_tracker",
  "first_name": "Test",
  "last_name": "User",
  "username": "test@example.com"
}
```

### Using Flutter App

```dart
// Enable logging in Dio
final dio = Dio()
  ..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
```

## Common Issues

### Issue 1: 404 Not Found
**Cause**: Incorrect URL in .env
**Solution**: Verify webhook URL is correct and active

### Issue 2: Timeout
**Cause**: Slow network or n8n processing
**Solution**: Increase timeout duration

### Issue 3: Invalid Response Format
**Cause**: n8n returns unexpected structure
**Solution**: Add response validation and logging

### Issue 4: Base64 Encoding Error
**Cause**: Image/audio too large
**Solution**: Compress before encoding

---

**Next**: Check [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md) for API integration status, or [TASKS.md](TASKS.md) for API-related tasks.

---

**Last Updated**: 2025-11-21
