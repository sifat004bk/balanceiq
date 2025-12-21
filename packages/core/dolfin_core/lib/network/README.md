# Network Logging

## Overview

Centralized logging for all HTTP requests and responses via `LoggingInterceptor`.

**Key Feature**: Logs **ONLY in debug mode** - No logs in release builds.

## Features

- ✅ Automatic logging for all Dio requests
- ✅ Pretty-printed JSON bodies
- ✅ Color-coded sections (request, response, error)
- ✅ Truncates large responses (>5000 chars) for readability
- ✅ Shows full stack trace on errors (first 5 lines)
- ✅ **Zero impact on release builds** (uses `kDebugMode` check)

## Implementation

### 1. Interceptor (`logging_interceptor.dart`)

```dart
class LoggingInterceptor extends Interceptor {
  // Only logs when kDebugMode is true
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logRequest(options);
    }
    super.onRequest(options, handler);
  }
  // ... similar for onResponse and onError
}
```

### 2. Integration (`injection_container.dart`)

```dart
sl.registerLazySingleton(() {
  final dio = Dio(BaseOptions(...));
  dio.interceptors.add(LoggingInterceptor()); // Automatically logs all requests
  return dio;
});
```

## Example Output

### ✅ Successful Request

```
┌─────────────────────────────────────────────────────────────
│ 🚀 REQUEST
├─────────────────────────────────────────────────────────────
│ Method: POST
│ URL: https://your-n8n-instance.com/webhook/balance-iq
│ Headers:
│   Content-Type: application/json
│   Accept: application/json
│ Body:
│   {
│     "user_id": "8130001838",
│     "bot_id": "balance_tracker",
│     "content": "I spent 500 taka on lunch",
│     "text": "I spent 500 taka on lunch",
│     "first_name": "John",
│     "last_name": "Doe",
│     "username": "johndoe@example.com"
│   }
└─────────────────────────────────────────────────────────────

┌─────────────────────────────────────────────────────────────
│ ✅ RESPONSE
├─────────────────────────────────────────────────────────────
│ Status Code: 200
│ Status Message: OK
│ URL: https://your-n8n-instance.com/webhook/balance-iq
│ Response Body:
│   [
│     {
│       "id": "msg_67890",
│       "message": "Added 500 BDT lunch expense!",
│       "response": null,
│       "image_url": null,
│       "audio_url": null
│     }
│   ]
└─────────────────────────────────────────────────────────────
```

### ❌ Error Response

```
┌─────────────────────────────────────────────────────────────
│ ❌ ERROR
├─────────────────────────────────────────────────────────────
│ Type: DioExceptionType.badResponse
│ Message: Http status error [404]
│ URL: https://your-n8n-instance.com/webhook/invalid
│ Status Code: 404
│ Status Message: Not Found
│ Error Response:
│   {
│     "error": "Endpoint not found",
│     "message": "The requested resource does not exist"
│   }
│ Stack Trace:
│   #0      DioMixin._dispatchRequest (package:dio/src/dio_mixin.dart:539:7)
│   #1      DioMixin.fetch (package:dio/src/dio_mixin.dart:511:5)
│   #2      DioMixin.request (package:dio/src/dio_mixin.dart:171:12)
│   #3      DioMixin.post (package:dio/src/dio_mixin.dart:83:12)
│   #4      ChatRemoteDataSourceImpl.sendMessage (...)
└─────────────────────────────────────────────────────────────
```

## Configuration

### Timeouts (set in DI)

```dart
BaseOptions(
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  sendTimeout: const Duration(seconds: 30),
)
```

### Response Truncation

- Responses > 5000 characters are truncated to first 50 lines
- Shows total character count: `... (12345 characters total, truncated for readability)`

### Stack Trace Limit

- Only first 5 lines shown to keep console clean
- Full trace available in IDE debugger

## Release Builds

**Guaranteed zero logs in production**:

```dart
if (kDebugMode) {
  _logRequest(options); // This entire block is stripped in release builds
}
```

The Dart compiler removes all code inside `kDebugMode` blocks when building in release mode, so there's no performance impact whatsoever.

## Testing

### Debug Mode
```bash
flutter run  # Logs will appear in console
```

### Release Mode
```bash
flutter run --release  # No logs, production-ready
flutter build apk --release  # Verify no logs in release build
```

## Customization

### Disable logging temporarily (debug only)

Comment out the interceptor:
```dart
// dio.interceptors.add(LoggingInterceptor());
```

### Add custom headers logging

Modify `_logRequest()` to include additional info:
```dart
print('│ Custom Header: ${options.headers['X-Custom']}');
```

### Change truncation limits

```dart
if (bodyString.length > 10000) {  // Increase from 5000
  final lines = bodyString.split('\n');
  final limitedLines = lines.take(100).toList();  // Show more lines
  // ...
}
```

## Benefits

1. **Debugging**: Instantly see what's being sent/received
2. **API Issues**: Quickly identify malformed requests or unexpected responses
3. **Performance**: Zero overhead in production
4. **Maintainability**: Single place to modify logging behavior
5. **Consistency**: All network calls logged the same way

## Common Use Cases

### 1. Debug API Integration
See exactly what's sent to n8n webhooks and what comes back.

### 2. Troubleshoot Auth Issues
Verify OAuth tokens, headers, and response codes.

### 3. Check Base64 Encoding
See if images/audio are properly encoded (shows truncated version).

### 4. Monitor Network Errors
Catch timeout issues, 404s, 500s with full context.

---

**Last Updated**: 2025-11-21
**Location**: `lib/core/network/logging_interceptor.dart`
