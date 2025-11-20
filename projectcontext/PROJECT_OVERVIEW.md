# BalanceIQ - Project Overview

## What is BalanceIQ?

BalanceIQ is an AI-powered personal finance management app designed for the Bangladesh market. It helps users track expenses, manage budgets, and gain financial insights through an intelligent chatbot assistant.

**Target Market**: Bangladesh (future expansion to South Asia)
**Business Model**: Freemium (600 BDT/month premium)
**Stage**: Beta development (60% complete)

## Core Value Proposition

Unlike complex expense trackers, BalanceIQ makes finance management **conversational**:
- "I spent 500 taka on lunch" → Automatically tracked and categorized
- Take a photo of receipt → AI extracts amount and category
- Voice message "কত টাকা খরচ হয়েছে?" → Get instant insights

## Key Features

### 1. Financial Dashboard
Real-time overview of financial health:
- Net balance, income vs. expenses
- Spending trends (30-day chart)
- Financial ratios (savings rate, expense ratio)
- Account breakdown (cash, bank, credit card)
- Category-wise spending
- Biggest expenses at a glance

### 2. AI Chat Assistant
Single intelligent assistant for all financial queries:
- **Text**: Natural language expense tracking
- **Images**: Receipt scanning with OCR
- **Voice**: Audio message support
- **Smart**: Auto-categorization, insights, recommendations

### 3. Authentication
Multiple sign-in options:
- Email/Password (with verification)
- Google Sign-In
- Apple Sign-In (iOS)
- Forgot password flow

### 4. Data Persistence
- Local SQLite database for chat history
- Offline access to dashboard and messages
- Syncs with backend for AI processing

## Technology Stack

### Frontend
```
Framework:      Flutter 3.27.0
Language:       Dart 3.6.0
State Mgmt:     Cubit (flutter_bloc 8.1.6)
Architecture:   Clean Architecture
```

### Key Dependencies
```
dio:                     5.7.0      # HTTP client
sqflite:                 2.3.3      # Local database
google_sign_in:          6.2.2      # Google OAuth
sign_in_with_apple:      6.1.3      # Apple OAuth
get_it:                  8.0.2      # Dependency injection
image_picker:            1.1.2      # Camera/gallery
record:                  6.1.2      # Audio recording
flutter_markdown:        0.7.4      # Render AI responses
fl_chart:                0.69.2     # Spending charts
```

### Backend
```
AI Processing:  n8n workflows
Database:       PostgreSQL (backend)
Local DB:       SQLite
APIs:           RESTful webhooks
```

## Project Structure

```
balanceIQ/
├── lib/
│   ├── core/                    # Shared infrastructure
│   │   ├── constants/          # App-wide constants
│   │   ├── database/           # SQLite setup
│   │   ├── di/                 # Dependency injection
│   │   ├── theme/              # App themes
│   │   └── error/              # Error handling
│   │
│   └── features/               # Feature modules
│       ├── auth/               # Authentication
│       │   ├── data/          # API & DB implementations
│       │   ├── domain/        # Business logic
│       │   └── presentation/  # UI & state management
│       │
│       ├── home/              # Dashboard
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       │
│       └── chat/              # AI Assistant
│           ├── data/
│           ├── domain/
│           └── presentation/
│
├── android/                    # Android native code
├── ios/                        # iOS native code
├── .env                        # Environment variables
└── pubspec.yaml               # Dependencies
```

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  photo_url TEXT,
  auth_provider TEXT NOT NULL,  -- 'google', 'apple', 'email'
  created_at TEXT NOT NULL
);
```

### Messages Table
```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  bot_id TEXT NOT NULL,           -- 'balance_tracker'
  sender TEXT NOT NULL,           -- 'user' or 'bot'
  content TEXT NOT NULL,
  image_url TEXT,
  audio_url TEXT,
  timestamp TEXT NOT NULL,
  is_sending INTEGER DEFAULT 0,
  has_error INTEGER DEFAULT 0
);

CREATE INDEX idx_messages_bot_timestamp ON messages(bot_id, timestamp);
```

## Architecture Principles

### Clean Architecture
```
┌─────────────────────────┐
│   Presentation Layer    │  ← UI, Widgets, Cubits
├─────────────────────────┤
│   Domain Layer          │  ← Business Logic, Entities
├─────────────────────────┤
│   Data Layer            │  ← API, Database, Models
└─────────────────────────┘
```

**Benefits**:
- Testable business logic
- Independent of UI and frameworks
- Easy to maintain and extend

### State Management (Cubit)
```dart
// Simple state management without events
class ChatCubit extends Cubit<ChatState> {
  void loadMessages(String botId) async {
    emit(ChatLoading());
    final result = await getMessages(botId);
    emit(ChatLoaded(messages: result));
  }
}
```

## API Integration

### Chat Endpoint
```
POST {N8N_WEBHOOK_URL}

