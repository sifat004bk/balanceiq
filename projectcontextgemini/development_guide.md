# BalanceIQ - Development Guide

## Getting Started

### Prerequisites

-   **Flutter SDK**: Version 3.27.0 (managed via FVM)
-   **FVM**: Flutter Version Management tool.
-   **n8n Workflow**: An active n8n instance for AI responses.
-   **Firebase Project**: A Firebase project for authentication.

### Installation

1.  **Clone the Repository**:
    ```bash
    git clone <repository-url>
    cd balanceIQ
    ```

2.  **Setup FVM and Flutter Version**:
    ```bash
    fvm install 3.27.0
    fvm use 3.27.0
    ```

3.  **Install Dependencies**:
    ```bash
    fvm flutter pub get
    ```

### Configuration

#### Firebase (Google Sign-In)

1.  **Get SHA-1 Fingerprint**:
    ```bash
    keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
    ```

2.  **Add to Firebase**: Add the SHA-1 fingerprint to your Firebase project settings for the Android app.

#### n8n Webhook

Set the n8n webhook URL using a Dart define:

```bash
fvm flutter run --dart-define=N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook
```

## Running the App

-   **Run in Debug Mode**:
    ```bash
    fvm flutter run
    ```

-   **Build for Release**:
    -   Android: `fvm flutter build apk --release`
    -   iOS: `fvm flutter build ios --release`

## Common Development Tasks

### Adding a New Bot

*The current architecture is designed for a single bot. To add more bots, you would need to:*

1.  Update `lib/core/constants/app_constants.dart` with new bot IDs.
2.  Modify the UI in `lib/features/home/presentation/pages/home_page.dart` to allow bot selection.
3.  Update the `ChatCubit` to handle different bots.
4.  Extend the n8n workflow to process requests for different bots.

### Modifying the Database

1.  The database schema is defined in the data layer.
2.  Use a database migration strategy if you need to alter tables in a production app. For development, you can often uninstall and reinstall the app to clear the database.

### Code Style and Analysis

This project uses the analysis options defined in `analysis_options.yaml`. To check your code, run:

```bash
fvm flutter analyze
```
