# BalanceIQ

**BalanceIQ** is an AI-powered personal finance chatbot application built with Flutter. It helps users manage their finances through an intuitive chat interface with a specialized financial bot.

## Key Features

- **Balance Tracker Bot**: Monitor expenses and track spending patterns.
- **Rich Media Support**: Text, image, and audio messages.
- **Persistent History**: Chat history stored in a local SQLite database.
- **Secure Authentication**: Google and Apple sign-in.
- **User-Friendly Interface**: Includes dark mode support.
- **AI-Powered Responses**: Integrated with an n8n workflow for intelligent replies.
- **Clean Architecture**: Follows clean architecture principles with Cubit for state management.

## Tech Stack

- **Framework**: Flutter
- **State Management**: Cubit (flutter_bloc)
- **Database**: SQLite
- **Dependency Injection**: GetIt
- **HTTP Client**: Dio
- **AI Workflow**: n8n

## Getting Started

1.  **Prerequisites**: Flutter SDK (3.27.0), FVM, and an n8n workflow instance.
2.  **Clone & Install**:
    ```bash
    git clone <repository-url>
    cd balanceIQ
    fvm install 3.27.0
    fvm use 3.27.0
    fvm flutter pub get
    ```
3.  **Configure**: Set up Firebase for Google Sign-In and configure the n8n webhook URL.

For detailed setup and troubleshooting, refer to the `development_guide.md`.
