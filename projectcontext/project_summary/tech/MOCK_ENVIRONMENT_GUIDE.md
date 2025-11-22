# Mock Environment - Quick Start Guide

## ✅ What Was Created

### 1. Mock Data & Infrastructure (3 files)
- **lib/core/mock/mock_data.dart** (295 lines)
  - Realistic chat responses for all 4 bots
  - Mock dashboard with financial data
  - Context-aware response selection

- **lib/features/chat/data/datasources/chat_mock_datasource.dart** (47 lines)
  - Mock chat API with 300-800ms delay
  - Contextual bot responses

- **lib/features/home/data/datasource/remote_datasource/dashboard_mock_datasource.dart** (36 lines)
  - Mock dashboard API with 500-1000ms delay
  - Consistent financial summary

### 2. Configuration Updates
- **.env** - Added `MOCK_MODE=true`
- **.env.example** - Added `MOCK_MODE=false` template
- **lib/core/constants/app_constants.dart** - Added `isMockMode` getter
- **lib/core/di/injection_container.dart** - Conditional DI registration

### 3. Documentation
- **lib/core/mock/README.md** - Complete mock system documentation

## 🚀 How to Use

### Enable Mock Mode (Default)
Mock mode is **already enabled** in your `.env`:

```bash
MOCK_MODE=true
```

Just run the app and you'll see:
- 🎭 Mock datasources registered (check console logs)
- Instant bot responses without real API calls
- Pre-populated dashboard data

### Disable Mock Mode
To use real API endpoints:

1. Edit `.env`
2. Change `MOCK_MODE=true` to `MOCK_MODE=false`
3. Restart app

```bash
MOCK_MODE=false
```

## 📱 Testing the Chat Interface

### Balance Tracker Bot
Try these messages:

```
User: "What is my balance?"
Bot: 💰 Your current financial status:
     Total Balance: 45,500 BDT
     This Month:
     - Income: 50,000 BDT
     - Expenses: 4,500 BDT
     - Savings: 45,500 BDT (91%)

User: "I spent 500 taka on lunch"
Bot: ✅ Expense recorded successfully!
     Transaction Details:
     - Amount: 500 BDT
     - Category: Auto-detected
     - Remaining Balance: 45,000 BDT

User: "I received salary of 50,000 taka"
Bot: 🎉 Income added to your account!
     Transaction Details:
     - Amount: 50,000 BDT
     - New Balance: 95,000 BDT
```

### Investment Guru Bot
Try these:

```
"What are good investment options for beginners?"
"Should I invest in stocks or mutual funds?"
"How should I diversify my portfolio?"
"What are the current market trends?"
```

### Budget Planner Bot
Try these:

```
"Help me create a monthly budget"
"Show me my spending by category"
"How can I save 20% of my income?"
"Am I overspending?"
```

### Fin Tips Bot
Try these:

```
"Give me money management tips"
"Explain compound interest"
"How much emergency fund do I need?"
"Credit card best practices"
```

## 🎨 Mock Data Highlights

### Dashboard Summary
- **Total Income**: 50,000 BDT
- **Total Expenses**: 4,500 BDT
- **Net Balance**: 45,500 BDT
- **Savings Rate**: 91%
- **Expense Ratio**: 9%

### Transaction Stats
- Income Transactions: 2
- Expense Transactions: 8
- Average Income: 25,000 BDT
- Average Expense: 562.50 BDT

### Category Breakdown
1. Food & Dining - 2,500 BDT (Biggest category)
2. Transportation - 1,000 BDT
3. Shopping - 800 BDT
4. Entertainment - 150 BDT
5. Others - 50 BDT

### Accounts Breakdown
- Cash: 5,500 BDT
- Bank: 35,000 BDT
- Mobile Banking: 5,000 BDT

### Biggest Expense
- Amount: 1,200 BDT
- Description: Clothing purchase at shopping mall
- Category: Shopping
- Account: Bank

### Spending Trend (Last 7 Days)
Day 1: 450 BDT → Day 7: 900 BDT (showing increase)

## 🔄 Switching Modes

### For UI Development
```bash
MOCK_MODE=true  # Fast, no backend needed
```

### For API Integration Testing
```bash
MOCK_MODE=false  # Test with real n8n webhooks
```

### For Production
```bash
MOCK_MODE=false  # Always use real API
```

## 🐛 Debug Output

When mock mode is enabled, console shows:

```
🎭 [DI] Registering MOCK ChatRemoteDataSource
🎭 [DI] Registering MOCK DashboardRemoteDataSource
🤖 [MockDataSource] Sending message to bot: balance_tracker
📝 [MockDataSource] Message content: What is my balance?
✅ [MockDataSource] Mock response generated
🏠 [MockDashboard] Fetching dashboard for user: 6130001838
✅ [MockDashboard] Mock dashboard data generated
```

## 🎯 Benefits

### For Development
- ✅ No backend dependency
- ✅ Instant responses
- ✅ Predictable data
- ✅ Easy UI testing

### For Testing
- ✅ Test loading states (adjust delay)
- ✅ Test error handling (throw exceptions)
- ✅ Test edge cases (modify mock data)
- ✅ Integration tests without real API

### For Demos
- ✅ Consistent presentation data
- ✅ No API keys needed
- ✅ Works offline
- ✅ Professional looking responses

## 📝 Customization

### Add New Response
Edit `lib/core/mock/mock_data.dart`:

```dart
'general': [
  'Your new response here',
  'Another option',
],
```

### Change Dashboard Data
Edit `getMockDashboardSummary()`:

```dart
'summary': {
  'total_balance': 100000.0,  // Your value
  'monthly_income': 80000.0,   // Your value
  // ...
},
```

### Adjust Network Delay
Edit mock datasources:

```dart
// Faster
await Future.delayed(Duration(milliseconds: 100));

// Slower
await Future.delayed(Duration(seconds: 3));
```

## ✅ Build Status

- Flutter Analyze: ✅ No errors
- Build APK: ✅ Success
- Mock Datasources: ✅ Registered
- DI Container: ✅ Configured

## 📚 Full Documentation

See `lib/core/mock/README.md` for detailed documentation.

## 🎨 Gemini UI Testing

Perfect for testing the new Gemini-style chat interface:
- Suggested prompts work immediately
- Message animations visible
- Typing indicator appears
- No waiting for real API
- Beautiful UI with realistic content

---

**Current Status**: Mock mode is **ENABLED** and ready to use! 🎉
