# BalanceIQ Development Guide

This guide explains how to extend and customize the BalanceIQ app.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Adding a New Bot](#adding-a-new-bot)
- [Adding New Features](#adding-new-features)
- [Modifying the UI](#modifying-the-ui)
- [Database Changes](#database-changes)
- [API Integration](#api-integration)
- [Best Practices](#best-practices)

## Architecture Overview

BalanceIQ follows **Clean Architecture** with three main layers:

### 1. Domain Layer (`lib/features/*/domain/`)
- **Entities**: Pure business objects (e.g., `Message`, `User`)
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Business logic for specific actions

### 2. Data Layer (`lib/features/*/data/`)
- **Models**: Data transfer objects with JSON serialization
- **Repositories**: Concrete implementations of domain repositories
- **Data Sources**: Local (SQLite) and remote (n8n API) data sources

### 3. Presentation Layer (`lib/features/*/presentation/`)
- **Pages**: Full screen widgets
- **Widgets**: Reusable UI components
- **Cubit**: State management (business logic for UI)

## Adding a New Bot

Let's add a new bot called "Savings Advisor".

### Step 1: Add Constants

Edit `lib/core/constants/app_constants.dart`:

```dart
// Bot Types
static const String savingsAdvisor = 'Savings Advisor';

// Bot IDs for API
static const String savingsAdvisorID = 'savings_advisor';
```

### Step 2: Add Bot Color and Icon

Edit `lib/core/theme/app_theme.dart`:

```dart
// Bot Colors
static const Color savingsAdvisorColor = Color(0xFFFF5722); // Orange

// In getBotColor method:
case 'savings_advisor':
  return savingsAdvisorColor;

// In getBotIcon method:
case 'savings_advisor':
  return Icons.savings;
```

### Step 3: Add Bot Button to Home Screen

Edit `lib/features/home/presentation/pages/home_page.dart`:

```dart
_buildBotButton(
  context,
  botId: AppConstants.savingsAdvisorID,
  botName: AppConstants.savingsAdvisor,
  icon: AppTheme.getBotIcon(AppConstants.savingsAdvisorID),
  color: AppTheme.getBotColor(AppConstants.savingsAdvisorID),
),
```

### Step 4: Add Welcome Message

Edit `lib/features/chat/presentation/widgets/message_list.dart`:

```dart
case AppConstants.savingsAdvisorID:
  return 'I can help you maximize your savings and reach your financial goals.';
```

### Step 5: Update n8n Workflow

Add handling for `savings_advisor` bot_id in your n8n workflow.

That's it! The new bot is ready to use.

## Adding New Features

### Example: Add Message Delete Functionality

#### 1. Add Use Case (Domain Layer)

Create `lib/features/chat/domain/usecases/delete_message.dart`:

```dart
import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteMessage {
  final ChatRepository repository;

  DeleteMessage(this.repository);

  Future<Either<Failure, void>> call(String messageId) async {
    return await repository.deleteMessage(messageId);
  }
}
```

#### 2. Register in Dependency Injection

Edit `lib/core/di/injection_container.dart`:

```dart
// Use cases
sl.registerLazySingleton(() => DeleteMessage(sl()));

// In ChatCubit factory:
() => ChatCubit(
  getMessages: sl(),
  sendMessage: sl(),
  deleteMessage: sl(), // Add this
),
```

#### 3. Add to Cubit (Presentation Layer)

Edit `lib/features/chat/presentation/cubit/chat_cubit.dart`:

```dart
final DeleteMessage deleteMessage;

ChatCubit({
  required this.getMessages,
  required this.sendMessage,
  required this.deleteMessage,
}) : super(ChatInitial());

Future<void> deleteMsg(String messageId, String botId) async {
  final result = await deleteMessage(messageId);
  result.fold(
    (failure) => emit(ChatError(message: failure.message)),
    (_) => loadMessages(botId), // Reload messages after delete
  );
}
```

#### 4. Add UI (Widget Layer)

Edit `lib/features/chat/presentation/widgets/message_bubble.dart`:

Add a long-press menu:

```dart
GestureDetector(
  onLongPress: () {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Message'),
            onTap: () {
              Navigator.pop(context);
              context.read<ChatCubit>().deleteMsg(message.id, message.botId);
            },
          ),
        ],
      ),
    );
  },
  child: Container(
    // Existing message bubble code
  ),
)
```

## Modifying the UI

### Changing Colors

Edit `lib/core/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF4A90E2); // Change this
```

### Changing Fonts

1. Add font files to `assets/fonts/`
2. Update `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: CustomFont
      fonts:
        - asset: assets/fonts/CustomFont-Regular.ttf
        - asset: assets/fonts/CustomFont-Bold.ttf
          weight: 700
```

3. Update theme:

```dart
fontFamily: 'CustomFont',
```

### Customizing Message Bubbles

Edit `lib/features/chat/presentation/widgets/message_bubble.dart`:

```dart
decoration: BoxDecoration(
  color: isUser ? AppTheme.userMessageColor : botMessageColor,
  borderRadius: BorderRadius.circular(16), // Change radius
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ],
),
```

## Database Changes

### Adding a New Table

Edit `lib/core/database/database_helper.dart`:

```dart
Future<void> _createDB(Database db, int version) async {
  // Existing tables...

  // New table
  await db.execute('''
    CREATE TABLE favorites (
      id TEXT PRIMARY KEY,
      message_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (message_id) REFERENCES messages(id)
    )
  ''');
}
```

### Adding a Column to Existing Table

```dart
Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
      ALTER TABLE messages ADD COLUMN is_favorite INTEGER DEFAULT 0
    ''');
  }
}
```

Update version:

```dart
static const int databaseVersion = 2;
```

### Creating Data Source for New Table

Create `lib/features/chat/data/datasources/favorites_local_datasource.dart`:

```dart
abstract class FavoritesLocalDataSource {
  Future<void> addFavorite(String messageId, String userId);
  Future<List<MessageModel>> getFavorites(String userId);
  Future<void> removeFavorite(String messageId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final DatabaseHelper databaseHelper;

  FavoritesLocalDataSourceImpl(this.databaseHelper);

  // Implement methods...
}
```

## API Integration

### Changing Request Format

Edit `lib/features/chat/data/datasources/chat_remote_datasource.dart`:

```dart
final Map<String, dynamic> payload = {
  'bot_id': botId,
  'message': content,
  'timestamp': DateTime.now().toIso8601String(),
  'user_id': 'current_user_id', // Add user ID
  'session_id': 'unique_session', // Add session tracking
};
```

### Adding Custom Headers

```dart
final response = await dio.post(
  AppConstants.n8nWebhookUrl,
  data: payload,
  options: Options(
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your-token', // Add auth
      'X-App-Version': '1.0.0',
    },
  ),
);
```

### Handling Different Response Formats

```dart
if (response.statusCode == 200) {
  final responseData = response.data;

  // Handle array response
  if (responseData is List) {
    return responseData.map((item) => MessageModel.fromJson(item)).toList();
  }

  // Handle object response
  if (responseData is Map<String, dynamic>) {
    return MessageModel.fromJson(responseData);
  }
}
```

## Best Practices

### 1. State Management

Always use Cubit for business logic:

```dart
// ❌ Bad: Logic in widget
ElevatedButton(
  onPressed: () {
    final message = controller.text;
    repository.sendMessage(message); // Don't do this
  },
)

// ✅ Good: Logic in Cubit
ElevatedButton(
  onPressed: () {
    context.read<ChatCubit>().sendNewMessage(
      botId: botId,
      content: controller.text,
    );
  },
)
```

### 2. Error Handling

Always handle both success and failure:

```dart
final result = await useCase();
result.fold(
  (failure) {
    // Handle error
    emit(ErrorState(failure.message));
  },
  (data) {
    // Handle success
    emit(SuccessState(data));
  },
);
```

### 3. Clean Code

- Use meaningful variable names
- Keep functions small (< 20 lines)
- Add comments for complex logic
- Follow Dart style guide

### 4. Testing

Write tests for critical features:

```dart
test('should send message successfully', () async {
  // Arrange
  when(mockRepository.sendMessage(any))
    .thenAnswer((_) async => Right(mockMessage));

  // Act
  await cubit.sendNewMessage(
    botId: 'test_bot',
    content: 'test message',
  );

  // Assert
  expect(cubit.state, isA<ChatLoaded>());
});
```

### 5. Performance

- Use `const` constructors where possible
- Avoid rebuilding entire widget trees
- Cache images and data appropriately
- Lazy load data when needed

## Common Tasks

### Update App Name

1. Edit `lib/core/constants/app_constants.dart`:
   ```dart
   static const String appName = 'YourAppName';
   ```

2. Android: `android/app/src/main/AndroidManifest.xml`
3. iOS: `ios/Runner/Info.plist`

### Update App Icon

1. Replace icons in `android/app/src/main/res/mipmap-*/`
2. Replace icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Change Package Name

Use the `change_app_package_name` package:

```bash
flutter pub global activate change_app_package_name
flutter pub global run change_app_package_name:main com.yourcompany.yourapp
```

## Debugging Tips

### 1. Use Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 2. Add Logging

```dart
import 'dart:developer' as developer;

developer.log('Message sent', name: 'ChatCubit');
```

### 3. Debug Network Requests

Use Dio interceptors:

```dart
dio.interceptors.add(LogInterceptor(
  request: true,
  responseBody: true,
  requestBody: true,
));
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Cubit Documentation](https://bloclibrary.dev/#/coreconcepts?id=cubit)
- [n8n Documentation](https://docs.n8n.io/)

---

Happy coding! If you have questions, check the README or open an issue on GitHub.
