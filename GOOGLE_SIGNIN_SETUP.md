# Google Sign-In Setup Guide

The Google Sign-In error you're seeing is **expected** because Firebase needs to be configured. Follow these steps:

## Quick Fix (5 minutes)

### Step 1: Get SHA-1 Fingerprint

```bash
# For debug builds
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1
```

Copy the SHA-1 fingerprint (looks like: `AB:CD:EF:12:34...`)

### Step 2: Firebase Console Setup

1. Go to https://console.firebase.google.com/
2. Click **Add Project** or select existing project
3. Enter project name: **BalanceIQ** (or any name)
4. Click **Continue** → **Continue** → **Create Project**

### Step 3: Add Android App

1. In Firebase Console, click ⚙️ (Settings) → **Project Settings**
2. Click **Add App** → Select **Android**
3. Enter details:
   - **Package name:** `com.balanceiq.balance_iq`
   - **App nickname:** BalanceIQ (optional)
   - **SHA-1:** Paste your SHA-1 from Step 1
4. Click **Register App**

### Step 4: Download google-services.json

1. Click **Download google-services.json**
2. Move it to your project:
   ```bash
   mv ~/Downloads/google-services.json android/app/
   ```

### Step 5: Enable Google Sign-In

1. In Firebase Console, go to **Authentication** (left sidebar)
2. Click **Get Started**
3. Click **Sign-in method** tab
4. Click **Google** → **Enable** → **Save**

### Step 6: Add Google Services Plugin

Edit `android/build.gradle.kts` and add:

```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.0" apply false
}
```

Edit `android/app/build.gradle.kts` and add at the **bottom**:

```kotlin
apply(plugin = "com.google.gms.google-services")
```

### Step 7: Rebuild and Run

```bash
# Stop the current app (press 'q' in terminal)
# Then run again
flutter run -d pixel
```

## The Error You're Seeing

**PlatformException: sign_in_failed**

This happens because:
- ❌ No `google-services.json` file
- ❌ No SHA-1 registered in Firebase
- ❌ Google Sign-In not enabled in Firebase

After completing the above steps, Google Sign-In will work!

## Alternative: Skip Authentication for Testing

If you want to test the app without auth, you can bypass the onboarding screen:

Edit `lib/main.dart`:

```dart
home: const HomePage(), // Skip onboarding
// home: const OnboardingPage(), // Original
```

Then you can explore all 4 bots and the chat interface without signing in.

## Verification

After setup, you should see:
1. ✅ Google account picker appears
2. ✅ Can select account
3. ✅ Returns to app
4. ✅ Shows home screen with 4 bots

---

**Need help?** The complete guide is in [README.md](README.md) under "Configure Google Sign-In"
