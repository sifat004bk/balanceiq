# BalanceIQ Quick Start Guide

This guide will help you get the BalanceIQ app running on your device in minutes.

## Prerequisites

- Flutter SDK 3.8.0+ installed
- Xcode (for iOS) or Android Studio (for Android)
- An n8n workflow instance with a webhook

## 5-Minute Setup

### Step 1: Install Dependencies

```bash
flutter pub get
```

### Step 2: Configure n8n Webhook

Choose one of these methods:

**Method A: Using the run script (Recommended)**

1. Copy the environment template:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and add your n8n webhook URL:
   ```
   N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/balance-iq
   ```

3. Run the app:
   ```bash
   ./run_app.sh
   ```

**Method B: Direct command**

```bash
flutter run --dart-define=N8N_WEBHOOK_URL=https://your-n8n-webhook-url.com
```

**Method C: Edit constants file**

Edit `lib/core/constants/app_constants.dart`:
```dart
static const String n8nWebhookUrl = 'https://your-webhook-url.com';
```

Then run:
```bash
flutter run
```

### Step 3: Set Up Authentication (Required for production)

#### Google Sign-In

1. **Create Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use existing one

2. **For Android:**
   - Get your SHA-1 fingerprint:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
   - Add SHA-1 to Firebase Console
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`

3. **For iOS:**
   - Download `GoogleService-Info.plist`
   - Add it to your Xcode project

#### Apple Sign-In (iOS only)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to "Signing & Capabilities"
4. Click "+ Capability"
5. Add "Sign in with Apple"

## Running Without Authentication (Development Only)

For quick testing without setting up authentication, you can comment out the authentication check in the onboarding screen, but this is **not recommended for production**.

## Testing the App

### Expected n8n Webhook Request Format

```json
{
  "bot_id": "balance_tracker",
  "message": "How much did I spend on groceries?",
  "timestamp": "2025-10-25T12:00:00Z",
  "image": "base64_encoded_image_data (optional)",
  "audio": "base64_encoded_audio_data (optional)"
}
```

### Expected n8n Webhook Response Format

```json
{
  "id": "msg_12345",
  "message": "You spent $250 on groceries this month.",
  "image_url": "https://example.com/chart.png (optional)",
  "audio_url": "https://example.com/response.mp3 (optional)"
}
```

## Troubleshooting

### "Failed to connect to n8n"
- Check your webhook URL is correct
- Ensure n8n workflow is active
- Test the webhook with Postman/curl

### "Google Sign-In failed"
- Verify SHA-1 fingerprint is added to Firebase
- Check `google-services.json` is in the correct location
- Ensure package name matches Firebase configuration

### "Build failed"
- Run `flutter clean`
- Run `flutter pub get`
- Try `flutter doctor` to check setup

### Android License Issues
```bash
flutter doctor --android-licenses
```

## Development Workflow

1. **Start n8n workflow** - Make sure it's running and accessible
2. **Run the app** - Use `./run_app.sh` or `flutter run`
3. **Test a bot** - Select a bot and send a message
4. **Check responses** - Verify bot responses appear correctly

## Building for Production

### Android APK
```bash
flutter build apk --release --dart-define=N8N_WEBHOOK_URL=https://your-production-webhook.com
```

### iOS App
```bash
flutter build ios --release --dart-define=N8N_WEBHOOK_URL=https://your-production-webhook.com
```

## Project Structure

```
lib/
├── core/               # Core functionality
│   ├── constants/     # App configuration
│   ├── database/      # SQLite database
│   ├── di/            # Dependency injection
│   └── theme/         # App theming
└── features/          # Feature modules
    ├── auth/          # Authentication
    ├── chat/          # Chat functionality
    └── home/          # Home screen
```

## Next Steps

- Set up your n8n workflow to handle bot requests
- Configure authentication for production
- Customize bot personalities and responses
- Add more features as needed

## Support

For issues or questions:
- Check the [main README](README.md) for detailed documentation
- Review the [n8n Workflow Configuration](README.md#n8n-workflow-configuration) section
- Open an issue on GitHub

---

Happy coding! 🚀
