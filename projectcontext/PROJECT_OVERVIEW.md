# BalanceIQ - Project Overview

## What is BalanceIQ?

BalanceIQ is an AI-powered personal finance management app designed for the Bangladesh market. It helps users track expenses, manage budgets, and gain financial insights through an intelligent chatbot assistant.

**Target Market**: Bangladesh (future expansion to South Asia)
**Business Model**: Freemium (600 BDT/month premium)
**Stage**: Beta development (65% complete)

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
N8N_CHAT_HISTORY_URL=https://your-n8n-instance.com/webhook/get-user-chat-history
BACKEND_BASE_URL=https://your-backend.com
```

## Current Implementation Status

### ✅ Implemented (65%)
- Authentication (Google, Apple, Email/Password + Backend APIs)
  - 6 backend auth endpoints (signup, login, profile, password management)
  - JWT token-based authentication
  - Session persistence
- Dashboard with 8+ financial metrics
- AI chat interface (text, image, audio)
  - Chat history API with pagination
- SQLite local storage
- Dark/Light themes
- n8n webhook integration (3 endpoints)
- Clean architecture structure
- Comprehensive integration test suite (22 tests)

### ❌ Not Implemented (35%)
- **UI/API Synchronization** (Critical - in progress)
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

## Documentation Directory - Quick Reference

### 📂 Core Documentation (Root Level)
Located in `projectcontext/`

| File | What You'll Find | When to Use |
|------|------------------|-------------|
| **PROJECT_OVERVIEW.md** | High-level project summary, tech stack, features, current status | Starting point for new developers |
| **README.md** | Navigation guide to all docs, quick start instructions | First file to read |
| **ARCHITECTURE.md** | Clean architecture layers, folder structure, design patterns | Understanding code organization |
| **DEVELOPMENT_GUIDE.md** | How to add features, coding standards, best practices | Before writing new code |
| **API_INTEGRATION.md** | n8n webhooks, API endpoints, request/response formats | Working with backend APIs |
| **IMPLEMENTATION_STATUS.md** | Completion percentage, what's done, what's missing | Checking project progress |
| **ROADMAP.md** | Development phases, priorities, timeline | Planning next steps |
| **TASKS.md** | Actionable task list with priorities | Daily development tasks |

### 📂 Specialized Directories

#### `design_docs/` - UI/UX Design Specifications
UI design guidelines and Gemini-inspired design system.

| File | Contents | Use Case |
|------|----------|----------|
| **GEMINI_UI_DESIGN_SPECIFICATIONS.md** | Complete design system (colors, typography, components) | Implementing UI components |
| **GEMINI_IMPLEMENTATION_CHECKLIST.md** | Phase-by-phase UI implementation tasks | Tracking UI development |
| **GEMINI_QUICK_REFERENCE.md** | Color palette, typography scale, code snippets | Quick design reference |
| **README_GEMINI_UI.md** | Getting started with Gemini UI | UI setup and overview |
| **gemini_observes.md** | Design decisions and lessons learned | Understanding design choices |

**Design Assets**: Located in `design_files/` with mockups for:
- `chat_interface/` - Chat screens, attachment modals, settings
- `dashboard/` - Dashboard layouts
- `onboarding/` - Login, register, email verification, welcome
- `profile/` - Profile, settings, subscription management
- `subscription/` - Payment and subscription screens

#### `implementation/` - Backend Integration & Analysis
API implementation details and UI synchronization status.

| File | Contents | Use Case |
|------|----------|----------|
| **API_IMPLEMENTATION_SUMMARY.md** | All 7 backend endpoints (auth + chat), tests, architecture | Understanding backend APIs |
| **UI_LAYER_EVALUATION.md** | 🔴 Critical: Gap analysis between UI and backend APIs | Fixing UI/API synchronization |
| **README.md** | Implementation docs overview | Navigating implementation docs |

#### `progress/` - Development Tracking
Weekly progress reports and status updates.

| File | Contents | Use Case |
|------|----------|----------|
| **progress.md** | Weekly sprint updates, completed tasks, blockers | Checking latest progress |
| **UI_UPDATE_REPORT.md** | UI/UX changes, design updates, improvements | Reviewing UI changes |
| **README.md** | Progress tracking guide | Understanding progress docs |

#### `project_summary/` - Comprehensive Project Documentation
Detailed business, product, and technical documentation.

**Business** (`project_summary/business/`)
- `bangladesh_strategy/` - Market strategy, revenue model, user acquisition
  - `bangladesh_strategy_summary.md` - Complete Bangladesh market strategy
  - `01_core_business_idea.md` - Business concept and differentiators
  - `02_revenue_model.md` - Pricing and monetization
  - `03_user_acquisition_strategy.md` - Marketing and growth tactics
  - `04_critical_recommendations.md` - Key action items
  - `05_fundraising.md` - Funding strategy
- `international_strategy/` - Global expansion plans

**Product** (`project_summary/product/`)
- `product.md` - Product specifications and requirements
- `features.md` - Detailed feature breakdown
- `ux.md` - UX principles and guidelines
- `ux_evaluation_report.md` - UX audit and recommendations

**Project** (`project_summary/project/`)
- `roadmap.md` - Detailed development roadmap
- `tasks.md` - Task breakdown and planning

**Tech** (`project_summary/tech/`)
- `app.md` - Flutter app architecture and implementation
- `backend.md` - Backend API documentation
- `n8n.md` - n8n workflow integration
- `qa.md` - Testing strategy and quality assurance
- `MOCK_ENVIRONMENT_GUIDE.md` - 🎭 Local development without backend (mock mode)
- `Business.postman_collection.json` - 📮 Complete API testing collection

### 🔍 Where to Find What

**Need to know...**
- **"What is this project?"** → `PROJECT_OVERVIEW.md`
- **"How is code organized?"** → `ARCHITECTURE.md`
- **"How do I add a feature?"** → `DEVELOPMENT_GUIDE.md`
- **"What APIs are available?"** → `API_INTEGRATION.md` + `implementation/API_IMPLEMENTATION_SUMMARY.md`
- **"How to test APIs?"** → `project_summary/tech/Business.postman_collection.json` 📮
- **"How to develop without backend?"** → `project_summary/tech/MOCK_ENVIRONMENT_GUIDE.md` 🎭
- **"What's the current status?"** → `IMPLEMENTATION_STATUS.md` + `progress/progress.md`
- **"What needs to be built?"** → `TASKS.md` + `ROADMAP.md`
- **"How should UI look?"** → `design_docs/GEMINI_UI_DESIGN_SPECIFICATIONS.md`
- **"Why UI not working with APIs?"** → `implementation/UI_LAYER_EVALUATION.md` 🔴
- **"Business strategy for Bangladesh?"** → `project_summary/business/bangladesh_strategy/bangladesh_strategy_summary.md`
- **"What are the features?"** → `project_summary/product/features.md`
- **"Latest progress?"** → `progress/progress.md`

### 📊 Documentation Map by Role

**For New Developers:**
1. `README.md` - Start here
2. `PROJECT_OVERVIEW.md` - Understand the project
3. `ARCHITECTURE.md` - Learn the code structure
4. `DEVELOPMENT_GUIDE.md` - Start coding

**For UI/UX Developers:**
1. `design_docs/README_GEMINI_UI.md` - Design system intro
2. `design_docs/GEMINI_UI_DESIGN_SPECIFICATIONS.md` - Complete specs
3. `design_files/` - Visual mockups
4. `project_summary/product/ux_evaluation_report.md` - UX improvements

**For Backend Developers:**
1. `API_INTEGRATION.md` - API overview
2. `implementation/API_IMPLEMENTATION_SUMMARY.md` - Detailed endpoints
3. `project_summary/tech/backend.md` - Backend architecture
4. `project_summary/tech/n8n.md` - Workflow integration
5. `project_summary/tech/Business.postman_collection.json` - 📮 API testing collection
6. `project_summary/tech/MOCK_ENVIRONMENT_GUIDE.md` - 🎭 Mock development setup

**For Product Managers:**
1. `PROJECT_OVERVIEW.md` - Product summary
2. `IMPLEMENTATION_STATUS.md` - Current status
3. `ROADMAP.md` - Timeline and priorities
4. `project_summary/business/bangladesh_strategy/` - Business strategy
5. `project_summary/product/` - Product specs

**For QA/Testers:**
1. `IMPLEMENTATION_STATUS.md` - What's implemented
2. `project_summary/tech/qa.md` - Testing strategy
3. `project_summary/tech/MOCK_ENVIRONMENT_GUIDE.md` - 🎭 Local testing setup (offline mode)
4. `project_summary/tech/Business.postman_collection.json` - 📮 API endpoint testing

---

---

## Recent Updates (2025-11-22)

**Backend API Integration Completed:**
- Implemented complete authentication backend layer
- Added chat history pagination support
- Created comprehensive test suite with 22 integration tests
- Organized project documentation structure

**Critical Next Step:**
- UI layer synchronization with backend APIs (see [implementation/UI_LAYER_EVALUATION.md](implementation/UI_LAYER_EVALUATION.md))

---

**Last Updated**: 2025-11-22