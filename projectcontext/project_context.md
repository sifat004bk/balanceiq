# BalanceIQ - Project Context

> **Main Documentation Hub** - This is the comprehensive project context document. For specific guides, see the [Supporting Documents](#supporting-documents) section below.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Features](#features)
4. [Technology Stack](#technology-stack)
5. [Project Structure](#project-structure)
6. [Key Components](#key-components)
7. [Development Journey](#development-journey)
8. [Database Schema](#database-schema)
9. [API Integration](#api-integration)
10. [State Management](#state-management)
11. [Authentication](#authentication)
12. [UI/UX Design](#uiux-design)
13. [Recent Fixes and Improvements](#recent-fixes-and-improvements)
14. [Configuration](#configuration)
15. [Build and Deployment](#build-and-deployment)
16. [Supporting Documents](#supporting-documents)

---

## Supporting Documents

This project context is complemented by specialized guides located in the `projectcontext/` directory:

### 📚 Available Guides

1. **[development_guide.md](development_guide.md)**
   - How to extend and customize the app
   - Adding new bots and features
   - Modifying UI/UX components
   - Database changes and migrations
   - Best practices and code patterns
   - **Use this for**: Development work, adding features, customization

2. **[testing_guide.md](testing_guide.md)**
   - Comprehensive testing checklist
   - Authentication testing
   - Chat functionality testing
   - Media handling tests (images, audio)
   - Database and performance tests
   - Platform-specific tests (Android/iOS)
   - **Use this for**: QA testing, verification, quality assurance

3. **[app_overview.md](app_overview.md)**
   - Visual diagrams and flowcharts
   - Data flow diagrams
   - Architecture layer visualization
   - Screen hierarchy and navigation flow
   - Database schema visual representation
   - Bot configuration overview
   - **Use this for**: Understanding system design, onboarding new developers

4. **[webhook_integration.md](webhook_integration.md)**
   - n8n webhook setup and configuration
   - Request/response payload structures
   - Migration from Telegram to webhook
   - Database table interactions
   - Troubleshooting webhook issues
   - **Use this for**: Backend integration, webhook debugging

### 📖 How to Use These Documents

- **New Developers**: Start with [app_overview.md](app_overview.md) → this document → [development_guide.md](development_guide.md)
- **QA/Testers**: Use [testing_guide.md](testing_guide.md) for comprehensive testing
- **Backend Integration**: Refer to [webhook_integration.md](webhook_integration.md)
- **Feature Development**: Check [development_guide.md](development_guide.md) for patterns and examples

---

## Project Overview

**BalanceIQ** is an AI-powered personal finance management application built with Flutter for cross-platform mobile deployment (iOS and Android). The app features a comprehensive financial dashboard and an intelligent chatbot assistant that helps users track expenses, manage budgets, and gain insights into their financial health through an intuitive interface with support for text, image, and audio messages.

### Version
- **App Version**: 1.0.0+1
- **Flutter SDK**: 3.27.0
- **Dart SDK**: 3.6.0

### Core Purpose
BalanceIQ aims to democratize financial literacy and management by providing:
- **Automated Expense Tracking**: Track spending through chat conversations with receipt scanning
- **Financial Dashboard**: Real-time visualization of income, expenses, savings, and financial ratios
- **AI-Powered Insights**: Personalized financial advice and spending pattern analysis
- **Budget Management**: Set and monitor budgets with intelligent recommendations
- **Multi-Platform Access**: Seamless experience across iOS and Android devices

---

## Architecture

The project follows **Clean Architecture** principles with clear separation of concerns across three layers:

### Layer Structure

```
┌─────────────────────────────────────────────────┐
│          PRESENTATION LAYER                      │
│  (UI, Widgets, Cubits, States)                   │
├─────────────────────────────────────────────────┤
│          DOMAIN LAYER                            │
│  (Entities, Repositories, Use Cases)             │
├─────────────────────────────────────────────────┤
│          DATA LAYER                              │
│  (Models, Data Sources, Repository Impl)         │
└─────────────────────────────────────────────────┘
```

### Benefits of This Architecture
1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Testability**: Easy to unit test business logic independently
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features without breaking existing code
5. **Dependency Rule**: Dependencies only point inward (Presentation → Domain ← Data)

---

## Features

### BalanceIQ AI Assistant

**BalanceIQ** is a single, comprehensive AI-powered financial assistant that combines all aspects of personal finance management:

- **Bot ID**: `balance_tracker`
- **Primary Color**: Brand Blue (`0xFF3B82F6`)
- **Purpose**: Complete personal finance management and tracking

**Core Capabilities**:
- **Expense Tracking**: Record and categorize daily expenses through conversation
- **Receipt Scanning**: Upload receipt images for automatic expense extraction
- **Budget Management**: Create, monitor, and adjust budgets
- **Income Tracking**: Log income from multiple sources
- **Financial Insights**: AI-powered analysis of spending patterns
- **Savings Goals**: Set and track progress toward financial goals
- **Financial Education**: Personalized tips and recommendations
- **Voice Commands**: Record expenses via voice messages
- **Smart Categorization**: Automatic expense categorization using AI
- **Spending Alerts**: Notifications for unusual spending or budget limits

### Financial Dashboard

**Real-time Financial Overview**:
- **Net Balance**: Current financial position at a glance
- **Income vs Expenses**: Monthly comparison with visual indicators
- **Spending Trends**: Chart showing spending patterns over time
- **Account Breakdown**: Visual representation of different account balances
- **Biggest Expenses**: Quick view of top spending categories
- **Financial Ratios**: Savings rate and debt-to-income ratio
- **Category Analysis**: Detailed breakdown by expense category

### Authentication & User Management

**Comprehensive Authentication System**:

#### Sign-Up Flow
- **Email/Password Registration**: Traditional account creation
- **Google Sign-In**: Quick signup with Google account
- **Apple Sign-In**: Native Apple ID registration (iOS)
- **Email Verification**: Verification email sent after registration
- **Profile Setup**: Name, email, and optional photo
- **Welcome Pages**: Onboarding flow for new users

#### Sign-In Flow
- **Email/Password Login**: Secure credential-based authentication
- **Google Sign-In**: One-tap Google OAuth login
- **Apple Sign-In**: Seamless Apple ID login (iOS)
- **Remember Me**: Optional persistent session
- **Biometric Support**: Fingerprint/Face ID (planned)

#### Password Management
- **Forgot Password**: Password reset via email
- **Reset Link**: Secure token-based password reset
- **Password Requirements**: Minimum 8 characters with validation
- **Secure Storage**: Encrypted password storage

#### Session Management
- **Persistent Sessions**: User data stored in SharedPreferences
- **Automatic Login**: Remember user for seamless experience
- **Secure Logout**: Clear all session data on sign out
- **Token Management**: JWT or session token handling

### Multi-Modal Communication

**Chat Interface Features**:
- **Text Messages**: Natural language expense tracking
- **Image Support**: Upload receipts and documents (up to 10 MB)
- **Audio Messages**: Voice-based expense recording (up to 25 MB)
- **Base64 Encoding**: Secure media transmission to backend
- **OCR Processing**: Extract data from receipt images

### Data Persistence

**Local Storage**:
- **SQLite Database**: All financial data stored locally
- **Chat History**: Complete conversation history
- **Fast Retrieval**: Indexed queries for instant access
- **Offline Access**: View dashboard and history without internet
- **Data Sync**: Background synchronization with backend

#### Theme Support
- **Dark Mode**: Full dark theme support
- **Light Mode**: Clean light theme
- **Dynamic Switching**: Toggle between themes
- **Persistent Preference**: Theme choice saved locally

#### Optimistic UI Updates
- **Immediate Feedback**: User messages appear instantly
- **Typing Indicators**: Shows when bot is "thinking"
- **Error Handling**: Graceful handling of network errors
- **Auto-Scroll**: Automatically scrolls to newest messages

---

## Technology Stack

### Framework & Language
- **Flutter**: 3.27.0 (Cross-platform mobile framework)
- **Dart**: 3.6.0 (Programming language)
- **FVM**: Flutter Version Management for consistent versioning

### State Management
- **flutter_bloc**: 8.1.6 (Cubit pattern for state management)
- **equatable**: 2.0.5 (Value equality for state comparison)

### Networking
- **dio**: 5.7.0 (HTTP client for API calls)
- **http**: 1.2.2 (Alternative HTTP client)

### Local Storage
- **sqflite**: 2.3.3+2 (SQLite database for Flutter)
- **shared_preferences**: 2.3.3 (Key-value storage for user preferences)
- **path_provider**: 2.1.4 (Access device file system)
- **path**: 1.9.0 (File path manipulation)

### Media & File Handling
- **image_picker**: 1.1.2 (Select images from gallery/camera)
- **record**: 6.1.2 (Audio recording)
- **permission_handler**: 11.3.1 (Runtime permissions management)

### Authentication
- **google_sign_in**: 6.2.2 (Google OAuth authentication)
- **sign_in_with_apple**: 6.1.3 (Apple ID authentication)

### Utilities
- **get_it**: 8.0.2 (Service locator for dependency injection)
- **uuid**: 4.5.1 (Generate unique message IDs)
- **intl**: 0.19.0 (Internationalization and date formatting)
- **dartz**: 0.10.1 (Functional programming - Either monad)
- **flutter_dotenv**: 5.2.1 (Environment variables management)

### UI Components
- **flutter_markdown**: 0.7.4+1 (Render markdown in bot responses)
- **cached_network_image**: 3.4.1 (Cached image loading)
- **flutter_svg**: 2.0.10+1 (SVG rendering)
- **shimmer**: 3.0.0 (Loading skeleton screens)
- **smooth_page_indicator**: 1.2.0+3 (Page indicators)

### Development Tools
- **flutter_lints**: 5.0.0 (Linting rules)
- **flutter_test**: SDK (Testing framework)

---

## Project Structure

```
balanceIQ/
├── android/                      # Android native code
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── res/
│   │   ├── build.gradle.kts
│   │   └── google-services.json
│   └── build.gradle.kts
│
├── ios/                          # iOS native code
│   ├── Runner/
│   │   ├── Info.plist
│   │   ├── AppDelegate.swift
│   │   └── GoogleService-Info.plist
│   └── Runner.xcodeproj/
│
├── lib/                          # Main application code
│   ├── core/                     # Core utilities
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── database/
│   │   │   └── database_helper.dart
│   │   ├── di/
│   │   │   └── injection_container.dart
│   │   ├── error/
│   │   │   └── failures.dart
│   │   └── theme/
│   │       ├── app_theme.dart
│   │       ├── theme_cubit.dart
│   │       └── theme_state.dart
│   │
│   ├── features/                 # Feature modules
│   │   ├── auth/                 # Authentication feature
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── sign_in_with_google.dart
│   │   │   │       ├── sign_in_with_apple.dart
│   │   │   │       ├── sign_out.dart
│   │   │   │       └── get_current_user.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── auth_cubit.dart
│   │   │       │   └── auth_state.dart
│   │   │       └── pages/
│   │   │           ├── new_onboarding_page.dart
│   │   │           ├── new_login_page.dart
│   │   │           ├── new_signup_page.dart
│   │   │           ├── email_verification_page.dart
│   │   │           ├── verification_success_page.dart
│   │   │           ├── loading_page.dart
│   │   │           ├── homepage_loading_page.dart
│   │   │           └── network_error_page.dart
│   │   │
│   │   ├── chat/                 # Chat feature
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── chat_local_datasource.dart
│   │   │   │   │   └── chat_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── message_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── chat_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── message.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── chat_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_messages.dart
│   │   │   │       └── send_message.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── chat_cubit.dart
│   │   │       │   └── chat_state.dart
│   │   │       ├── pages/
│   │   │       │   └── chat_page.dart
│   │   │       └── widgets/
│   │   │           ├── message_list.dart
│   │   │           ├── message_bubble.dart
│   │   │           └── chat_input.dart
│   │   │
│   │   └── home/                 # Dashboard/Home feature
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── remote_datasource/
│   │       │   │       └── dashboard_remote_datasource.dart
│   │       │   ├── models/
│   │       │   │   └── dashboard_summary_response.dart
│   │       │   └── repositories/
│   │       │       └── dashboard_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── dashbaord_summary.dart
│   │       │   ├── repositories/
│   │       │   │   └── dashboard_repository.dart
│   │       │   └── usecases/
│   │       │       └── get_user_dashbaord.dart
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── dashboard_cubit.dart
│   │           │   └── dashboard_state.dart
│   │           ├── pages/
│   │           │   ├── home_page.dart
│   │           │   ├── welcome_page.dart
│   │           │   └── error_page.dart
│   │           └── widgets/
│   │               ├── home_appbar.dart
│   │               ├── balance_card_widget.dart
│   │               ├── spending_trend_chart.dart
│   │               ├── financial_ratio_widget.dart
│   │               ├── accounts_breakdown_widget.dart
│   │               ├── biggest_expense_widget.dart
│   │               ├── biggest_category_widget.dart
│   │               ├── dashboard_shimmer.dart
│   │               ├── chat_input_button.dart
│   │               └── profile_modal.dart
│   │
│   └── main.dart                 # Application entry point
│
├── test/                         # Test files
├── .env                          # Environment variables (not in git)
├── .fvm/                         # FVM configuration
├── pubspec.yaml                  # Dependencies and project metadata
└── README.md                     # Project documentation
```

---

## Key Components

### 1. Dependency Injection (injection_container.dart)

**Purpose**: Central configuration for all dependencies using GetIt service locator.

**Key Registrations**:
- **Cubits**: AuthCubit, ChatCubit, ThemeCubit (Factory - new instance each time)
- **Use Cases**: Business logic operations (LazySingleton)
- **Repositories**: Data access interfaces (LazySingleton)
- **Data Sources**: Local and remote data operations (LazySingleton)
- **External Services**: Dio, GoogleSignIn, SharedPreferences, Uuid (LazySingleton)

**Example**:
```dart
// Register ChatCubit with all its dependencies
sl.registerFactory(
  () => ChatCubit(
    getMessages: sl(),
    sendMessage: sl(),
    uuid: sl(),
  ),
);
```

### 2. Database Helper (database_helper.dart)

**Purpose**: Singleton class managing SQLite database operations.

**Tables**:
1. **users**: User profile information
2. **messages**: Chat history for all bots

**Key Features**:
- Singleton pattern for single database instance
- Database versioning support
- Index on bot_id and timestamp for fast queries
- Migration support for future schema changes

### 3. Chat Repository (chat_repository_impl.dart)

**Purpose**: Implements the bridge between data sources and domain layer.

**Key Methods**:
- `getMessages(botId)`: Retrieve chat history from local database
- `sendMessage()`: Save user message locally, send to API, save bot response
- `saveMessage()`: Save individual message
- `deleteMessage()`: Remove message
- `clearChatHistory()`: Clear all messages for a bot

**Critical Flow in sendMessage()**:
```dart
1. Create user message with UUID
2. Save user message to local DB (immediate persistence)
3. Send to n8n webhook API
4. Receive bot response
5. Save bot response to local DB
6. Return bot message
```

### 4. Chat Cubit (chat_cubit.dart)

**Purpose**: Manages chat state and business logic for presentation layer.

**States**:
- `ChatInitial`: Initial state before any interaction
- `ChatLoading`: Loading messages from database
- `ChatLoaded`: Messages loaded, contains List<Message> and isSending flag
- `ChatError`: Error occurred with error message

**Key Features**:
- **Optimistic UI Updates**: Shows user message immediately before API response
- **Typing Indicator**: isSending flag controls typing animation
- **Message Count Tracking**: Prevents unnecessary scrolling
- **Silent Reload**: Can reload without showing loading state

**sendNewMessage() Flow**:
```dart
1. Create temporary message with UUID
2. Emit ChatLoaded with temp message + isSending: true
3. Call repository sendMessage (saves to DB and calls API)
4. Reload messages from DB with showLoading: false
5. Messages now include both user and bot messages
```

### 5. Chat Page (chat_page.dart)

**Purpose**: Main UI for chat conversations with a specific bot.

**Components**:
- **AppBar**: Bot name, back button, more options
- **MessageList**: Scrollable list of messages (reversed - newest at bottom)
- **ChatInput**: Text field with attachments and send button

**Key Features**:
- **BlocConsumer**: Combines listener and builder for reactive UI
- **Auto-Scroll**: Scrolls to bottom when new messages arrive
- **Message Count Tracking**: Only scrolls when count changes
- **ScrollController**: Manages scroll position

**Listener Logic**:
```dart
- Listens to ChatLoaded states
- Compares message count with previous count
- Scrolls to bottom only if count changed (new message)
- Updates _previousMessageCount
```

### 6. Message List (message_list.dart)

**Purpose**: Renders the list of messages with typing indicator.

**Key Features**:
- **Reversed ListView**: Shows newest messages at bottom
- **Welcome Screen**: Shows when no messages exist
- **Typing Indicator**: Animated dots while bot is responding
- **Reverse Index Calculation**: Handles reversed list properly

**Index Calculation**:
```dart
// Since list is reversed, calculate actual index
reversedIndex = messages.length - 1 - index + (isSending ? 1 : 0)
```

### 7. Message Bubble (message_bubble.dart)

**Purpose**: Renders individual message bubbles with proper styling.

**Features**:
- User messages: Right-aligned, blue background
- Bot messages: Left-aligned, grey background, bot avatar
- Markdown support in bot responses
- Timestamp display
- Image and audio attachment display

### 8. Chat Input (chat_input.dart)

**Purpose**: Input area for composing and sending messages.

**Features**:
- Text input with multiline support
- Image attachment (gallery/camera)
- Audio recording
- Send button (enabled when content is not empty)
- Permission handling for camera, microphone, storage

### 9. Dashboard Components

**Purpose**: The Dashboard feature provides real-time financial overview with comprehensive metrics and visualizations.

#### Dashboard Architecture

**Clean Architecture Layers**:

```
Presentation Layer:
├── Cubit: DashboardCubit (state management)
├── States: DashboardInitial, DashboardLoading, DashboardLoaded, DashboardError
├── Pages: HomePage, WelcomePage, Error404Page
└── Widgets: 9 specialized dashboard widgets

Domain Layer:
├── Entity: DashboardSummary (18+ financial metrics)
├── Repository: DashboardRepository (abstract)
└── Use Case: GetDashboardSummary

Data Layer:
├── Repository Impl: DashboardRepositoryImpl
├── Remote DataSource: DashboardRemoteDataSource
└── Model: DashboardSummaryResponse
```

#### Dashboard Entity (DashboardSummary)

**18 Financial Metrics**:

```dart
class DashboardSummary {
  // Core Financial Metrics
  final double totalIncome;         // Total income for period
  final double totalExpense;        // Total expenses for period
  final double netBalance;          // Income - Expenses

  // Financial Ratios
  final double expenseRatio;        // Expenses/Income percentage
  final double savingsRate;         // Savings/Income percentage

  // Transaction Statistics
  final int incomeTransactions;     // Number of income transactions
  final int expenseTransactions;    // Number of expense transactions
  final double avgIncome;           // Average income per transaction
  final double avgExpense;          // Average expense per transaction

  // Spending Analysis
  final List<SpendingTrendPoint> spendingTrend;  // Daily spending data
  final Map<String, double> categories;          // Category breakdown
  final Map<String, double> accountsBreakdown;   // Account balances

  // Top Expenses
  final double biggestExpenseAmount;
  final String biggestExpenseDescription;
  final String expenseCategory;
  final String expenseAccount;
  final String biggestCategoryName;
  final double biggestCategoryAmount;

  // Period Info
  final String period;              // e.g., "January 2025"
  final int daysRemainingInMonth;
}
```

#### DashboardCubit

**File**: [lib/features/home/presentation/cubit/dashboard_cubit.dart](../lib/features/home/presentation/cubit/dashboard_cubit.dart:1)

**Purpose**: Manages dashboard state and loads financial data.

**Key Methods**:
- `loadDashboard()`: Fetches dashboard data via use case, emits Loading → Loaded/Error
- `refreshDashboard()`: Alias for loadDashboard() used by RefreshIndicator

**State Machine**:
```dart
DashboardInitial → loadDashboard() → DashboardLoading
                                   → DashboardLoaded(summary) or DashboardError(message)
```

#### Dashboard Repository Implementation

**File**: [lib/features/home/data/repository/dashboard_repository_impl.dart](../lib/features/home/data/repository/dashboard_repository_impl.dart:1)

**Critical Flow**:
```dart
1. Get cached user from AuthLocalDataSource
2. Validate user ID exists
3. Split user's full name into firstName/lastName
4. Call DashboardRemoteDataSource with:
   - userId (currently hardcoded: "8130001838")
   - botId: "balance_iq"
   - firstName, lastName, username
5. Handle errors with specific failure types:
   - AuthFailure: User not logged in
   - ServerFailure: API errors, timeouts, format errors
```

**Error Handling**:
- Format exceptions (JSON parsing errors)
- No dashboard data available
- Connection timeouts
- No internet connection
- Server errors
- Catch-all for unexpected errors

#### HomePage Implementation

**File**: [lib/features/home/presentation/pages/home_page.dart](../lib/features/home/presentation/pages/home_page.dart:1)

**Purpose**: Main dashboard screen with pull-to-refresh and state management.

**Key Features**:
1. **BlocBuilder with DashboardCubit**: Reactive UI based on dashboard state
2. **RefreshIndicator**: Pull-to-refresh functionality
3. **CustomScrollView**: Smooth scrolling with collapsible app bar
4. **Conditional Rendering**:
   - `DashboardInitial/Loading` → DashboardShimmer (loading skeleton)
   - `DashboardLoaded` with data → Full dashboard widgets
   - `DashboardLoaded` with no data → WelcomePage
   - `DashboardError` → Error404Page

**Widget Hierarchy**:
```
Scaffold
└── BlocBuilder<DashboardCubit, DashboardState>
    ├── (Loading) DashboardShimmer
    ├── (Error) Error404Page
    ├── (No Data) WelcomePage
    └── (Loaded) RefreshIndicator
        └── CustomScrollView
            ├── HomeAppbar (SliverAppBar)
            ├── SliverPadding
            │   ├── BalanceCard
            │   ├── SpendingTrendChart
            │   ├── FinancialRatiosWidget
            │   ├── AccountsBreakdownWidget
            │   ├── BiggestExpenseWidget
            │   └── BiggestCategoryWidget
            └── ChatInputButton (bottomSheet)
```

**Initialization Flow**:
```dart
initState():
  1. Load user profile
  2. Load dashboard data via DashboardCubit
```

#### Dashboard Widgets

**1. HomeAppbar** ([home_appbar.dart](../lib/features/home/presentation/widgets/home_appbar.dart:1))
- **Type**: SliverAppBar (animated collapsible)
- **Features**: Profile picture, period display, notification icon
- **Behavior**: Floats and snaps when scrolling

**2. BalanceCard** ([balance_card_widget.dart](../lib/features/home/presentation/widgets/balance_card_widget.dart:1))
- **Displays**: Net balance, total income, total expense
- **Styling**: Large prominent balance, income/expense cards with icons
- **Currency Format**: BDT with K/M abbreviations (e.g., 5.2K, 1.5M)

**3. SpendingTrendChart** ([spending_trend_chart.dart](../lib/features/home/presentation/widgets/spending_trend_chart.dart:1))
- **Library**: fl_chart (LineChart)
- **Shows**: Daily spending over 30 days
- **Features**:
  - Curved line with gradient fill
  - Interactive tooltips
  - Bottom axis with day labels (1, 5, 10, 15, 20, 25, 30)
  - Auto-scaling Y-axis

**4. FinancialRatiosWidget** ([financial_ratio_widget.dart](../lib/features/home/presentation/widgets/financial_ratio_widget.dart:1))
- **Displays**: Expense Ratio and Savings Rate (as percentages)
- **Layout**: Two cards side-by-side
- **Styling**: Color-coded (red for expense, blue for savings)

**5. AccountsBreakdownWidget** ([accounts_breakdown_widget.dart](../lib/features/home/presentation/widgets/accounts_breakdown_widget.dart:1))
- **Purpose**: Shows balance across different accounts
- **Layout**: Horizontal scrollable list
- **Features**:
  - Neumorphism design
  - Smart account detection (Cash, Bank, Credit Card, Investment)
  - Account-specific icons and colors
  - Percentage of total balance
  - Handles negative balances
- **Sorting**: Accounts sorted by balance (descending)

**6. BiggestExpenseWidget** ([biggest_expense_widget.dart](../lib/features/home/presentation/widgets/biggest_expense_widget.dart:1))
- **Displays**: Single largest expense transaction
- **Info**: Amount, description, category, account
- **Styling**: Red error color for amount

**7. BiggestCategoryWidget** ([biggest_category_widget.dart](../lib/features/home/presentation/widgets/biggest_category_widget.dart:1))
- **Displays**: Category with highest total spending
- **Info**: Category name, total amount
- **Features**: Name formatting (Title Case)

**8. DashboardShimmer** ([dashboard_shimmer.dart](../lib/features/home/presentation/widgets/dashboard_shimmer.dart:1))
- **Purpose**: Loading skeleton matching dashboard layout
- **Library**: shimmer package
- **Layout**: Mirrors actual dashboard widgets for smooth transition
- **Fix Applied**: Horizontal ListView for account cards to prevent overflow

**9. ChatInputButton** ([chat_input_button.dart](../lib/features/home/presentation/widgets/chat_input_button.dart:1))
- **Purpose**: Sticky bottom button to open chat
- **Navigation**: Opens ChatPage with botId: "nai kichu", botName: "BalanceIq"
- **Styling**: Floating button with gradient icon

#### WelcomePage

**File**: [lib/features/home/presentation/pages/welcome_page.dart](../lib/features/home/presentation/pages/welcome_page.dart:1)

**When Shown**: First-time users with no dashboard data

**Features**:
- Welcome illustration (wallet icon)
- App introduction text
- Three key features:
  1. Track Expenses
  2. Smart Insights
  3. Reach Goals
- "Get Started" button → Opens chat for first expense entry

#### Error404Page

**File**: [lib/features/home/presentation/pages/error_page.dart](../lib/features/home/presentation/pages/error_page.dart:1)

**When Shown**: Dashboard load errors (network, server, etc.)

**Features**:
- Error illustration with 404 code
- Error message display
- Common troubleshooting tips
- "Try Again" button → Calls onRetry to reload dashboard

#### Data Flow

**Complete Dashboard Load Flow**:

```
1. HomePage.initState()
   ↓
2. DashboardCubit.loadDashboard()
   ↓
3. GetDashboardSummary use case
   ↓
4. DashboardRepositoryImpl.getDashboardSummary()
   ↓
5. Get cached user (AuthLocalDataSource)
   ↓
6. DashboardRemoteDataSource.getDashboardSummary(userId, botId, ...)
   ↓
7. POST to n8n webhook (AppConstants.n8nDashboardUrl)
   ↓
8. Parse JSON response → DashboardSummaryResponse model
   ↓
9. Convert to DashboardSummary entity
   ↓
10. Return Either<Failure, DashboardSummary>
    ↓
11. DashboardCubit emits DashboardLoaded(summary)
    ↓
12. HomePage rebuilds with dashboard widgets
```

#### API Integration

**Endpoint**: `AppConstants.n8nDashboardUrl` (from .env)

**Request Payload**:
```dart
{
  "user_id": "8130001838",      // TODO: Use actual user.id
  "bot_id": "balance_iq",
  "first_name": "John",
  "last_name": "Doe",
  "username": "user@email.com"
}
```

**Response**: JSON matching DashboardSummaryResponse model

#### Known Issues & TODOs

1. **Hardcoded User ID**: DashboardRepositoryImpl uses hardcoded userId "8130001838" instead of actual user.id
2. **Chat Button Bot ID**: ChatInputButton uses placeholder "nai kichu" for botId
3. **Profile Picture**: HomeAppbar TODO to implement user profile picture

### 10. Remote Data Sources

#### Chat Remote Data Source (chat_remote_datasource.dart)

**Purpose**: Handles API communication with n8n webhook for chat messages.

**Request Payload**:
```json
{
  "user_id": "6130001838",
  "bot_id": "balance_tracker",
  "content": "User message",
  "text": "User message",
  "message": "User message",
  "first_name": "John",
  "last_name": "Doe",
  "username": "john.doe",
  "image_base64": "...",  // Optional
  "audio_base64": "..."   // Optional
}
```

**Response Format**:
```json
{
  "id": "unique_message_id",
  "message": "Bot response",
  "response": "Alternative response field",
  "image_url": "https://...",  // Optional
  "audio_url": "https://..."   // Optional
}
```

**Error Handling**:
- Connection timeout
- Send/receive timeout
- Bad response (4xx, 5xx)
- Network errors
- Unexpected response format

#### Dashboard Remote Data Source (dashboard_remote_datasource.dart)

**Purpose**: Handles API communication with n8n webhook for dashboard data.

**Request Payload**:
```json
{
  "user_id": "6130001838",
  "bot_id": "balance_tracker",
  "first_name": "John",
  "last_name": "Doe",
  "username": "john.doe"
}
```

**Response Format**:
```json
{
  "data": [
    {
      "total_balance": 5000.00,
      "total_income": 8000.00,
      "total_expenses": 3000.00,
      "savings_rate": 62.5,
      "debt_to_income_ratio": 0.15,
      "accounts": [...],
      "biggest_expense": {...},
      "biggest_category": {...},
      "spending_trend": [...]
    }
  ]
}
```

**Configuration**:
- URL configured via `AppConstants.n8nDashboardUrl`
- Reads from `.env` file: `N8N_DASHBOARD_URL`
- Fallback: `https://primary-production-7383b.up.railway.app/webhook-test/get-user-dashboard`

**Error Handling**:
- Connection timeout
- Receive timeout
- Connection errors
- 404: Service not found
- 500: Server error
- Invalid data format validation

---

## Development Journey

### Initial Setup
1. **Project Creation**: Flutter project initialized with clean architecture
2. **Dependencies**: Added flutter_bloc, dio, sqflite, and other essential packages
3. **Firebase Setup**: Configured Google and Apple authentication
4. **Database Schema**: Designed users and messages tables
5. **Dependency Injection**: Set up GetIt for service locator pattern

### Authentication Implementation
1. **Google Sign-In**: Implemented OAuth flow with Firebase
2. **Apple Sign-In**: Added iOS-specific Apple ID authentication
3. **Session Management**: Used SharedPreferences for persistent login
4. **Auth States**: Created AuthCubit with proper state management

### Chat Feature Development
1. **Domain Layer**: Defined Message entity and ChatRepository interface
2. **Data Layer**: Implemented local and remote data sources
3. **Presentation Layer**: Built chat UI with message bubbles and input
4. **State Management**: Created ChatCubit with ChatStates

### UI/UX Enhancement
1. **Theme System**: Implemented dark/light mode with ThemeCubit
2. **Onboarding Flow**: Created modern onboarding screens
3. **Home Page**: Designed bot selection interface
4. **Chat Interface**: Built ChatGPT-style message UI

### Optimistic UI Implementation
1. **Problem Identified**: Messages weren't appearing immediately
2. **Solution**: Implemented optimistic updates with temporary messages
3. **Typing Indicator**: Added animated typing indicator
4. **Auto-Scroll**: Implemented smart scrolling based on message count

---

## Recent Fixes and Improvements

### 1. Environment Variable Support (.env file)

**Issue**: Webhook URL was hardcoded in constants file.

**Solution**:
- Added `flutter_dotenv` package
- Created `.env` file for N8N_WEBHOOK_URL
- Updated `app_constants.dart` to use `dotenv.get()`
- Added `.env` to assets in `pubspec.yaml`

**Files Modified**:
- `pubspec.yaml`: Added flutter_dotenv dependency and .env asset
- `main.dart`: Added `await dotenv.load(fileName: ".env")`
- `app_constants.dart`: Changed to use `dotenv.get('N8N_WEBHOOK_URL', fallback: '...')`

### 2. Immediate Message Display Fix

**Issue**: User messages weren't visible until bot replied.

**Root Cause**: Messages were only being saved after API response.

**Solution**:
- Implemented optimistic UI updates
- Created temporary message with UUID immediately
- Emitted state with temp message before API call
- Repository saves user message to DB before API call
- Silent reload after API completes

**Key Changes**:
- `chat_cubit.dart`: Added temp message creation and immediate state emission
- `chat_repository_impl.dart`: Saves user message before API call
- `injection_container.dart`: Added uuid to ChatCubit dependencies

### 3. Auto-Scroll Optimization

**Issue**: Chat scrolled unnecessarily on every state update.

**Solution**:
- Added `_previousMessageCount` in ChatPage
- Only scroll when message count changes
- Prevents scrolling when only isSending flag changes

**Implementation**:
```dart
if (state.messages.length != _previousMessageCount) {
  _previousMessageCount = state.messages.length;
  _scrollToBottom();
}
```

### 4. Typing Indicator Enhancement

**Issue**: No visual feedback while waiting for bot response.

**Solution**:
- Added `isSending` flag to ChatLoaded state
- Created animated typing indicator widget
- Adjusted itemCount in ListView to include indicator
- Shows three animated dots while waiting

### 5. Comprehensive Logging

**Issue**: Difficult to debug message flow and state changes.

**Solution**:
- Added detailed logging throughout the message pipeline
- ChatCubit: Logs state emissions and message operations
- ChatPage: Logs listener and builder events
- MessageList: Logs every message with serial numbers
- Includes message count, isSending flag, and content previews

**Note**: Logging should be removed before production release.

### 6. Fresh User Bug Fix

**Issue**: App crashed for fresh users with "Bad state: No element" error.

**Root Cause**: Attempted to access `.last` on empty message list in debug log.

**Solution**:
- Removed `state.messages.last` from log statement in chat_page.dart:136
- Added proper empty list checks

**Error Fixed**:
```dart
// Before (crashed on empty list)
print('... last message${state.messages.last}');

// After (safe)
print('... isSending: ${state.isSending}');
```

---

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL,
  photo_url TEXT,
  auth_provider TEXT NOT NULL,  -- 'google' or 'apple'
  created_at TEXT NOT NULL       -- ISO 8601 timestamp
);
```

### Messages Table
```sql
CREATE TABLE messages (
  id TEXT PRIMARY KEY,           -- UUID v4
  bot_id TEXT NOT NULL,          -- balance_tracker, investment_guru, etc.
  sender TEXT NOT NULL,          -- 'user' or 'bot'
  content TEXT NOT NULL,         -- Message text
  image_url TEXT,                -- Path or URL to image
  audio_url TEXT,                -- Path or URL to audio
  timestamp TEXT NOT NULL,       -- ISO 8601 timestamp
  is_sending INTEGER NOT NULL DEFAULT 0,   -- Boolean: 1 = sending, 0 = sent
  has_error INTEGER NOT NULL DEFAULT 0     -- Boolean: 1 = error, 0 = success
);

-- Index for efficient queries
CREATE INDEX idx_messages_bot_timestamp
ON messages(bot_id, timestamp);
```

### Query Patterns
```dart
// Get all messages for a bot, ordered by timestamp
SELECT * FROM messages
WHERE bot_id = ?
ORDER BY timestamp ASC;

// Insert new message
INSERT INTO messages (id, bot_id, sender, content, timestamp, ...)
VALUES (?, ?, ?, ?, ?, ...);

// Delete all messages for a bot
DELETE FROM messages WHERE bot_id = ?;
```

---

## API Integration

### n8n Webhook Integration

**Endpoint**: Configurable via .env file
```
N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/balance-iq
```

**Request Method**: POST

**Request Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "user_id": "6130001838",
  "bot_id": "balance_tracker",
  "content": "I spent $50 on groceries",
  "text": "I spent $50 on groceries",
  "message": "I spent $50 on groceries",
  "first_name": "John",
  "last_name": "Doe",
  "username": "john.doe",
  "image_base64": "data:image/jpeg;base64,...",  // Optional
  "audio_base64": "data:audio/mp3;base64,..."   // Optional
}
```

**Response Format**:

The API can return either an array or object:

**Array Response** (n8n webhook default):
```json
[
  {
    "id": "msg_12345",
    "message": "I've recorded your $50 grocery expense.",
    "image_url": null,
    "audio_url": null
  }
]
```

**Object Response**:
```json
{
  "id": "msg_12345",
  "message": "I've recorded your $50 grocery expense.",
  "response": "Alternative response field",
  "image_url": null,
  "audio_url": null
}
```

**Error Responses**:
- **Timeout**: Connection, send, or receive timeout
- **4xx/5xx**: Server errors with status code
- **Network Error**: No internet connection

**Timeout Configuration**:
```dart
static const Duration apiTimeout = Duration(seconds: 30);
```

---

## State Management

### Cubit Pattern

**Why Cubit over Bloc?**
- Simpler API: Only emit() method, no event classes
- Less boilerplate: Fewer files to maintain
- Sufficient for most use cases: Methods directly trigger state changes
- Still reactive: UI rebuilds automatically on state changes

### Auth State Machine

```
AuthInitial
    ↓
  checkSession()
    ↓
    ├─→ AuthLoading
    │       ↓
    │   ┌───────┴────────┐
    │   ↓                ↓
    │ AuthAuthenticated  AuthUnauthenticated
    │   ↑                ↑
    │   │                │
    └───┴────────────────┘
      signIn()     signOut()
```

**States**:
- `AuthInitial`: App just launched
- `AuthLoading`: Checking auth status or signing in
- `AuthAuthenticated`: User logged in (contains User entity)
- `AuthUnauthenticated`: User not logged in
- `AuthError`: Authentication error (contains error message)

### Chat State Machine

```
ChatInitial
    ↓
  loadMessages(botId)
    ↓
  ChatLoading
    ↓
  ChatLoaded (messages: [], isSending: false)
    ↓
  sendNewMessage()
    ↓
  ChatLoaded (messages: [..., tempMessage], isSending: true)
    ↓
  [API Call in background]
    ↓
  ChatLoaded (messages: [..., userMessage, botMessage], isSending: false)
```

**States**:
- `ChatInitial`: Chat not yet opened
- `ChatLoading`: Loading messages from database
- `ChatLoaded`: Messages displayed (has messages list and isSending flag)
- `ChatError`: Error loading messages

**ChatLoaded State**:
```dart
class ChatLoaded extends ChatState {
  final List<Message> messages;
  final bool isSending;  // Is bot currently generating response?

  const ChatLoaded({
    required this.messages,
    this.isSending = false,
  });
}
```

### Theme State

```
ThemeState
    ↓
  toggleTheme()
    ↓
  ThemeState (isDarkMode: !current)
    ↓
  [Save to SharedPreferences]
```

---

## Authentication

### Google Sign-In Flow

1. **User Taps "Sign in with Google"**
2. **Google Sign-In SDK Opens**:
   - Shows Google account picker
   - User selects account
   - User grants permissions
3. **Receive Google Credentials**:
   - idToken, accessToken, and user info
4. **Save User to Local Database**:
   - Create User entity
   - Save to SQLite users table
   - Save to SharedPreferences
5. **Emit AuthAuthenticated State**
6. **Navigate to HomePage**

**SHA-1 Fingerprint Requirement**:
- Each developer adds their debug keystore SHA-1 to Firebase
- Production: Add release keystore SHA-1
- Google Play: Add Play App Signing certificate SHA-1

**Get SHA-1**:
```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android \
  | grep -A 2 "SHA1:"
```

### Apple Sign-In Flow (iOS only)

1. **User Taps "Sign in with Apple"**
2. **Apple Sign-In SDK Opens**:
   - Face ID / Touch ID authentication
   - User grants permissions
3. **Receive Apple Credentials**:
   - identityToken, authorizationCode
   - User info (email, name)
4. **Save User to Local Database**
5. **Emit AuthAuthenticated State**
6. **Navigate to HomePage**

**iOS Configuration Required**:
- Capability: Sign in with Apple
- Bundle ID registered in Apple Developer Portal
- Info.plist configured with OAuth client ID

### Session Persistence

**User Data Stored in SharedPreferences**:
```dart
- keyIsLoggedIn: true/false
- keyUserId: user.id
- keyUserEmail: user.email
- keyUserName: user.name
- keyUserPhotoUrl: user.photoUrl
- keyUserAuthProvider: 'google' or 'apple'
```

**On App Launch**:
```dart
1. Check keyIsLoggedIn
2. If true, load user data from SharedPreferences
3. Emit AuthAuthenticated
4. Navigate to HomePage
5. If false, show Onboarding/Login
```

---

## UI/UX Design

### Design Language

**Inspired by**: ChatGPT, Modern Financial Apps
**Style**: Clean, Minimal, Professional
**Color Scheme**: Brand colors for each bot

### Color Palette

**Light Mode**:
- Background: `#FFFFFF`
- Surface: `#F9FAFB`
- Text Primary: `#111827`
- Text Secondary: `#6B7280`
- Border: `#E5E7EB`

**Dark Mode**:
- Background: `#1F2937`
- Surface: `#374151`
- Text Primary: `#F9FAFB`
- Text Secondary: `#D1D5DB`
- Border: `#4B5563`

**Bot Colors**:
- Balance Tracker: Blue `#3B82F6`
- Investment Guru: Green `#10B981`
- Budget Planner: Purple `#8B5CF6`
- Fin Tips: Orange `#F59E0B`

### Typography

**Font Family**: System default (Roboto on Android, San Francisco on iOS)

**Text Styles**:
- Display Large: 32sp, Bold
- Display Small: 24sp, Bold
- Title Medium: 16sp, Bold
- Body Large: 16sp, Regular
- Body Medium: 14sp, Regular
- Body Small: 12sp, Regular

### Screen Layouts

#### Home Page
```
┌────────────────────────────┐
│  Profile Icon    BalanceIQ │
├────────────────────────────┤
│                            │
│   Choose Your Assistant    │
│                            │
│  ┌──────────┬──────────┐  │
│  │ Balance  │Investment│  │
│  │ Tracker  │   Guru   │  │
│  └──────────┴──────────┘  │
│  ┌──────────┬──────────┐  │
│  │  Budget  │   Fin    │  │
│  │ Planner  │   Tips   │  │
│  └──────────┴──────────┘  │
│                            │
└────────────────────────────┘
```

#### Chat Page
```
┌────────────────────────────┐
│  ←  Balance Tracker     ⋮  │
├────────────────────────────┤
│                            │
│   [Bot] Hello! How can   │
│         I help you?       │
│                            │
│         You did X      [User]
│                            │
│   [Bot] I see. Let me     │
│         help you with...  │
│                            │
│         ⋮  ⋮  ⋮  [Typing] │
│                            │
├────────────────────────────┤
│  [📎] [Message...] [🎤]   │
└────────────────────────────┘
```

#### Message Bubble Design

**User Message**:
- Alignment: Right
- Background: Bot color (blue, green, etc.)
- Text Color: White
- Border Radius: 18px (rounded corners)
- Max Width: 80% of screen

**Bot Message**:
- Alignment: Left
- Avatar: Circle with bot icon
- Background: Light grey (light mode) / Dark grey (dark mode)
- Text Color: Black (light mode) / White (dark mode)
- Border Radius: 18px
- Max Width: 80% of screen
- Markdown Support: Bold, italic, lists, links

### Animations

**Typing Indicator**:
- Three dots
- Fade in/out animation
- Duration: 600ms per dot
- Delay: 150ms between dots

**Message Appearance**:
- Fade in with slight slide up
- Duration: 200ms
- Curve: easeOut

**Scroll Animation**:
- Duration: 300ms
- Curve: easeOut

---

## Configuration

### Environment Variables (.env)

```bash
# n8n Webhook URL (for chat messages)
N8N_WEBHOOK_URL=https://your-n8n-instance.com/webhook/balance-iq

# n8n Dashboard URL (for dashboard data)
N8N_DASHBOARD_URL=https://your-n8n-instance.com/webhook-test/get-user-dashboard
```

**Important**: `.env` file should be in project root and added to `.gitignore`.

### App Constants (app_constants.dart)

**Database**:
```dart
static const String databaseName = 'balance_iq.db';
static const int databaseVersion = 1;
static const String usersTable = 'users';
static const String messagesTable = 'messages';
```

**Bot Configuration**:
```dart
// BalanceIQ uses a single AI assistant
static const String botID = 'balance_tracker';
static const String botName = 'BalanceIQ';
```

**Timeouts**:
```dart
static const Duration apiTimeout = Duration(seconds: 30);
static const Duration recordingTimeout = Duration(minutes: 5);
```

**File Size Limits**:
```dart
static const int maxImageSize = 10 * 1024 * 1024; // 10 MB
static const int maxAudioSize = 25 * 1024 * 1024; // 25 MB
```

### Permissions

**Android (AndroidManifest.xml)**:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
                 android:maxSdkVersion="32" />
```

**iOS (Info.plist)**:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos for chat messages</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access to record audio messages</string>
```

---

## Build and Deployment

### Development Build

```bash
# Using FVM (recommended)
fvm flutter run

# Run on specific device
fvm flutter run -d <device-id>

# Run with custom webhook URL
fvm flutter run --dart-define=N8N_WEBHOOK_URL=https://custom-url.com
```

### Production Build

**Android APK**:
```bash
fvm flutter build apk --release
```

**Android App Bundle (for Play Store)**:
```bash
fvm flutter build appbundle --release
```

**iOS**:
```bash
fvm flutter build ios --release
```

### Release Checklist

- [ ] Remove all debug print statements
- [ ] Update version in pubspec.yaml
- [ ] Test on multiple devices
- [ ] Test both light and dark modes
- [ ] Test all four bots
- [ ] Test offline functionality
- [ ] Test with slow network
- [ ] Test error scenarios
- [ ] Add release keystore SHA-1 to Firebase (Android)
- [ ] Configure app signing in Play Console
- [ ] Set up TestFlight (iOS)
- [ ] Update app store descriptions
- [ ] Create screenshots for stores
- [ ] Privacy policy and terms of service
- [ ] App store compliance review

### Version Management

**Semantic Versioning**: MAJOR.MINOR.PATCH+BUILD
- Example: `1.0.0+1`
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes
- BUILD: Build number (auto-increment)

**Update Version**:
```yaml
# pubspec.yaml
version: 1.0.1+2  # version 1.0.1, build 2
```

---

## Testing Strategy

### Unit Tests
- Test use cases independently
- Test repository implementations with mocks
- Test state transitions in Cubits
- Test utility functions

### Widget Tests
- Test individual widgets render correctly
- Test user interactions trigger correct callbacks
- Test state changes update UI

### Integration Tests
- Test complete flows (login, send message, logout)
- Test navigation between screens
- Test data persistence

### Manual Testing Checklist

**Authentication**:
- [ ] Google sign-in works
- [ ] Apple sign-in works (iOS)
- [ ] Session persists after app restart
- [ ] Sign-out clears session
- [ ] Error handling for failed sign-in

**Chat**:
- [ ] Can send text messages
- [ ] Can attach images
- [ ] Can record audio
- [ ] Messages save to database
- [ ] Messages load on chat open
- [ ] Typing indicator shows while waiting
- [ ] Auto-scroll to new messages
- [ ] Can view chat history
- [ ] Markdown renders correctly

**Edge Cases**:
- [ ] No internet connection
- [ ] API timeout
- [ ] API returns error
- [ ] Very long messages
- [ ] Large images/audio files
- [ ] Empty message list
- [ ] Fresh user with no data

---

## Future Enhancements

### Planned Features

1. **Multi-Language Support**
   - Internationalization with intl package
   - Support for English, Spanish, French, etc.

2. **Push Notifications**
   - Firebase Cloud Messaging
   - Notify user of bot responses
   - Notification preferences

3. **Export Chat History**
   - Export as PDF
   - Export as CSV
   - Email chat transcripts

4. **Voice Input**
   - Speech-to-text for messages
   - Hands-free interaction

5. **Advanced Analytics**
   - Spending trends visualization
   - Investment portfolio graphs
   - Budget vs actual charts

6. **Widgets**
   - Home screen widget for quick expense entry
   - Glanceable financial summary

7. **Cloud Sync**
   - Sync chat history across devices
   - Firebase Firestore or custom backend
   - Conflict resolution

8. **Biometric Lock**
   - Fingerprint/Face unlock
   - Protect financial data

9. **Receipt Scanning**
   - OCR to extract expense details from receipts
   - Auto-categorization

10. **Reminders**
    - Payment due date reminders
    - Budget limit alerts
    - Investment review reminders

### Technical Debt

1. **Remove Debug Logging**: All print statements should be removed or wrapped in kDebugMode
2. **Error Handling**: More comprehensive error messages and retry logic
3. **Loading States**: Better skeleton screens and loading indicators
4. **Caching**: Implement proper image caching strategy
5. **Code Documentation**: Add dartdoc comments to all public APIs
6. **Performance**: Optimize ListView rendering for large message lists
7. **Accessibility**: Add semantic labels and screen reader support
8. **Tests**: Increase test coverage to >80%

---

## Troubleshooting

### Common Issues

**1. Google Sign-In Error: ApiException: 10**

**Cause**: SHA-1 fingerprint not registered in Firebase.

**Solution**:
```bash
# Get SHA-1
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android

# Add to Firebase Console:
# Project Settings > Your apps > Android app > Add fingerprint
```

**2. Messages Not Appearing Immediately**

**Cause**: Optimistic UI not working correctly.

**Solution**: Check that:
- Temporary message is created with UUID
- State is emitted with temp message before API call
- Repository saves user message to DB before API call

**3. App Crashes on Fresh Install**

**Cause**: Database tables not created.

**Solution**:
- Check DatabaseHelper._createDB() is executed
- Verify tables are created on first app launch
- Clear app data and reinstall

**4. Typing Indicator Not Showing**

**Cause**: isSending flag not set correctly.

**Solution**:
- Verify ChatLoaded state includes isSending: true
- Check MessageList itemCount includes typing indicator
- Ensure state is emitted before API call

**5. Scroll Not Working**

**Cause**: ScrollController not attached or ListView not reversed.

**Solution**:
- Verify ScrollController is passed to ListView
- Check reverse: true is set
- Ensure _scrollToBottom() uses position 0.0

**6. .env File Not Loading**

**Cause**: File not in assets or not loaded before use.

**Solution**:
```yaml
# pubspec.yaml
assets:
  - .env
```

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // ...
}
```

**7. Build Fails: NDK Not Found**

**Cause**: Required NDK version not installed.

**Solution**:
- Open Android Studio
- Tools > SDK Manager > SDK Tools
- Install NDK 27.0.12077973

---

## Performance Considerations

### Optimizations Implemented

1. **Message List Virtualization**: ListView.builder only renders visible messages
2. **Database Indexing**: Index on bot_id and timestamp for fast queries
3. **Image Caching**: Using cached_network_image for bot avatars
4. **Lazy Loading**: Cubits registered as factories, created only when needed
5. **Singleton Database**: Single database connection shared across app

### Performance Metrics

**Target Performance**:
- Cold start: < 2 seconds
- Hot reload: < 500ms
- Message send: < 200ms (optimistic UI)
- Message list load: < 100ms
- Scroll FPS: 60 FPS

### Memory Management

- Dispose ScrollController in _ChatViewState
- Close database connection when app terminates
- Cancel Dio requests when page is disposed
- Clear image cache on memory pressure

---

## Security Considerations

### Data Protection

1. **Local Storage**: SQLite database stored in app's private directory
2. **No Plain Text Passwords**: OAuth tokens never stored permanently
3. **HTTPS Only**: All API calls use HTTPS
4. **Input Validation**: User input sanitized before API calls

### Authentication Security

- OAuth tokens expire and refresh automatically
- User can sign out to invalidate local session
- No sensitive data in SharedPreferences

### API Security

- Webhook URL can be changed without app update (.env file)
- Timeout prevents hanging requests
- Error messages don't expose internal details

### Recommendations for Production

1. **Add Certificate Pinning**: Prevent man-in-the-middle attacks
2. **Obfuscate Code**: Flutter build --obfuscate
3. **Encrypt Database**: Use sqflite_sqlcipher for encrypted database
4. **Biometric Authentication**: Require fingerprint/face to access app
5. **Rate Limiting**: Implement client-side rate limiting for API calls

---

## Dependencies and Licenses

All dependencies are open-source and compatible with commercial use. See individual package licenses:

- flutter_bloc: MIT
- dio: MIT
- sqflite: BSD-2-Clause
- google_sign_in: BSD-3-Clause
- sign_in_with_apple: MIT
- get_it: MIT
- uuid: MIT

**Project License**: MIT (if open-source) or proprietary (if commercial)

---

## Contributing Guidelines

### Code Style

- Follow Dart style guide
- Use flutter_lints rules
- Run `dart format .` before committing
- Use meaningful variable and function names

### Git Workflow

1. Create feature branch from main
2. Make changes
3. Run tests: `flutter test`
4. Run analyzer: `flutter analyze`
5. Commit with descriptive message
6. Push and create pull request
7. Wait for code review
8. Merge after approval

### Commit Message Format

```
type(scope): subject

body

footer
```

**Types**: feat, fix, docs, style, refactor, test, chore

**Example**:
```
feat(chat): implement optimistic UI updates

- Add temporary message with UUID
- Emit state before API call
- Save user message to DB immediately

Fixes #123
```

---

## Changelog

### Version 1.0.0 (Initial Release)

**Features**:
- Four specialized financial bots
- Text, image, and audio message support
- Google and Apple sign-in
- Dark mode support
- Persistent chat history with SQLite
- n8n workflow integration
- Clean architecture implementation

**Technical**:
- Flutter 3.27.0
- Dart 3.6.0
- Cubit state management
- Dependency injection with GetIt
- RESTful API integration

### Version 1.0.1 (Bug Fixes)

**Fixed**:
- Optimistic UI updates for immediate message display
- Auto-scroll on new messages
- Fresh user crash on empty message list
- Environment variable support for webhook URL

**Improved**:
- Typing indicator animation
- Message count tracking for scroll optimization
- Comprehensive logging for debugging

---

## Contact and Support

**Developer**: Sifatullah Chowdhury
**Project**: BalanceIQ
**Repository**: [Add Git URL]

For issues, feature requests, or questions, please:
1. Check the troubleshooting section
2. Search existing issues
3. Create a new issue with detailed description

---

## Acknowledgments

**Design Inspiration**: ChatGPT UI, Modern Banking Apps
**Architecture**: Clean Architecture by Robert C. Martin
**State Management**: flutter_bloc by Felix Angelov
**Community**: Flutter, Dart, and Firebase communities

---

**Last Updated**: 2025-01-09
**Document Version**: 1.0
**Project Version**: 1.0.1+2
