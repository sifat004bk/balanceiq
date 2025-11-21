# Mock Data Environment

This directory contains mock implementations for testing the BalanceIQ app without requiring real API calls.

## Purpose

The mock environment allows you to:
- Test the Gemini-style chat interface with realistic responses
- Develop and debug UI/UX without backend dependencies
- Demo the app with pre-populated data
- Run integration tests without hitting real endpoints

## Quick Start

### Enable Mock Mode

1. Open `.env` file in the project root
2. Set `MOCK_MODE=true`
3. Restart the app

```bash
# .env
MOCK_MODE=true
```

### Disable Mock Mode

1. Open `.env` file
2. Set `MOCK_MODE=false`
3. Restart the app

```bash
# .env
MOCK_MODE=false
```

## Files

### `mock_data.dart`
Contains all mock response data:
- **Chat Responses**: Pre-written bot responses for each bot type
  - Balance Tracker: Expense tracking, balance queries, income recording
  - Investment Guru: Investment tips, stock advice, portfolio guidance
  - Budget Planner: Budget creation, category analysis, savings tips
  - Fin Tips: Money management tips, financial education
- **Dashboard Data**: Mock financial summary with:
  - Balance: 45,500 BDT
  - Monthly income: 50,000 BDT
  - Monthly expenses: 4,500 BDT
  - Category breakdown
  - Recent transactions
  - Insights and alerts

### `../features/chat/data/datasources/chat_mock_datasource.dart`
Mock implementation of `ChatRemoteDataSource`:
- Simulates network delay (300-800ms)
- Returns contextual responses based on user input
- Supports all bot types

### `../features/home/data/datasource/remote_datasource/dashboard_mock_datasource.dart`
Mock implementation of `DashboardRemoteDataSource`:
- Simulates network delay (500-1000ms)
- Returns consistent dashboard summary data

## How It Works

### Dependency Injection

The app uses GetIt for dependency injection. When `MOCK_MODE=true`, the DI container registers mock datasources instead of real ones:

```dart
// lib/core/di/injection_container.dart
sl.registerLazySingleton<ChatRemoteDataSource>(
  () {
    if (AppConstants.isMockMode) {
      return ChatMockDataSource();  // Uses mock data
    } else {
      return ChatRemoteDataSourceImpl(sl(), sl());  // Uses real API
    }
  },
);
```

### Message Flow (Mock Mode)

1. User sends message via `ChatInput` widget
2. `ChatCubit` calls `SendMessage` use case
3. Use case calls `ChatRepository`
4. Repository calls `ChatMockDataSource` (instead of real datasource)
5. Mock datasource:
   - Simulates network delay
   - Analyzes user message
   - Returns contextual response from `MockData`
6. Response flows back through layers
7. UI displays bot response with Gemini styling

## Customizing Mock Responses

### Adding New Responses

Edit `lib/core/mock/mock_data.dart`:

```dart
case AppConstants.balanceTrackerID:
  return {
    'general': [
      'Your new custom response here',
      'Another response option',
    ],
    'custom_category': [
      'Response for specific keywords',
    ],
  };
```

### Context-Aware Responses

The `getResponse()` method checks user message content:

```dart
if (lowerMessage.contains('balance')) {
  return responses['balance']!.first;
}
```

Add your own conditions to make responses more intelligent.

### Modifying Dashboard Data

Edit the `getMockDashboardSummary()` method:

```dart
'summary': {
  'total_balance': 45500.0,  // Change this
  'monthly_income': 50000.0, // Change this
  // ... more fields
},
```

## Testing Different Scenarios

### Test Error Handling

Modify mock datasource to throw errors:

```dart
// In chat_mock_datasource.dart
throw Exception('Mock network error');
```

### Test Loading States

Increase network delay:

```dart
await Future.delayed(Duration(seconds: 5));
```

### Test Empty States

Return empty message list or dashboard data.

## Network Delay Simulation

Mock datasources simulate realistic network delays:
- **Chat**: 300-800ms (random)
- **Dashboard**: 500-1000ms (random)

This helps test loading indicators and user experience during network requests.

## Debug Output

When mock mode is enabled, you'll see debug prints:

```
🎭 [DI] Registering MOCK ChatRemoteDataSource
🎭 [DI] Registering MOCK DashboardRemoteDataSource
🤖 [MockDataSource] Sending message to bot: balance_tracker
📝 [MockDataSource] Message content: What is my balance?
✅ [MockDataSource] Mock response generated
```

## Switching Between Modes

You can switch between mock and real modes without code changes:

1. **Development**: `MOCK_MODE=true` (test UI quickly)
2. **Integration Testing**: `MOCK_MODE=false` (test with real backend)
3. **Production**: `MOCK_MODE=false` (always use real API)

## Best Practices

1. **Keep mock data realistic**: Use actual formats and reasonable values
2. **Update mocks with API changes**: When real API responses change, update mocks
3. **Don't commit with MOCK_MODE=true**: Ensure `.env` has `MOCK_MODE=false` before committing
4. **Test both modes**: Verify app works in both mock and real modes
5. **Use mocks for UI demos**: Great for stakeholder presentations

## Troubleshooting

### Mock mode not working?

1. Check `.env` has `MOCK_MODE=true`
2. Restart the app completely (hot restart may not reload .env)
3. Check console for `🎭 [DI] Registering MOCK` messages

### Responses seem outdated?

1. Update `lib/core/mock/mock_data.dart`
2. Hot restart the app

### Want to test specific scenarios?

1. Modify mock datasources to return specific data
2. Add conditional logic based on input parameters

## Example Usage

```dart
// Chat with Balance Tracker (mock mode)
User: "I spent 500 taka on groceries"
Bot: "✅ Expense recorded successfully!

     Transaction Details:
     - Amount: 500 BDT
     - Category: Auto-detected
     - Remaining Balance: 45,000 BDT"

// Query balance
User: "What is my balance?"
Bot: "💰 Your current financial status:

     Total Balance: 45,500 BDT
     This Month:
     - Income: 50,000 BDT
     - Expenses: 4,500 BDT
     - Savings: 45,500 BDT (91%)"
```

## Future Enhancements

- [ ] Add image/audio mock responses
- [ ] Create multiple user profiles with different data
- [ ] Add time-based responses (different data based on time of day)
- [ ] Mock error scenarios (network failures, timeouts)
- [ ] Add mock authentication flows
