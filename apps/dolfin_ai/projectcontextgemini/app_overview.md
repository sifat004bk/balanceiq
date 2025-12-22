# BalanceIQ - App Overview

## App Flow

The application flow starts with onboarding for new users, leading to sign-up or sign-in. Once authenticated, the user lands on the home/dashboard screen, which displays financial summaries. The core feature is the chat screen, where users interact with the BalanceIQ AI bot.

## Architecture

The app is built using a **Clean Architecture** approach, separating the code into three main layers:

-   **Presentation Layer**: Contains the UI (pages, widgets) and state management (Cubit).
-   **Domain Layer**: Includes business logic (use cases, entities) and repository interfaces.
-   **Data Layer**: Implements the repositories and manages data sources (local SQLite database, remote n8n API, Firebase Auth).

## Data Flow

User input from the chat interface is handled by the `ChatCubit`. The message is saved to the local SQLite database and sent to the n8n webhook for AI processing. The n8n workflow parses the message, categorizes it, and can update the database. The response from n8n is then displayed in the chat UI, and the dashboard is refreshed.

## Database Schema

The app uses an SQLite database with two main tables:

-   **users**: Stores user information (ID, email, name, auth provider).
-   **messages**: Stores chat messages (ID, bot_id, sender, content, timestamp, etc.).

## n8n Integration

The app integrates with an n8n workflow for AI-powered responses. The chat screen sends a POST request to the n8n webhook with the user's message and other details. The n8n workflow processes the request and returns a structured response.
