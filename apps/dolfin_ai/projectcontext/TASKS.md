# Task List

Actionable tasks organized by priority. Pick tasks from P0 first, then P1, then P2.

## Legend

- **Priority**: P0 (Critical), P1 (High), P2 (Medium), P3 (Low)
- **Effort**: S (Small, <1 day), M (Medium, 1-3 days), L (Large, >3 days)
- **Status**: 🔴 Not Started, 🟡 In Progress, 🟢 Done

---

## P0: Launch Blockers (Critical)

Must be completed before public launch.

### Bangla Localization

#### TASK-001: Setup Flutter Localization
**Priority**: P0 | **Effort**: M | **Status**: 🔴

Setup i18n infrastructure:
1. Add `flutter_localizations` to pubspec.yaml
2. Add `intl` package
3. Create `lib/l10n/` directory
4. Configure `MaterialApp` with localization delegates
5. Create `AppLocalizations` class

**Files to Create**:
- `lib/l10n/app_localizations.dart`
- `lib/l10n/app_localizations_en.dart`
- `lib/l10n/app_localizations_bn.dart`

**References**: [Flutter i18n guide](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)

---

#### TASK-002: Translate All UI Strings
**Priority**: P0 | **Effort**: L | **Status**: 🔴

Translate 200+ UI strings to Bangla:
1. Extract all hardcoded strings
2. Convert to localization keys
3. Provide Bangla translations
4. Test with Bangla language

**Strings Count**:
- Auth screens: ~40 strings
- Dashboard screens: ~50 strings
- Chat screens: ~30 strings
- Common widgets: ~80 strings

**Hire**: Native Bangla speaker for accurate translation

---

#### TASK-003: Bangla Bot Responses
**Priority**: P0 | **Effort**: L | **Status**: 🔴

Update n8n to respond in Bangla:
1. Add language parameter to API requests
2. Update AI prompts for Bangla output
3. Store user language preference
4. Test Bangla conversation flows

**Blockers**: Requires n8n backend developer

---

#### TASK-004: Language Switcher UI
**Priority**: P0 | **Effort**: S | **Status**: 🔴

Add language toggle:
1. Add switcher in settings/profile
2. Save preference to SharedPreferences
3. Reload app with new locale
4. Add flag icons (🇧🇩 🇺🇸)

**Location**: `lib/features/home/presentation/widgets/profile_modal.dart`

---

### UX Critical Fixes

#### TASK-005: Fix Hardcoded User ID
**Priority**: P0 | **Effort**: S | **Status**: 🔴

Replace hardcoded "8130001838" with actual user.id:
1. Open `lib/features/home/data/repository/dashboard_repository_impl.dart:47`
2. Change `"8130001838"` to `user.id`
3. Test with multiple users

**Impact**: HIGH - Currently all users see same dashboard!

---

#### TASK-006: Improve Onboarding Flow
**Priority**: P0 | **Effort**: M | **Status**: 🔴

Redesign onboarding to explain chat feature:
1. Add 3-4 onboarding screens
2. Show chat interaction example
3. Highlight receipt scanning
4. Add skip button
5. Store onboarding completion flag

**Screens**:
- Welcome + value proposition
- Chat tutorial
- Receipt scanning demo
- Get started CTA

---

#### TASK-007: Make Chat Button Prominent
**Priority**: P0 | **Effort**: S | **Status**: 🔴

Improve chat discoverability:
1. Larger chat FAB on dashboard
2. Add tooltip/pulse animation (first visit)
3. Quick action suggestions ("Track expense", "View budget")

**Location**: `lib/features/home/presentation/widgets/chat_input_button.dart`

---

#### TASK-008: Complete Password Reset
**Priority**: P0 | **Effort**: M | **Status**: 🔴

Implement forgot password backend:
1. Create n8n email sending workflow
2. Generate password reset tokens
3. Send reset email with link
4. Create reset password page
5. Validate token and update password

**Dependencies**: Email service (SendGrid/AWS SES)

---

## P1: MVP Features (High Priority)

Essential features for competitive product.

### Budget Management

