# Mock Authentication System Guide

**Last Updated**: 2025-11-29
**Status**: ✅ Fully Implemented

## Overview

The mock authentication system provides a complete offline simulation of the backend authentication APIs, allowing you to:

- ✅ Develop and test UI/UX flows without a backend
- ✅ Ensure UI perfectly matches API specifications
- ✅ Work offline during development
- ✅ Test error scenarios and edge cases
- ✅ Validate complete user journeys before real API integration

---

## Quick Start

### Enable Mock Mode

**In `.env` file:**
```bash
MOCK_MODE=true
```

**To switch back to real APIs:**
```bash
MOCK_MODE=false
```

That's it! The dependency injection system automatically registers the mock or real data source based on this flag.

---

## Pre-configured Test Accounts

The mock system comes with 3 test accounts ready to use:

### 1. Regular User
- **Username**: `testuser`
- **Password**: `password123`
- **Email**: `test@example.com`
- **Full Name**: Test User
- **Roles**: user

### 2. Admin User
- **Username**: `admin`
- **Password**: `admin123`
- **Email**: `admin@balanceiq.com`
- **Full Name**: Admin User
- **Roles**: user, admin

### 3. Demo User
- **Username**: `demo`
- **Password**: `demo123`
- **Email**: `demo@balanceiq.com`
- **Full Name**: Demo Account
- **Roles**: user
- **Photo**: https://i.pravatar.cc/150?u=demo

---

## Supported Features

### ✅ Email/Password Authentication

#### 1. **Signup** - `POST /api/auth/signup`

**Mock Behavior:**
- Validates username, email, password
- Checks for duplicate username/email
- Creates new user in memory
- Returns success without auto-login (requires email verification)
- Simulates 300-800ms network delay

**Test Cases:**
```dart
// Success
signup(username: 'newuser', password: 'pass123', email: 'new@example.com', fullName: 'New User')
// ✅ Returns: AuthResponse(success: true, message: 'Account created...')

// Duplicate username
signup(username: 'testuser', ...)
// ❌ Throws: Exception('User already exists')

// Duplicate email
signup(email: 'test@example.com', ...)
// ❌ Throws: Exception('Email already registered')

// Invalid email
signup(email: 'invalid-email', ...)
// ❌ Throws: Exception('Invalid email format')

// Short password
signup(password: '123', ...)
// ❌ Throws: Exception('Password must be at least 6 characters')
```

#### 2. **Login** - `POST /api/auth/login`

**Mock Behavior:**
- Validates credentials against stored users
- Generates mock JWT token
- Stores token in SharedPreferences
- Returns user info with token

**Test Cases:**
```dart
// Success
login(username: 'testuser', password: 'password123')
// ✅ Returns: AuthResponse with token and user info

// Wrong password
login(username: 'testuser', password: 'wrongpass')
// ❌ Throws: Exception('Invalid username or password')

// User not found
login(username: 'nonexistent', password: 'anypass')
// ❌ Throws: Exception('User not found')
```

#### 3. **Get Profile** - `GET /api/auth/me`

**Mock Behavior:**
- Validates JWT token
- Extracts user ID from token
- Returns user profile data

**Test Cases:**
```dart
// Success
getProfile('valid_mock_token')
// ✅ Returns: UserInfo object

// Invalid token
getProfile('invalid_token')
// ❌ Throws: Exception('Invalid token format')

// Empty token
getProfile('')
// ❌ Throws: Exception('Unauthorized. Please login again.')
```

#### 4. **Change Password** - `POST /api/auth/change-password`

**Mock Behavior:**
- Validates JWT token
- Verifies current password
- Checks new password matches confirmation
- Updates password in memory

