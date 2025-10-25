# BalanceIQ - Visual App Overview

## 🎨 App Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     BALANCEIQ APP FLOW                      │
└─────────────────────────────────────────────────────────────┘

┌──────────────────┐
│  App Launches    │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Onboarding      │  ◄─── First Time Users
│  Screen          │
│                  │
│  • Google Sign-In│
│  • Apple Sign-In │
└────────┬─────────┘
         │
         │ Authenticated ✓
         │
         ▼
┌──────────────────┐
│  Home Screen     │
│                  │
│  Choose Bot:     │
│  ┌────────────┐  │
│  │ Balance    │  │ ◄─── Tap to Open
│  │ Tracker    │  │
│  └────────────┘  │
│  ┌────────────┐  │
│  │ Investment │  │
│  │ Guru       │  │
│  └────────────┘  │
│  ┌────────────┐  │
│  │ Budget     │  │
│  │ Planner    │  │
│  └────────────┘  │
│  ┌────────────┐  │
│  │ Fin Tips   │  │
│  └────────────┘  │
└────────┬─────────┘
         │
         │ Bot Selected
         │
         ▼
┌──────────────────┐
│  Chat Screen     │
│                  │
│  ┌────────────┐  │
│  │ Messages   │  │ ◄─── History from SQLite
│  │ History    │  │
│  └────────────┘  │
│                  │
│  Input Options:  │
│  [📷] [🎤] [💬] │ ◄─── Image | Audio | Text
│                  │
│  ──────────────  │
│  Send ➤          │ ◄─── Sends to n8n
│                  │
│  ⚙️  Processing  │
│                  │
│  ┌────────────┐  │
│  │ Bot Reply  │  │ ◄─── From n8n Workflow
│  └────────────┘  │
│                  │
│  Saved to DB ✓   │ ◄─── Persisted locally
└──────────────────┘
```

## 🔄 Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      DATA FLOW DIAGRAM                      │
└─────────────────────────────────────────────────────────────┘

User Input (Text/Image/Audio)
         │
         ▼
┌─────────────────┐
│  Chat Input     │
│  Widget         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  ChatCubit      │ ◄─── State Management
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  SendMessage    │ ◄─── Use Case
│  Use Case       │
└────────┬────────┘
         │
         ├──────────────────┬────────────────────┐
         │                  │                    │
         ▼                  ▼                    ▼
┌──────────────┐   ┌──────────────┐    ┌──────────────┐
│ Save User    │   │ Send to n8n  │    │ Process      │
│ Message to   │   │ Webhook      │    │ Media        │
│ SQLite       │   │              │    │ (Base64)     │
└──────────────┘   └──────┬───────┘    └──────────────┘
                          │
                          │ HTTP POST
                          │
                          ▼
                   ┌──────────────┐
                   │ n8n Workflow │ ◄─── AI Processing
                   │              │
                   │ • Parse      │
                   │ • Process    │
                   │ • Generate   │
                   └──────┬───────┘
                          │
                          │ Response
                          │
                          ▼
                   ┌──────────────┐
                   │ Bot Response │
                   │ (JSON)       │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Save to      │
                   │ SQLite       │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Update UI    │
                   │ (ChatCubit)  │
                   └──────────────┘
                          │
                          ▼
                   User Sees Reply ✓
```

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    CLEAN ARCHITECTURE                       │
└─────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────┐
│  PRESENTATION LAYER (UI)                              │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐  │
│  │   Pages     │  │   Widgets    │  │   Cubit     │  │
│  │             │  │              │  │   (State)   │  │
│  │ • Onboard   │  │ • Message    │  │ • Auth      │  │
│  │ • Home      │  │   Bubble     │  │ • Chat      │  │
│  │ • Chat      │  │ • Input      │  │             │  │
│  └─────────────┘  └──────────────┘  └─────────────┘  │
└───────────────────────┬───────────────────────────────┘
                        │
                        ▼ calls
