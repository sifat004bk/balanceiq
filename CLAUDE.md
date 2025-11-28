# Claude Code - Project Instructions for BalanceIQ

## General Workflow Rules

- Always use your name as co-author in git commits
- Give git commits on small unit tasks with descriptive messages
- Always go through `projectcontext/` directory to get overall context before starting new tasks
- Always update relevant documentation files when any new task is done
- Keep documentation current and accurate

---

## Quick Start - Where to Find What

### Essential Documentation Paths

**Starting a New Task?**
1. Read `projectcontext/README.md` - Navigation guide
2. Check `projectcontext/PROJECT_OVERVIEW.md` - Complete project context
3. Review `projectcontext/IMPLEMENTATION_STATUS.md` - Current state

**Working on Specific Features?**
- **Authentication** → `projectcontext/implementation/API_IMPLEMENTATION_SUMMARY.md`
- **UI/UX Design** → `projectcontext/design_docs/GEMINI_UI_DESIGN_SPECIFICATIONS.md`
- **Backend APIs** → `projectcontext/API_INTEGRATION.md` + `projectcontext/project_summary/tech/backend.md`
- **Architecture** → `projectcontext/ARCHITECTURE.md`
- **Development Guide** → `projectcontext/DEVELOPMENT_GUIDE.md`

**Critical Information:**
- 🔴 **UI/API Sync Issues** → `projectcontext/implementation/UI_LAYER_EVALUATION.md`
- **Latest Progress** → `projectcontext/progress/progress.md`
- **Current Tasks** → `projectcontext/TASKS.md`
- **Roadmap** → `projectcontext/ROADMAP.md`

---

## Project Context at a Glance

### What is BalanceIQ?

AI-powered personal finance app for Bangladesh market built with Flutter.

**Key Info:**
- **Platform**: Flutter 3.27.0 (iOS & Android)
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **State Management**: Cubit (flutter_bloc)
- **Backend**: n8n workflows + PostgreSQL
- **Local DB**: SQLite
- **Stage**: Beta (65% complete)

### Core Features
1. **Financial Dashboard** - 8+ metrics, spending trends, account breakdown
2. **AI Chat Assistant** - Text, image (OCR), voice expense tracking
3. **Authentication** - Google, Apple, Email/Password (6 backend APIs)
4. **Data Persistence** - SQLite local storage with backend sync

### Tech Stack
```
Frontend:     Flutter 3.27.0, Dart 3.6.0, Cubit
Local DB:     SQLite (sqflite 2.3.3)
APIs:         Dio 5.7.0, n8n webhooks
Auth:         Google Sign-In, Apple Sign-In
DI:           GetIt 8.0.2
UI:           Material Design, fl_chart
```

---

## Code Structure Quick Reference

```
lib/
├── core/                     # Shared infrastructure
│   ├── constants/           # App constants (API_CONSTANTS, APP_CONSTANTS)
│   ├── database/            # SQLite helper
│   ├── di/                  # Dependency injection (GetIt)
│   ├── theme/               # App themes (dark/light)
│   └── error/               # Error handling
│
└── features/                # Feature modules (Clean Architecture)
    ├── auth/                # Authentication
    │   ├── data/           # Repositories, data sources, models
    │   ├── domain/         # Entities, use cases, repository interfaces
    │   └── presentation/   # UI, widgets, cubits, pages
    │
    ├── home/               # Dashboard
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    └── chat/               # AI Chat Assistant
        ├── data/
        ├── domain/
        └── presentation/
```

---

## Critical Implementation Status

### ✅ Completed (65%)
- ✅ Authentication (Google, Apple, Email/Password)
  - 6 backend auth endpoints fully implemented
  - JWT token-based authentication
  - Session persistence
  - 22 integration tests passing
- ✅ Dashboard with financial metrics
- ✅ AI chat interface (text, image, audio)
  - Chat history API with pagination
- ✅ SQLite local storage
- ✅ Dark/Light themes
- ✅ n8n webhook integration (3 endpoints)
- ✅ Clean architecture structure

### 🔴 Critical Issues (Must Fix)
- **UI/API Synchronization Gap**: UI layer not synced with new backend APIs
  - Details: `projectcontext/implementation/UI_LAYER_EVALUATION.md`
  - Impact: Auth flows using old mock/n8n APIs instead of new backend
  - Priority: P0 - Launch blocker

### ❌ Not Implemented (35%)
- Bank integration
- Budget creation and tracking
- Bill reminders
- Investment tracking
- Bangla language support
- Subscription management
- Push notifications
- Cloud sync across devices

---

## API Endpoints Reference

### Backend APIs (New - JWT Auth)
Located in: `lib/features/auth/data/datasources/auth_remote_data_source.dart`