**Test Cases:**
```dart
// Success
changePassword(
  currentPassword: 'password123',
  newPassword: 'newpass123',
  confirmPassword: 'newpass123',
  token: 'valid_token'
)
// ✅ Success (void return)

// Wrong current password
changePassword(currentPassword: 'wrongpass', ...)
// ❌ Throws: Exception('Current password is incorrect')

// Passwords don't match
changePassword(newPassword: 'pass1', confirmPassword: 'pass2', ...)
// ❌ Throws: Exception('Passwords do not match')

// Short new password
changePassword(newPassword: '123', confirmPassword: '123', ...)
// ❌ Throws: Exception('Password must be at least 6 characters')
```

#### 5. **Forgot Password** - `POST /api/auth/forgot-password`

**Mock Behavior:**
- Validates email format
- Checks if email exists
- Generates reset token
- Prints token to console (simulates email sending)

**Test Cases:**
```dart
// Success
forgotPassword(email: 'test@example.com')
// ✅ Success (void return)
// 📧 Console: "Reset token: {uuid}" and "Reset link: /reset-password?token={uuid}"

// Email not found
forgotPassword(email: 'notfound@example.com')
// ❌ Throws: Exception('Email not found')

// Invalid email
forgotPassword(email: 'invalid-email')
// ❌ Throws: Exception('Invalid email format')
```

**How to Use Reset Token:**
1. Check console output for reset token
2. Copy the token UUID
3. Use it to test reset password flow

#### 6. **Reset Password** - `POST /api/auth/reset-password`

**Mock Behavior:**
- Validates token
- Checks passwords match
- Updates user password
- Removes used token

**Test Cases:**
```dart
// Success (use token from forgot password)
resetPassword(
  token: '{reset_token_from_console}',
  newPassword: 'newpass123',
  confirmPassword: 'newpass123'
)
// ✅ Success (void return)

// Invalid/expired token
resetPassword(token: 'invalid-token', ...)
// ❌ Throws: Exception('Invalid or expired reset token')

// Passwords don't match
resetPassword(newPassword: 'pass1', confirmPassword: 'pass2', ...)
// ❌ Throws: Exception('Passwords do not match')
```

---

### ✅ OAuth Authentication

#### Google Sign-In

**Mock Behavior:**
- Simulates Google OAuth flow
- Creates user with Google provider
- Returns mock Google user data

**Mock User Data:**
```dart
UserModel(
  id: '{uuid}',
  email: 'mockgoogle@gmail.com',
  name: 'Mock Google User',
  photoUrl: 'https://i.pravatar.cc/150?u=google',
  authProvider: 'google',
)
```

#### Apple Sign-In

**Mock Behavior:**
- Simulates Apple Sign In with Apple flow
- Creates user with Apple provider
- Returns mock Apple user data

**Mock User Data:**
```dart
UserModel(
  id: '{uuid}',
  email: 'mockapple@privaterelay.appleid.com',
  name: 'Mock Apple User',
  photoUrl: null,
  authProvider: 'apple',
)
```

---

## Mock Implementation Details

### File Location
```
lib/features/auth/data/datasources/auth_mock_datasource.dart
```

### In-Memory Storage

The mock system stores users in static memory:

```dart
static final Map<String, _MockUser> _users = {};
static final Map<String, String> _resetTokens = {}; // token -> email
```

**Important Notes:**
- Data persists during app session
- Cleared when app restarts
- Use `AuthMockDataSource.clearAllData()` to reset manually

### Network Delay Simulation

All operations have realistic delays (300-800ms):

```dart
Future<void> _simulateDelay() async {
  await Future.delayed(
    Duration(milliseconds: 300 + (DateTime.now().millisecond % 500)),
  );
}
```

### JWT Token Format

Mock tokens use a simple format for testing:

```
mock_token_{userId}_{timestamp}
```

**Example**: `mock_token_user_001_1732896000000`

This is NOT a real JWT, but mimics token structure for testing purposes.

---

## Complete User Journey Testing

### Journey 1: New User Registration

