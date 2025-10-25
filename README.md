# BalanceIQ

**BalanceIQ** is an AI-powered personal finance chatbot application built with Flutter. It features four specialized financial bots that help users manage their finances through an intuitive chat interface.

## Features

### Four Specialized Bots
1. **Balance Tracker** - Monitor expenses and track spending patterns
2. **Investment Guru** - Get insights and tips on investment options
3. **Budget Planner** - Create and maintain budgets effectively
4. **Fin Tips** - Learn financial literacy and smart money habits

### Key Capabilities
- Text, image, and audio message support
- Persistent chat history with local SQLite database
- Google and Apple sign-in authentication
- Dark mode support
- Integration with n8n workflow for AI responses
- Clean architecture with Cubit state management

## Architecture

The project follows **Clean Architecture** principles with three main layers:

```
lib/
├── core/                    # Core utilities, constants, and theme
│   ├── constants/
│   ├── database/
│   ├── di/                  # Dependency injection
│   ├── error/
│   └── theme/
└── features/               # Feature modules
    ├── auth/               # Authentication
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── chat/               # Chat functionality
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── home/               # Home screen
        └── presentation/
```

### Technology Stack
- **Flutter** - Cross-platform mobile framework
- **Cubit** (flutter_bloc) - State management
- **SQLite** - Local database for chat history
- **GetIt** - Dependency injection
- **Dio** - HTTP client for API calls
- **n8n** - Workflow automation for AI responses

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Xcode (for iOS development)
- Android Studio (for Android development)
- n8n workflow instance

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd balanceIQ
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure n8n Webhook URL**

   The app uses an n8n webhook for AI responses. You can configure the webhook URL in two ways:

   **Option 1: Environment Variable (Recommended)**
   ```bash
   flutter run --dart-define=N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/balance-iq
   ```

   **Option 2: Update Constants File**

   Edit [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart) and update the default value:
   ```dart
   static const String n8nWebhookUrl = 'https://your-n8n-instance.com/webhook/balance-iq';
   ```

4. **Configure Google Sign-In**

   **For Android:**
   - Follow the [Google Sign-In setup guide](https://pub.dev/packages/google_sign_in#android-integration)
   - Add your SHA-1 fingerprint to Firebase Console
   - Download and add `google-services.json` to `android/app/`

   **For iOS:**
   - Follow the [Google Sign-In setup guide](https://pub.dev/packages/google_sign_in#ios-integration)
   - Add your OAuth client ID to [ios/Runner/Info.plist](ios/Runner/Info.plist)

5. **Configure Apple Sign-In (iOS only)**

   - Enable Sign in with Apple in Xcode capabilities
   - Follow the [Sign in with Apple setup guide](https://pub.dev/packages/sign_in_with_apple)

### Running the App

```bash
# Run in debug mode
flutter run

# Run with custom n8n webhook URL
flutter run --dart-define=N8N_WEBHOOK_URL=https://your-webhook-url.com

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release
```

## Permissions

### Android
The following permissions are required and configured in [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml):
- `INTERNET` - Network access for API calls
- `CAMERA` - Take photos for chat messages
- `RECORD_AUDIO` - Record audio messages
- `READ_EXTERNAL_STORAGE` - Access photos from gallery
- `WRITE_EXTERNAL_STORAGE` - Save photos (Android 12 and below)

### iOS
The following permission descriptions are configured in [ios/Runner/Info.plist](ios/Runner/Info.plist):
- `NSCameraUsageDescription` - Camera access
- `NSPhotoLibraryUsageDescription` - Photo library access
- `NSMicrophoneUsageDescription` - Microphone access
- `NSPhotoLibraryAddUsageDescription` - Save photos to library

## n8n Workflow Configuration

Your n8n workflow should accept the following JSON payload:

```json
{
  "bot_id": "balance_tracker|investment_guru|budget_planner|fin_tips",
  "message": "User's text message",
  "timestamp": "ISO 8601 timestamp",
  "image": "Base64 encoded image (optional)",
  "audio": "Base64 encoded audio (optional)"
}
```

And return a response in this format:

```json
{
  "id": "unique_message_id",
  "message": "Bot's response text",
  "image_url": "https://url-to-image.com (optional)",
  "audio_url": "https://url-to-audio.com (optional)"
}
```

## File Size Limits

- **Images:** Maximum 10 MB
- **Audio:** Maximum 25 MB

These limits can be configured in [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart).

## Database Schema

The app uses SQLite with the following tables:

### Users Table
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  photo_url TEXT,
  auth_provider TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

### Messages Table
```sql
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
);
```

## Project Structure

```
balanceIQ/
├── android/                 # Android native code
├── ios/                     # iOS native code
├── lib/                     # Flutter application code
│   ├── core/               # Core utilities and shared code
│   ├── features/           # Feature modules
│   └── main.dart           # Application entry point
├── test/                    # Unit and widget tests
├── pubspec.yaml            # Dependencies and assets
└── README.md               # This file
```

## Development

### Adding a New Bot

1. Add the bot constants in [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart)
2. Add the bot color and icon in [lib/core/theme/app_theme.dart](lib/core/theme/app_theme.dart)
3. Add the bot button in [lib/features/home/presentation/pages/home_page.dart](lib/features/home/presentation/pages/home_page.dart)
4. Update n8n workflow to handle the new bot_id

### State Management

The app uses **Cubit** for state management:
- `AuthCubit` - Handles authentication state
- `ChatCubit` - Manages chat messages and API communication

## Troubleshooting

### Build Issues
- Run `flutter clean` and then `flutter pub get`
- Ensure you have the latest Flutter SDK

### Sign-In Issues
- Verify Google/Apple Sign-In configuration
- Check Firebase Console settings
- Ensure SHA-1 fingerprint is added (Android)

### Database Issues
- The database is automatically created on first launch
- To reset: Uninstall and reinstall the app

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Contact

For questions or support, please open an issue in the repository.