┌───────────────────────────────────────────────────────┐
│  DOMAIN LAYER (Business Logic)                       │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐  │
│  │  Entities   │  │  Use Cases   │  │ Repository  │  │
│  │             │  │              │  │ Interfaces  │  │
│  │ • Message   │  │ • Send       │  │ • Chat      │  │
│  │ • User      │  │   Message    │  │ • Auth      │  │
│  │             │  │ • Get        │  │             │  │
│  │             │  │   Messages   │  │             │  │
│  └─────────────┘  └──────────────┘  └─────────────┘  │
└───────────────────────┬───────────────────────────────┘
                        │
                        ▼ implemented by
┌───────────────────────────────────────────────────────┐
│  DATA LAYER (Implementation)                          │
│  ┌─────────────┐  ┌──────────────┐  ┌─────────────┐  │
│  │   Models    │  │ Repositories │  │ Data        │  │
│  │             │  │              │  │ Sources     │  │
│  │ • Message   │  │ • ChatRepo   │  │ • Local     │  │
│  │   Model     │  │   Impl       │  │   (SQLite)  │  │
│  │ • User      │  │ • AuthRepo   │  │ • Remote    │  │
│  │   Model     │  │   Impl       │  │   (n8n API) │  │
│  └─────────────┘  └──────────────┘  └─────────────┘  │
└───────────────────────────────────────────────────────┘
```

## 💾 Database Schema Visual

```
┌─────────────────────────────────────────────────────────────┐
│                     SQLite DATABASE                         │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│            USERS TABLE                   │
├──────────────────────────────────────────┤
│ PK  id              TEXT                 │
│     email           TEXT                 │
│     name            TEXT                 │
│     photo_url       TEXT (nullable)      │
│     auth_provider   TEXT                 │
│     created_at      TEXT                 │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│          MESSAGES TABLE                  │
├──────────────────────────────────────────┤
│ PK  id              TEXT                 │
│     bot_id          TEXT                 │ ◄─── 4 bot types
│     sender          TEXT                 │ ◄─── user | bot
│     content         TEXT                 │
│     image_url       TEXT (nullable)      │
│     audio_url       TEXT (nullable)      │
│     timestamp       TEXT                 │
│     is_sending      INTEGER              │
│     has_error       INTEGER              │
└──────────────────────────────────────────┘
         │
         │ indexed on
         ▼
    (bot_id, timestamp)
```

## 🤖 Bot Configuration

```
┌─────────────────────────────────────────────────────────────┐
│                     BOTS OVERVIEW                           │
└─────────────────────────────────────────────────────────────┘

┌──────────────────┐
│ Balance Tracker  │ ID: balance_tracker
├──────────────────┤ Icon: account_balance_wallet
│ Color: 🟢 Green  │ Purpose: Track expenses & spending
│ #4CAF50          │
└──────────────────┘

┌──────────────────┐
│ Investment Guru  │ ID: investment_guru
├──────────────────┤ Icon: trending_up
│ Color: 🟣 Purple │ Purpose: Investment insights
│ #9C27B0          │
└──────────────────┘

┌──────────────────┐
│ Budget Planner   │ ID: budget_planner
├──────────────────┤ Icon: receipt_long
│ Color: 🔵 Blue   │ Purpose: Budget management
│ #2196F3          │
└──────────────────┘

┌──────────────────┐
│ Fin Tips         │ ID: fin_tips
├──────────────────┤ Icon: lightbulb
│ Color: 🟡 Yellow │ Purpose: Financial tips
│ #FFC107          │
└──────────────────┘
```

## 🔌 n8n Integration

```
┌─────────────────────────────────────────────────────────────┐
│                  n8n WEBHOOK INTEGRATION                    │
└─────────────────────────────────────────────────────────────┘

REQUEST (from App to n8n)
─────────────────────────
POST https://your-n8n-instance.com/webhook/balance-iq

Headers:
  Content-Type: application/json

Body:
{
  "bot_id": "balance_tracker",           ◄─── Bot identifier
  "message": "How much did I spend?",    ◄─── User's question
  "timestamp": "2025-10-25T12:00:00Z",   ◄─── ISO 8601
  "image": "base64...",                  ◄─── Optional
  "audio": "base64..."                   ◄─── Optional
}

         │
         │ n8n processes
         ▼

