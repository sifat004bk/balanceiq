# Webhook Integration Guide

## Overview
BalanceIQ has been updated to send requests to the n8n webhook in the format expected by the updated workflow. The Telegram trigger has been replaced with a webhook trigger in the n8n workflow.

## Changes Made

### 1. Flutter App Updates

#### `lib/core/constants/app_constants.dart`
- Updated `n8nWebhookUrl` to point to the new webhook endpoint:
  ```dart
  static const String n8nWebhookUrl = String.fromEnvironment(
    'N8N_WEBHOOK_URL',
    defaultValue: 'https://primary-production-7383b.up.railway.app/webhook/b1cfaa07-8bf1-4005-90e0-9759144705f2',
  );
  ```

#### `lib/features/chat/data/datasources/chat_remote_datasource.dart`
- Added `SharedPreferences` dependency to access user information
- Updated payload structure to match webhook's expected format:
  ```dart
  {
    'user_id': userId,
    'bot_id': botId,
    'content': content,
    'text': content,
    'message': content,
    'first_name': firstName,
    'last_name': lastName,
    'username': userEmail.split('@').first,
    'image_base64': base64Image,  // if image provided
    'audio_base64': base64Audio,   // if audio provided
  }
  ```
- User information is fetched from `SharedPreferences` (stored during authentication)
- Images and audio are encoded as base64 strings with keys `image_base64` and `audio_base64`

#### `lib/core/di/injection_container.dart`
- Updated `ChatRemoteDataSource` registration to inject `SharedPreferences`:
  ```dart
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl(), sl()),
  );
  ```

### 2. n8n Workflow Updates

#### New Workflow File
- Created: `Finance Guru (Webhook Updated).json`
- Location: `/Users/sifatullahchowdhury/Downloads/`

#### Key Changes in n8n Workflow:

1. **Webhook Trigger** (replaces Telegram Trigger)
   - Node type: `n8n-nodes-base.webhook`
   - Path: `b1cfaa07-8bf1-4005-90e0-9759144705f2`
   - Method: POST
   - Response mode: lastNode

2. **Transform Webhook to Telegram Format** (new node)
   - Node type: `n8n-nodes-base.code`
   - Purpose: Maps incoming webhook payload to Telegram-like structure
   - JavaScript code transforms Flutter app data to match existing workflow expectations
   - Handles text, image (base64), and audio (base64) inputs

3. **Send Response Back** (replaces Telegram send message)
   - Node type: `n8n-nodes-base.httpRequest`
   - Sends response back to the app via HTTP POST
   - Payload includes: user_id, bot_id, response, timestamp

4. **Updated All References**
   - Changed 16 references from `$('Telegram Trigger')` to `$('Transform Webhook to Telegram Format')`
   - All SQL queries, switch conditions, and agent prompts updated

## Payload Structure

### Request (Flutter → n8n)

```json
{
  "user_id": "user_unique_id",
  "bot_id": "balance_tracker",
  "content": "What's my balance?",
  "text": "What's my balance?",
  "message": "What's my balance?",
  "first_name": "John",
  "last_name": "Doe",
  "username": "johndoe",
  "image_base64": "base64_encoded_string",  // optional
  "audio_base64": "base64_encoded_string"   // optional
}
```

### Response (n8n → Flutter)

```json
{
  "user_id": "user_unique_id",
  "bot_id": "balance_tracker",
  "response": "Your current balance is $1,234.56",
  "timestamp": "2025-10-25T08:30:00.000Z"
}
```

## Webhook Endpoints

### Production URL
```
https://primary-production-7383b.up.railway.app/webhook-test/b1cfaa07-8bf1-4005-90e0-9759144705f2
```

### Testing
Use the production URL for testing. The workflow processes:
- ✅ Text messages
- ✅ Image receipts (as base64)
- ✅ Voice audio (as base64)

## Data Flow

1. **User Input** → Flutter app captures text/image/audio
2. **Encoding** → Media files converted to base64
3. **User Info** → Retrieved from SharedPreferences
4. **Payload** → Constructed with all required fields
5. **HTTP POST** → Sent to n8n webhook
6. **Transform** → Webhook data mapped to Telegram format
7. **Processing** → Existing workflow processes the request
8. **Response** → Bot response sent back to app
9. **Display** → Message shown in chat interface

## Database Tables

The n8n workflow interacts with PostgreSQL tables:

### `users` table
- Stores user information
- Fields: chat_id, first_name, last_name, user_name

### `user_query` table
- Stores chat history
- Fields: id, chat_id, user_message, ai_response, manager_response, created_at, updated_at

### `finance_data_chat_history` table
- Stores conversation context for AI memory
- Used by LangChain Postgres Chat Memory

## Bot IDs

All 4 bots use the same workflow (for now):

- `balance_tracker` - Balance Tracker
- `investment_guru` - Investment Guru
- `budget_planner` - Budget Planner
- `fin_tips` - Fin Tips

## Migration from Telegram

The workflow maintains backward compatibility:
- All existing AI agents unchanged
- Database schema identical
- Response processing logic preserved
- Only trigger and response mechanisms changed

## Testing Checklist

- [ ] Text message sending
- [ ] Image upload (receipt scanning)
- [ ] Audio message recording
- [ ] Google Sign-In user info population
- [ ] Database user creation
- [ ] Chat history retrieval
- [ ] AI response generation
- [ ] All 4 bots functionality
- [ ] Error handling

## Environment Variables

To use a custom webhook URL, build the app with:

```bash
flutter run --dart-define=N8N_WEBHOOK_URL=https://your-custom-url.com/webhook
```

Or for release build:

```bash
flutter build apk --dart-define=N8N_WEBHOOK_URL=https://your-custom-url.com/webhook
```

## Troubleshooting

### Issue: "Request timeout"
- Check internet connection
- Verify webhook URL is accessible
- Check n8n workflow is active

### Issue: "No response from bot"
- Check n8n workflow execution logs
- Verify database connectivity
- Check AI model (Groq) API limits

### Issue: "User not found"
- Ensure Google Sign-In completed successfully
- Check SharedPreferences has user data
- Verify `users` table in PostgreSQL

## Future Enhancements

1. **Separate workflows per bot** - Currently all bots use the same workflow
2. **Response streaming** - Real-time AI response chunks
3. **File attachments** - Support PDFs, spreadsheets
4. **Push notifications** - Backend-triggered alerts
5. **WebSocket** - Faster bidirectional communication

## Support

For issues or questions:
1. Check n8n workflow execution logs
2. Review Flutter debug console
3. Check PostgreSQL database logs
4. Verify Google Cloud Console for auth issues