```
POST /api/auth/signup              # Register new user
POST /api/auth/login               # Email/password login
GET  /api/auth/profile             # Get user profile
PUT  /api/auth/profile             # Update profile
POST /api/auth/forgot-password     # Request password reset
POST /api/auth/reset-password      # Reset password with OTP
GET  /api/chat/history             # Get chat history (pagination)
```

### n8n Webhooks (Legacy)
```
POST {N8N_WEBHOOK_URL}             # Send chat message
POST {N8N_DASHBOARD_URL}           # Get dashboard data
POST {N8N_CHAT_HISTORY_URL}        # Get chat history (old)
```

**Environment Variables** (`.env`):
```
BACKEND_BASE_URL=https://your-backend.com
N8N_WEBHOOK_URL=https://n8n-instance/webhook/balance-iq
N8N_DASHBOARD_URL=https://n8n-instance/webhook-test/get-user-dashboard
N8N_CHAT_HISTORY_URL=https://n8n-instance/webhook/get-user-chat-history
```

---

## Design System Reference

### Gemini-Inspired UI
**Design Specs**: `projectcontext/design_docs/GEMINI_UI_DESIGN_SPECIFICATIONS.md`

**Key Design Principles:**
- Clean, minimalist interface
- Smooth animations and transitions
- Google Material Design 3
- Consistent spacing and typography
- Dark/Light mode support

**Design Assets**: `projectcontext/design_files/`
- `chat_interface/` - Chat screens, modals
- `dashboard/` - Dashboard layouts
- `onboarding/` - Login, register, verification
- `profile/` - Settings, subscription
- `subscription/` - Payment screens

---

## Development Workflow

### Before Starting Any Task

1. **Check Current Status**
   ```bash
   # Read these files:
   - projectcontext/README.md
   - projectcontext/IMPLEMENTATION_STATUS.md
   - projectcontext/progress/progress.md
   ```

2. **Understand the Architecture**
   ```bash
   # For code changes, read:
   - projectcontext/ARCHITECTURE.md
   - projectcontext/DEVELOPMENT_GUIDE.md
   ```

3. **Check Related Documentation**
   - UI changes → `design_docs/`
   - API changes → `implementation/API_IMPLEMENTATION_SUMMARY.md`
   - Business context → `project_summary/business/`

### After Completing a Task

1. **Update Documentation**
   ```bash
   # Update relevant files:
   - projectcontext/IMPLEMENTATION_STATUS.md (if feature status changed)
   - projectcontext/progress/progress.md (log progress)
   - projectcontext/TASKS.md (mark tasks complete)
   ```

2. **Run Tests & Quality Checks**
   ```bash
   flutter test              # Run tests
   flutter analyze          # Check code quality
   ```

3. **Commit with Context**
   ```bash
   git add .
   git commit -m "feat: descriptive message

   Details of what was changed and why.

   🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

---

## Common Development Tasks

### Adding a New Feature

1. **Read**: `projectcontext/DEVELOPMENT_GUIDE.md`
2. **Follow Clean Architecture**:
   - Create entities in `domain/entities/`
   - Define use cases in `domain/usecases/`
   - Implement repository in `data/repositories/`
   - Add data sources in `data/datasources/`
   - Create models in `data/models/`
   - Build UI in `presentation/`
3. **Register dependencies** in `core/di/injection_container.dart`
4. **Add tests** for critical logic
5. **Update documentation** when done

### Modifying Existing Features

1. **Locate the feature** in `lib/features/[feature_name]/`
2. **Check architecture layer**:
   - UI change → `presentation/`
   - Business logic → `domain/`
   - API/DB → `data/`
3. **Follow existing patterns** (check similar implementations)
4. **Test changes** before committing
5. **Update docs** if behavior changed

### Fixing Bugs

1. **Reproduce** the issue
2. **Identify layer** where bug exists
3. **Check related tests** (if any)
4. **Fix and verify**
5. **Add test** to prevent regression
6. **Document** in progress notes

---

## Key Design Patterns Used

### 1. Clean Architecture
```
Presentation → Domain → Data
(UI/Cubit) → (UseCases) → (Repository/API)
```

### 2. Dependency Injection (GetIt)
```dart
// Register in injection_container.dart
sl.registerFactory(() => LoginCubit(login: sl()));

// Use anywhere
final cubit = sl<LoginCubit>();
```

### 3. Repository Pattern
```dart
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // Implementation...
}
```

### 4. Cubit State Management
```dart
class LoginCubit extends Cubit<LoginState> {
  final Login loginUseCase;