RESPONSE (from n8n to App)
──────────────────────────
Status: 200 OK

Body:
{
  "id": "msg_12345",                     ◄─── Message ID
  "message": "You spent $250...",        ◄─── Bot response
  "image_url": "https://...",            ◄─── Optional chart
  "audio_url": "https://..."             ◄─── Optional audio
}
```

## 📱 Screen Breakdown

```
┌─────────────────────────────────────────────────────────────┐
│                      SCREEN HIERARCHY                       │
└─────────────────────────────────────────────────────────────┘

MyApp (MaterialApp)
  │
  ├─ OnboardingPage
  │   ├─ Google Sign-In Button
  │   ├─ Apple Sign-In Button (iOS)
  │   └─ App Branding
  │
  ├─ HomePage
  │   ├─ App Bar
  │   │   ├─ Title: "BalanceIQ"
  │   │   └─ Account Icon
  │   │
  │   └─ Bot Selection Grid
  │       ├─ Balance Tracker Button
  │       ├─ Investment Guru Button
  │       ├─ Budget Planner Button
  │       └─ Fin Tips Button
  │
  └─ ChatPage (for each bot)
      ├─ App Bar
      │   ├─ Back Button
      │   ├─ Bot Name
      │   └─ Options Menu
      │
      ├─ Message List
      │   ├─ Welcome Message (empty state)
      │   ├─ Message Bubble (User)
      │   ├─ Message Bubble (Bot)
      │   └─ Typing Indicator
      │
      └─ Chat Input
          ├─ Image Picker Button 📷
          ├─ Audio Recorder Button 🎤
          ├─ Text Input Field 💬
          └─ Send Button ➤
```

## 🎨 Theme System

```
┌─────────────────────────────────────────────────────────────┐
│                       THEME SYSTEM                          │
└─────────────────────────────────────────────────────────────┘

LIGHT MODE                   DARK MODE
──────────                   ─────────
Background: #F5F5F5          Background: #101c22
Surface: #FFFFFF             Surface: #1E1E1E
Text: #000000                Text: #FFFFFF
Bot Bubble: #E0E0E0          Bot Bubble: #283339
User Bubble: #4A90E2         User Bubble: #4A90E2

PRIMARY COLORS (Both Modes)
───────────────────────────
Primary: #4A90E2 (Blue)
Accent: #50E3C2 (Cyan)
```

## 🚀 Deployment Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT PIPELINE                      │
└─────────────────────────────────────────────────────────────┘

Development
     │
     ├─ Code in VSCode
     ├─ Run: flutter run
     ├─ Hot Reload during development
     └─ Test features
     │
     ▼
Testing
     │
     ├─ Run: flutter test
     ├─ Run: flutter analyze
     └─ Manual testing (TESTING.md)
     │
     ▼
Build
     │
     ├─ Android: flutter build apk --release
     ├─ iOS: flutter build ios --release
     └─ Configure signing
     │
     ▼
Deploy
     │
     ├─ Google Play Store (Android)
     └─ Apple App Store (iOS)
```

## 📦 Dependencies Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    KEY DEPENDENCIES                         │
└─────────────────────────────────────────────────────────────┘

STATE MANAGEMENT        NETWORKING           DATABASE
─────────────────      ──────────           ────────
flutter_bloc 8.1.6     dio 5.7.0           sqflite 2.3.3
equatable 2.0.5        http 1.2.2          path_provider 2.1.4

AUTHENTICATION         MEDIA                UTILITIES
──────────────         ─────                ─────────
google_sign_in 6.2.2   image_picker 1.1.2  get_it 8.0.2
sign_in_with_apple     record 5.1.2        uuid 4.5.1
  6.1.3                permission_handler  intl 0.19.0
                         11.3.1            dartz 0.10.1

UI COMPONENTS
─────────────
cached_network_image 3.4.1
shimmer 3.0.0
flutter_svg 2.0.10+1
```

---

**Visual Overview Complete** ✓

This document provides a visual representation of the BalanceIQ app architecture, data flow, and component structure. Use this alongside the other documentation for a complete understanding of the project.
