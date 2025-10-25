# Next Steps - BalanceIQ Setup Guide

This checklist will help you get BalanceIQ running on your device.

## ✅ Completed

- [x] Flutter project created with clean architecture
- [x] All dependencies configured
- [x] Domain, Data, and Presentation layers implemented
- [x] Four bots implemented (Balance Tracker, Investment Guru, Budget Planner, Fin Tips)
- [x] Authentication setup (Google & Apple)
- [x] Chat interface with text, image, and audio
- [x] Local SQLite database
- [x] n8n workflow integration
- [x] Dark mode support
- [x] Android and iOS permissions configured
- [x] Code analysis (0 issues)
- [x] Git repository initialized
- [x] All code committed and pushed to GitHub
- [x] Comprehensive documentation created

## 📋 TODO - Before Running

### 1. Set Up n8n Workflow (Required)

- [ ] Deploy your n8n instance (cloud or self-hosted)
- [ ] Import the sample workflow from `n8n_workflow_sample.json`
- [ ] Activate the webhook
- [ ] Get your webhook URL
- [ ] Test the webhook with Postman/curl

**Webhook URL format:**
```
https://your-n8n-instance.com/webhook/balance-iq
```

### 2. Configure App with Webhook URL (Required)

Choose one method:

**Option A: Using .env file (Recommended)**
```bash
cp .env.example .env
# Edit .env and add your webhook URL
./run_app.sh
```

**Option B: Command line**
```bash
flutter run --dart-define=N8N_WEBHOOK_URL=https://your-webhook-url.com
```

**Option C: Edit constants**
Edit `lib/core/constants/app_constants.dart` line 30

### 3. Set Up Authentication (Required for Production)

#### Google Sign-In

**Android:**
- [ ] Create Firebase project at https://console.firebase.google.com/
- [ ] Add Android app to Firebase
- [ ] Get SHA-1 fingerprint:
  ```bash
  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
  ```
- [ ] Add SHA-1 to Firebase Console
- [ ] Download `google-services.json`
- [ ] Place in `android/app/google-services.json`
- [ ] Update `android/build.gradle` with:
  ```gradle
  dependencies {
      classpath 'com.google.gms:google-services:4.3.15'
  }
  ```
- [ ] Add to `android/app/build.gradle`:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

**iOS:**
- [ ] Add iOS app to Firebase
- [ ] Download `GoogleService-Info.plist`
- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Add `GoogleService-Info.plist` to project
- [ ] Update URL schemes in Info.plist

#### Apple Sign-In (iOS only)

- [ ] Open `ios/Runner.xcworkspace` in Xcode
- [ ] Select Runner target
- [ ] Go to Signing & Capabilities
- [ ] Click + Capability
- [ ] Add "Sign in with Apple"
- [ ] Sign with your Apple Developer account

### 4. First Run

- [ ] Run `flutter doctor` to check setup
- [ ] Run `flutter pub get` to install dependencies
- [ ] Connect device or start emulator
- [ ] Run the app:
  ```bash
  ./run_app.sh
  # or
  flutter run
  ```

### 5. Test Core Features

- [ ] App launches successfully
- [ ] Onboarding screen appears
- [ ] Sign in with Google works
- [ ] Sign in with Apple works (iOS)
- [ ] Home screen shows 4 bots
- [ ] Can open each bot's chat
- [ ] Can send text messages
- [ ] Messages sent to n8n
- [ ] Bot responses appear
- [ ] Messages persist in database
- [ ] Can take/select photos
- [ ] Can record audio
- [ ] Dark mode switches correctly

## 🔧 Optional Customizations

### Branding
- [ ] Update app name in `lib/core/constants/app_constants.dart`
- [ ] Replace app icons (see DEVELOPMENT.md)
- [ ] Update colors in `lib/core/theme/app_theme.dart`
- [ ] Add custom fonts (see DEVELOPMENT.md)

### Features
- [ ] Customize bot personalities
- [ ] Modify welcome messages
- [ ] Add more bots (see DEVELOPMENT.md)
- [ ] Implement push notifications
- [ ] Add chat export feature

### Production
- [ ] Update package name
- [ ] Configure production webhook URL
- [ ] Set up release signing
- [ ] Build APK/IPA
- [ ] Deploy to Play Store/App Store

## 📚 Resources

### Documentation
- [README.md](README.md) - Full documentation
- [QUICKSTART.md](QUICKSTART.md) - 5-minute setup
- [DEVELOPMENT.md](DEVELOPMENT.md) - Developer guide
- [TESTING.md](TESTING.md) - Testing checklist
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Project overview

### Helpful Links
- Flutter Setup: https://docs.flutter.dev/get-started/install
- Firebase Console: https://console.firebase.google.com/
- n8n Documentation: https://docs.n8n.io/
- Clean Architecture: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

## ⚡ Quick Commands

```bash
# Check Flutter setup
flutter doctor

# Install dependencies
flutter pub get

# Run code analysis
flutter analyze

# Format code
flutter format lib/

# Run on device
flutter run

# Build Android APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Clean build
flutter clean
```

## 🐛 Troubleshooting

### "Command not found: flutter"
- Install Flutter SDK from https://docs.flutter.dev/get-started/install

### "Failed to connect to n8n"
- Check webhook URL is correct
- Ensure n8n workflow is active
- Test with curl:
  ```bash
  curl -X POST https://your-webhook-url.com \
    -H "Content-Type: application/json" \
    -d '{"bot_id":"balance_tracker","message":"test"}'
  ```

### "Google Sign-In failed"
- Verify SHA-1 added to Firebase
- Check `google-services.json` location
- Rebuild app after adding config

### "Build failed"
- Run `flutter clean`
- Run `flutter pub get`
- Check `flutter doctor`

### Android License Issues
```bash
flutter doctor --android-licenses
```

## 📞 Support

If you encounter issues:
1. Check the documentation files
2. Review error messages carefully
3. Search existing GitHub issues
4. Create new issue with details

## 🎉 Ready to Go!

Once you've completed the required steps above, your BalanceIQ app will be fully functional and ready for development or deployment.

**Minimum viable setup (Development):**
1. Configure n8n webhook URL ✅
2. Run `flutter pub get` ✅
3. Run `./run_app.sh` or `flutter run` ✅

**Production ready setup:**
1. All of the above ✅
2. Configure authentication ✅
3. Test all features ✅
4. Customize branding ✅
5. Build release version ✅

Good luck with your BalanceIQ app! 🚀

---

**Need help?** Check the documentation or open an issue on GitHub.