Request:
{
  "user_id": "123",
  "bot_id": "balance_tracker",
  "content": "I spent 500 taka on lunch",
  "image_base64": "..." // optional
}

Response:
{
  "id": "msg_456",
  "message": "Added 500 BDT lunch expense!",
  "category": "Food & Dining"
}
```

### Dashboard Endpoint
```
POST {N8N_DASHBOARD_URL}

Request:
{
  "user_id": "123",
  "bot_id": "balance_tracker"
}

Response:
{
  "data": [{
    "total_balance": 5000,
    "total_income": 8000,
    "total_expenses": 3000,
    "spending_trend": [...],
    "categories": {...}
  }]
}
```

## Key Design Patterns

### 1. Dependency Injection (GetIt)
```dart
// Registration in injection_container.dart
sl.registerFactory(() => ChatCubit(
  getMessages: sl(),
  sendMessage: sl(),
));

// Usage
final cubit = sl<ChatCubit>();
```

### 2. Repository Pattern
```dart
abstract class ChatRepository {
  Future<Either<Failure, List<Message>>> getMessages(String botId);
  Future<Either<Failure, Message>> sendMessage(Message message);
}
```

### 3. Use Case Pattern
```dart
class SendMessage {
  final ChatRepository repository;

  Future<Either<Failure, Message>> call(Message message) {
    return repository.sendMessage(message);
  }
}
```

## Development Environment

### Requirements
- Flutter SDK 3.27.0+
- Dart SDK 3.6.0+
- Android Studio / Xcode
- FVM (optional, for version management)

### Setup
```bash
# Install dependencies
flutter pub get

# Setup environment
cp .env.example .env
# Edit .env with your API URLs

# Run on device
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

### Environment Variables (.env)
```
N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/balance-iq
N8N_DASHBOARD_URL=https://your-n8n-instance.com/webhook-test/get-user-dashboard
```

## Current Implementation Status

### ✅ Implemented (60%)
- Authentication (Google, Apple, Email/Password)
- Dashboard with 8+ financial metrics
- AI chat interface (text, image, audio)
- SQLite local storage
- Dark/Light themes
- n8n webhook integration
- Clean architecture structure

### ❌ Not Implemented (40%)
- Bank integration
- Budget creation and tracking
- Bill reminders
- Investment tracking
- Bangla language support
- Subscription management
- Push notifications
- Cloud sync across devices

## Critical Next Steps

### Priority 0 (Launch Blockers)
1. **Bangla Language**: Translate UI and bot responses
2. **UX Fixes**: Improve onboarding, make chat discoverable
3. **Email Auth**: Complete forgot password flow
4. **Testing**: Comprehensive QA across devices

### Priority 1 (MVP Features)
1. **Budgets**: Create, track, and alert on budgets
2. **Categories**: Customizable expense categories
3. **Reports**: Monthly/yearly spending reports
4. **Recurring**: Handle recurring transactions

## Business Context

### Target Users
- Young professionals (25-35 years)
- Small business owners
- Freelancers
- Students with part-time income

### Pricing Strategy
- **Free Tier**: 50 transactions/month, basic insights
- **Premium**: 600 BDT/month unlimited transactions, advanced features
- **Target**: 10,000 users in Year 1, 30% conversion

### Market Position
Unlike bank apps (read-only) or complex trackers (steep learning curve), BalanceIQ is:
- Conversational and easy to use
- Designed for Bangladesh market
- Manual entry focused (no bank integration required)
- Bangla language support

## Success Metrics

### User Engagement
- Daily Active Users (DAU) / Monthly Active Users (MAU) ratio
- Messages per user per week
- Dashboard views per session

### Financial
- Free-to-paid conversion rate (target: 30%)
- Monthly Recurring Revenue (MRR)
- Customer Acquisition Cost (CAC)

### Product
- Time to first expense logged
- Expense tracking accuracy
- User retention (7-day, 30-day)

---

## Quick Links

- **Architecture Details**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Development Guide**: [DEVELOPMENT_GUIDE.md](DEVELOPMENT_GUIDE.md)
- **API Integration**: [API_INTEGRATION.md](API_INTEGRATION.md)
- **Implementation Status**: [IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md)
- **Roadmap**: [ROADMAP.md](ROADMAP.md)
- **Tasks**: [TASKS.md](TASKS.md)

---

**Last Updated**: 2025-11-21