```
1. Signup (/signup page)
   - Username: mynewuser
   - Password: mypass123
   - Email: mynew@example.com
   - Full Name: My New User

2. Check console for mock behavior logs

3. Email Verification Page (/email-verification)
   - Mock: Auto-succeeds after delay

4. Login (/login page)
   - Username: mynewuser
   - Password: mypass123

5. Redirected to Home (/home)
```

### Journey 2: Existing User Login

```
1. Login (/login page)
   - Username: testuser
   - Password: password123

2. Redirected to Home (/home)

3. Access Profile (/profile)
   - Tap profile icon in app bar

4. Change Password
   - Current: password123
   - New: newpass123
   - Confirm: newpass123

5. Logout

6. Login with new password
   - Username: testuser
   - Password: newpass123
```

### Journey 3: Password Reset

```
1. Login page → "Forgot Password?" link

2. Forgot Password page
   - Email: test@example.com

3. Check console for reset token
   📧 Console output:
   🔐 [MOCK] Password reset token: {uuid}
   📧 [MOCK] Reset link: /reset-password?token={uuid}

4. Copy the token UUID

5. Navigate to: /reset-password?token={uuid}
   - New Password: resetpass123
   - Confirm: resetpass123

6. Login with new password
   - Username: testuser
   - Password: resetpass123
```

### Journey 4: OAuth Sign-In

```
1. Login/Signup page

2. Tap "Google" button
   - Mock creates Google user automatically

3. OR Tap "Apple" button
   - Mock creates Apple user automatically

4. Redirected to Home
```

---

## Testing Error Scenarios

### Signup Errors

```dart
// Test duplicate username
signup(username: 'testuser', ...)
// Expected: "User already exists" error message

// Test duplicate email
signup(email: 'test@example.com', ...)
// Expected: "Email already registered" error message

// Test invalid email
signup(email: 'not-an-email', ...)
// Expected: "Invalid email format" error message

// Test short password
signup(password: '12345', ...)
// Expected: "Password must be at least 6 characters" error message
```

### Login Errors

```dart
// Test wrong password
login(username: 'testuser', password: 'wrongpass')
// Expected: "Invalid username or password" error message

// Test non-existent user
login(username: 'nonexistent', password: 'anypass')
// Expected: "User not found" error message
```

### Password Change Errors

```dart
// Test wrong current password
changePassword(currentPassword: 'wrongpass', ...)
// Expected: "Current password is incorrect" error message

// Test mismatched new passwords
changePassword(newPassword: 'pass1', confirmPassword: 'pass2', ...)
// Expected: "Passwords do not match" error message
```

---

## Console Debug Output

When mock mode is enabled, you'll see helpful console output:

```bash
# On app startup
🎭 [DI] Registering MOCK AuthRemoteDataSource

# On signup
🎭 [MOCK] New user created: newuser (new@example.com)

# On login
🎭 [MOCK] Login successful: testuser
🎭 [MOCK] Token generated: mock_token_user_001_1732896000000

# On forgot password
🔐 [MOCK] Password reset token: f47ac10b-58cc-4372-a567-0e02b2c3d479
📧 [MOCK] Reset link: /reset-password?token=f47ac10b-58cc-4372-a567-0e02b2c3d479

# On password change
🔐 [MOCK] Password changed for user: testuser

# On logout
👋 [MOCK] User logged out
```

---

## Debugging Tools

### Get All Stored Users

```dart
final users = AuthMockDataSource.getStoredUsers();
print('Stored users: $users');
```

### Get Active Reset Tokens

```dart
final tokens = AuthMockDataSource.getResetTokens();
print('Reset tokens: $tokens');
```

### Clear All Mock Data

```dart
AuthMockDataSource.clearAllData();
// Clears all users and reset tokens
// Useful for resetting to initial state during testing
```

---

## Switching to Real APIs

### Step 1: Update Environment

```bash
# In .env file
MOCK_MODE=false
```

### Step 2: Hot Reload/Restart

```bash
# Hot reload
r

# Or full restart
R
```

### Step 3: Verify