#### TASK-009: Budget Domain Layer
**Priority**: P1 | **Effort**: S | **Status**: 🔴

Create budget feature domain layer:
1. Create `lib/features/budgets/domain/entities/budget.dart`
2. Create repository interface
3. Create use cases (create, get, update, delete)

---

#### TASK-010: Budget Data Layer
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Implement budget data layer:
1. Create budget model
2. Create local data source (SQLite)
3. Create remote data source (n8n)
4. Implement repository

**SQL**:
```sql
CREATE TABLE budgets (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  category TEXT NOT NULL,
  amount REAL NOT NULL,
  period TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL
);
```

---

#### TASK-011: Budget UI Pages
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Create budget management UI:
1. Budget list page
2. Create budget page (form)
3. Budget detail page
4. Edit budget page
5. Budget cubit & states

**Screens**: 4 pages total

---

#### TASK-012: Budget Tracking Widget
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Add budget tracking to dashboard:
1. Budget progress widget (% spent)
2. Budget alerts (80%, 100%)
3. Budget summary card
4. Navigation to budget details

---

### Transaction Management

#### TASK-013: Transaction List Page
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Build transaction history page:
1. List all transactions
2. Pagination/infinite scroll
3. Filter by date, category, account
4. Search functionality
5. Pull-to-refresh

---

#### TASK-014: Transaction CRUD
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Implement transaction operations:
1. View transaction details
2. Edit transaction (amount, category, date)
3. Delete transaction with confirmation
4. n8n API endpoints for CRUD

---

### Reports & Analytics

#### TASK-015: Monthly Report Page
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Create monthly spending report:
1. Month selector
2. Income vs expense summary
3. Category breakdown chart
4. Top expenses list
5. Savings rate

---

#### TASK-016: Export to PDF
**Priority**: P1 | **Effort**: M | **Status**: 🔴

Implement report export:
1. Add `pdf` package
2. Generate PDF from report data
3. Save to device
4. Share functionality

---

## P2: Polish & Enhancement (Medium Priority)

Improve quality and user experience.

### Testing & Quality

#### TASK-017: Unit Tests
**Priority**: P2 | **Effort**: L | **Status**: 🔴

Write unit tests:
1. Repository tests (all features)
2. Use case tests
3. Cubit tests
4. Target: >60% coverage

---

#### TASK-018: Widget Tests
**Priority**: P2 | **Effort**: M | **Status**: 🔴

Write widget tests:
1. Critical user flows
2. UI component tests
3. Interaction tests

---

#### TASK-019: Integration Tests
**Priority**: P2 | **Effort**: M | **Status**: 🔴

Write E2E tests:
1. Login → Dashboard → Chat flow
2. Expense tracking flow
3. Budget creation flow

---

### Performance Optimization

#### TASK-020: Dashboard Caching
**Priority**: P2 | **Effort**: M | **Status**: 🔴

Cache dashboard data locally:
1. Save dashboard data to SQLite
2. Load from cache first
3. Refresh in background
4. Offline mode support

---

#### TASK-021: Image Compression
**Priority**: P2 | **Effort**: S | **Status**: 🔴

Compress images before upload:
1. Add `image` package
2. Compress to max 1MB
3. Maintain quality
4. Reduce upload time

---

#### TASK-022: Cold Start Optimization
**Priority**: P2 | **Effort**: M | **Status**: 🔴

Improve app startup time:
1. Lazy load services
2. Defer non-critical init
3. Profile startup time
4. Target: <2s cold start

---

### User Experience

#### TASK-023: Error Messages
**Priority**: P2 | **Effort**: S | **Status**: 🔴

Improve error handling:
1. User-friendly error messages
2. Actionable error states
3. Retry buttons
4. Offline indicators

---

#### TASK-024: Loading States
**Priority**: P2 | **Effort**: S | **Status**: 🔴

Better loading indicators:
1. Skeleton screens (more widgets)
2. Progressive loading
3. Smooth transitions

---

#### TASK-025: Empty States
**Priority**: P2 | **Effort**: S | **Status**: 🔴

Design empty states:
1. No transactions yet
2. No budgets created
3. No reports available
4. Add illustrations & CTAs