  void login(String email, String password) async {
    emit(LoginLoading());
    final result = await loginUseCase(email, password);
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
```

---

## Testing

**Test Files**: `test/`
**Integration Tests**: `test/features/auth/data/datasources/auth_remote_data_source_test.dart`

**Run Tests**:
```bash
flutter test                    # All tests
flutter test test/features/auth/  # Specific feature
```

**Current Coverage**:
- ✅ Auth backend APIs: 22 integration tests
- ❌ UI tests: Not yet implemented
- ❌ Widget tests: Minimal coverage

---

## Business Context (Quick Summary)

**Target Market**: Bangladesh
**Business Model**: Freemium (600 BDT/month premium)
**Target Users**: Urban professionals 25-40 years old

**Key Differentiators**:
- No bank integration (cash/mobile money focused)
- Bangla language support
- Conversational AI interface
- Multi-modal input (text, voice, image)

**Full Strategy**: `projectcontext/project_summary/business/bangladesh_strategy/`

---

## Documentation Update Protocol

### When to Update Docs

**After completing features:**
- ✅ Update `IMPLEMENTATION_STATUS.md` (change percentages, move items)
- ✅ Log in `progress/progress.md` (what was done, when)
- ✅ Check off tasks in `TASKS.md`

**After API changes:**
- ✅ Update `API_INTEGRATION.md`
- ✅ Update `implementation/API_IMPLEMENTATION_SUMMARY.md`

**After UI changes:**
- ✅ Update `design_docs/` if design system changed
- ✅ Log in `progress/UI_UPDATE_REPORT.md`

**After architecture changes:**
- ✅ Update `ARCHITECTURE.md`
- ✅ Update `DEVELOPMENT_GUIDE.md` if patterns changed

### Documentation Quality Standards

- Keep docs **concise** and **actionable**
- Use **real code examples** from codebase
- Update **dates** at bottom of files
- Use **tables** and **lists** for clarity
- Add **file paths** for easy navigation
- Include **quick reference** sections

---

## Project Priorities (Nov 2025)

### P0 - Critical (Launch Blockers)
1. 🔴 **Fix UI/API Synchronization** - Use backend APIs instead of n8n for auth
2. **Bangla Language Support** - Translate UI and bot responses
3. **Complete Email Auth Flow** - Forgot password implementation
4. **Comprehensive Testing** - QA across devices

### P1 - High Priority (MVP Features)
1. **Budget Management** - Create, track, alert
2. **Custom Categories** - User-defined expense categories
3. **Reports** - Monthly/yearly spending reports
4. **Recurring Transactions** - Handle subscriptions, bills

### P2 - Medium Priority (Post-MVP)
1. Bank integration
2. Investment tracking
3. Cloud sync
4. Push notifications

**Full Roadmap**: `projectcontext/ROADMAP.md`

---

## Quick Commands

```bash
# Setup
flutter pub get
cp .env.example .env

# Development
flutter run                  # Run on device/emulator
flutter run -d chrome        # Run on web (testing)
flutter analyze              # Code analysis
flutter test                 # Run tests

# Build
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle
flutter build ios --release        # iOS build

# Debugging
flutter clean               # Clean build cache
flutter doctor              # Check setup
flutter devices             # List connected devices
```

---

## Useful File Locations

### Configuration
- Environment variables: `.env`
- Dependencies: `pubspec.yaml`
- Android config: `android/app/build.gradle`
- iOS config: `ios/Runner/Info.plist`

### Code Entry Points
- Main app: `lib/main.dart`
- Dependency injection: `lib/core/di/injection_container.dart`
- Database setup: `lib/core/database/database_helper.dart`
- API constants: `lib/core/constants/api_constants.dart`

### Documentation
- Project overview: `projectcontext/PROJECT_OVERVIEW.md`
- Architecture: `projectcontext/ARCHITECTURE.md`
- Development guide: `projectcontext/DEVELOPMENT_GUIDE.md`
- API docs: `projectcontext/API_INTEGRATION.md`
- Implementation status: `projectcontext/IMPLEMENTATION_STATUS.md`

---

## Remember

1. **Always check documentation first** before starting tasks
2. **Follow Clean Architecture** patterns in all code
3. **Update docs after completing tasks** - keep them current
4. **Test before committing** - run `flutter analyze` and `flutter test`
5. **Use descriptive commit messages** with co-author attribution
6. **Keep code DRY** - reuse existing components and patterns
7. **Think mobile-first** - optimize for mobile performance
8. **Consider offline-first** - use SQLite for critical data
9. **Follow existing patterns** - check similar implementations first
10. **Document critical decisions** - update relevant docs

---

**Last Updated**: 2025-11-29
**Project Version**: 1.0.0+1
**Flutter Version**: 3.27.0
**Dart Version**: 3.6.0