Check console output:
```bash
🌐 [DI] Registering REAL AuthRemoteDataSource
```

### Step 4: Configure Backend URL

```bash
# In .env file
BACKEND_BASE_URL=https://your-backend-api.com
```

---

## API Contract Validation

The mock implementation follows the exact same contract as the real API:

| Feature | Mock Matches Real API | Notes |
|---------|----------------------|-------|
| Request Models | ✅ Yes | Uses same SignupRequest, LoginRequest, etc. |
| Response Models | ✅ Yes | Returns same AuthResponse, UserInfo structures |
| Error Messages | ✅ Yes | Throws same exception types and messages |
| Token Format | ⚠️ Simplified | Real uses JWT, mock uses simple format |
| Network Delays | ✅ Simulated | 300-800ms realistic delays |
| Validation Logic | ✅ Yes | Same password length, email format checks |

---

## Benefits of Mock-First Development

### 1. **Faster Development**
- No backend dependency
- Instant feedback
- Work offline

### 2. **Better Testing**
- Test all error scenarios
- Consistent test data
- Reproducible states

### 3. **Confident Integration**
- UI already matches API specs
- Easy to swap mock → real
- Reduced integration bugs

### 4. **Improved UX**
- Test complete user journeys
- Validate error messages
- Perfect flows before launch

---

## Common Workflows

### Workflow 1: Building New Auth Feature

```
1. Enable MOCK_MODE=true
2. Build UI using mock data
3. Test all user journeys
4. Test all error scenarios
5. Verify against API specs
6. Switch to MOCK_MODE=false
7. Test with real backend
8. Fix any integration issues
```

### Workflow 2: Testing Auth Flows

```
1. Enable MOCK_MODE=true
2. Create test account
3. Test signup → verify → login flow
4. Test password change flow
5. Test password reset flow
6. Test OAuth flows
7. Test logout and re-login
8. Verify persistence across app restarts
```

### Workflow 3: Debugging Auth Issues

```
1. Enable MOCK_MODE=true
2. Reproduce the issue with mock
3. Check console debug output
4. Use debugging tools to inspect state
5. Fix the issue
6. Test with mock
7. Switch to real API and verify fix
```

---

## Troubleshooting

### Issue: "User not found" after creating account

**Cause**: Mock data is cleared on app restart
**Solution**: Re-create user or use pre-configured test accounts

### Issue: Reset token not working

**Cause**: Token already used or app restarted
**Solution**: Request new password reset token

### Issue: OAuth not working in mock mode

**Cause**: Mock OAuth creates generic mock users
**Solution**: This is expected - mock OAuth is simplified for testing

### Issue: Changes not persisting

**Cause**: Mock uses in-memory storage
**Solution**: Data is session-only by design for testing

---

## Next Steps

After mock testing is successful:

1. ✅ All UI/UX flows work perfectly
2. ✅ All error scenarios handled
3. ✅ User journeys validated
4. 🔄 Switch to `MOCK_MODE=false`
5. 🔄 Configure real backend URL
6. 🔄 Test with real API
7. 🔄 Fix any integration differences
8. 🚀 Ready for production!

---

## Files Reference

**Mock Implementation:**
- `lib/features/auth/data/datasources/auth_mock_datasource.dart`

**Dependency Injection:**
- `lib/core/di/injection_container.dart` (lines 124-143)

**Environment Config:**
- `.env` (MOCK_MODE flag)

**Request/Response Models:**
- `lib/features/auth/data/models/auth_request_models.dart`

**UI Pages:**
- `lib/features/auth/presentation/pages/new_login_page.dart`
- `lib/features/auth/presentation/pages/new_signup_page.dart`
- `lib/features/auth/presentation/pages/forgot_password_page.dart`
- `lib/features/auth/presentation/pages/reset_password_page.dart`
- `lib/features/auth/presentation/pages/change_password_page.dart`
- `lib/features/auth/presentation/pages/profile_page.dart`

---

**Happy Testing! 🎭**
