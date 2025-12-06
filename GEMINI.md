# Gemini Code - Project Guide

## Commands

- `flutter run` - Run the app
- `flutter test` - Run tests
- `flutter analyze` - Run linter
- `flutter clean` - Clean build artifacts
- `flutter pub get` - Install dependencies
- `flutter build apk --release` - Build Android APK
- `flutter build ios --release` - Build iOS app

## Workflow

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

   🤖 Generated with Gemini Code

   Co-Authored-By: Gemini <noreply@google.com>"
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
- Postman API collection: `projectcontext/project_summary/tech/Business.postman_collection.json`
- Mock environment guide: `projectcontext/project_summary/tech/MOCK_ENVIRONMENT_GUIDE.md`
- Mock data sources: `lib/core/mock/`

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

**Last Updated**: 2025-12-06
**Project Version**: 1.0.0+1
**Flutter Version**: 3.27.0
**Dart Version**: 3.6.0
