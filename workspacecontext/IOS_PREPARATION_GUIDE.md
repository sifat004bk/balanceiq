# iOS Preparation & Deployment Guide

This guide outlines the steps to finalize the preparation of **Dolfin AI** for iOS deployment, addressing configuration, signing, and App Store requirements.

## 1. Firebase Configuration (Critical)
The automatic configuration was interrupted. You must manually add your iOS configuration file.
1.  Go to the **Firebase Console** for your project.
2.  Open **Project Settings**.
3.  Select your **iOS App** (Bundle ID: `com.dolfinmind.balanceiq`).
    *   **Note**: Your Android ID remains `com.dolfinmind.balance_iq` (with underscore). It is normal for them to differ slightly if needed for store compliance.
4.  Download **`GoogleService-Info.plist`**.
5.  **Move the file** into `apps/dolfin_ai/ios/Runner` directory.
6.  **Open Xcode**: Open `apps/dolfin_ai/ios/Runner.xcworkspace`.
7.  **Add File**: Drag `GoogleService-Info.plist` into the `Runner` folder in the Xcode project navigator. Ensure "Copy items if needed" is unchecked (since it's already there) or checked if dragging from Downloads. **Important**: Add it to the "Runner" target.

## 2. Privacy Manifest (iOS 17+)
A `PrivacyInfo.xcprivacy` file has been created at `apps/dolfin_ai/ios/Runner/PrivacyInfo.xcprivacy`.
1.  **In Xcode**, right-click the `Runner` folder in the Project Navigator.
2.  Select **"Add Files to 'Runner'..."**.
3.  Select `PrivacyInfo.xcprivacy`.
4.  Ensure **"Runner"** target is checked.
5.  Click **Add**.

## 3. Review `Info.plist`
The `Info.plist` has been pre-configured with:
-   **Permissions**: Camera, Photo Library, Microphone.
-   **URL Schemes**: Google Sign In.
-   **Display Name**: Dolfin AI.

## 4. Signing & Capabilities
1.  In Xcode, select the **Runner** project (top left).
2.  Select the **Runner** target.
3.  Go to the **Signing & Capabilities** tab.
4.  Ensure **Automatically manage signing** is checked.
5.  **Select Team**:
    *   **How to "Create" a Team**: You don't need to register on a website for a free team.
    *   In Xcode, go to **Settings** (or Preferences) > **Accounts**.
    *   Click the **+** button and choose **Apple ID**.
    *   Sign in with your regular Apple credentials.
    *   Once signed in, a **"Personal Team"** (e.g., `Your Name (Personal Team)`) is automatically created for you.
    *   Close Settings, go back to the **Signing & Capabilities** tab, and select this team from the dropdown.
    *   *Note: Personal teams allow you to test on your device for 7 days before needing to rebuild.*
6.  Verify **Bundle Identifier** is `com.dolfinmind.balanceiq`.

## 5. Build & Run
After completing the above steps, perform a clean build:

```bash
cd apps/dolfin_ai
flutter clean
flutter pub get
cd ios
pod install --repo-update
cd ..
flutter run
```

## 6. App Store Submission
When ready to submit:
1.  Product > **Archive** in Xcode.
2.  Validate and **Distribute App** to App Store Connect.
3.  Ensure you have set up the app record in App Store Connect with the matching Bundle ID.