---

## P3: Future Enhancements (Low Priority)

Nice-to-have features for future releases.

### Push Notifications

#### TASK-026: FCM Setup
**Priority**: P3 | **Effort**: M | **Status**: 🔴

Setup Firebase Cloud Messaging:
1. Add Firebase to project
2. Configure iOS/Android
3. Request permissions
4. Handle notifications

---

#### TASK-027: Notification Types
**Priority**: P3 | **Effort**: M | **Status**: 🔴

Implement notification types:
1. Budget alerts
2. Bill reminders
3. Spending insights
4. User preferences

---

### Bank Integration

#### TASK-028: Bank API Research
**Priority**: P3 | **Effort**: L | **Status**: 🔴

Research bank integration:
1. Available APIs in Bangladesh
2. Legal requirements
3. Partnership opportunities
4. Implementation complexity

---

### Cloud Sync

#### TASK-029: Backend Migration
**Priority**: P3 | **Effort**: L | **Status**: 🔴

Move to cloud database:
1. Design cloud schema
2. Implement sync logic
3. Conflict resolution
4. Offline queue

---

## Quick Wins (Easy Impact)

Quick tasks with high user impact.

#### TASK-030: Add Help/FAQ
**Priority**: P2 | **Effort**: S | **Status**: 🔴

Create help section:
1. FAQ page with common questions
2. Tutorial videos/GIFs
3. Contact support form

---

#### TASK-031: Add App Version
**Priority**: P3 | **Effort**: S | **Status**: 🔴

Show app version:
1. Display in settings/about
2. Add "Check for updates"
3. Version history/changelog

---

#### TASK-032: Improve Settings
**Priority**: P2 | **Effort**: S | **Status**: 🔴

Expand settings page:
1. Account settings
2. Notification preferences
3. Privacy settings
4. About/credits

---

#### TASK-033: Add Loading Progress
**Priority**: P3 | **Effort**: S | **Status**: 🔴

Show upload progress:
1. Progress bar for image upload
2. Percentage indicator
3. Cancel button

---

## Bug Fixes

Known bugs that need fixing.

#### TASK-034: Fix Chat Bot ID
**Priority**: P1 | **Effort**: S | **Status**: 🔴

**Location**: `lib/features/home/presentation/widgets/chat_input_button.dart:28`
**Issue**: Uses "nai kichu" instead of "balance_tracker"
**Fix**: Change to `AppConstants.botID`

---

#### TASK-035: Remove Debug Logs
**Priority**: P1 | **Effort**: S | **Status**: 🔴

Clean up debug code:
1. Remove all `print()` statements
2. Add proper logging library
3. Use kDebugMode guards

---

## Task Assignment Template

When picking a task:
```
Task ID: TASK-XXX
Assigned to: [Developer Name]
Started: YYYY-MM-DD
Status: 🟡 In Progress
Estimated Completion: YYYY-MM-DD
Notes: [Any blockers or notes]
```

## Task Dependencies

Some tasks depend on others:
- TASK-002 → TASK-003 (Bangla UI before bot responses)
- TASK-009 → TASK-010 → TASK-011 (Domain → Data → UI)
- TASK-017, 018, 019 → TASK-020+ (Testing before optimization)

---

## Sprint Planning

### Sprint 1 (Week 1-2): Launch Blockers
- TASK-001, 002, 004, 005, 006, 007

### Sprint 2 (Week 3-4): Budgets
- TASK-009, 010, 011, 012

### Sprint 3 (Week 5-6): Reports
- TASK-015, 016

### Sprint 4 (Week 7-8): Transactions
- TASK-013, 014

### Sprint 5 (Week 9): Testing
- TASK-017, 018, 019

### Sprint 6 (Week 10): Polish & Deploy
- TASK-020, 021, 022, 023, 024, 025, 035

---

## Tracking Progress

Update this document weekly:
- Mark completed tasks 🟢
- Update in-progress tasks 🟡
- Add new tasks as needed
- Reprioritize based on feedback

---

**Last Updated**: 2025-11-21
**Next Review**: Every Monday
**Tasks Completed**: 0 / 35
