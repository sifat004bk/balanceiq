# UI Authentication Layer Implementation Plan
## Ultra Thick Mode - Comprehensive Implementation Guide

**Created**: 2025-11-22
**Purpose**: Detailed plan for integrating backend authentication APIs into the UI layer
**Status**: Ready for implementation

---

## Executive Summary

### Current State
- ✅ Backend APIs implemented (6 auth endpoints + 1 chat history)
- ✅ Domain layer complete (all use cases created)
- ✅ Data layer complete (remote data sources, repositories)
- ❌ Presentation layer NOT synced with backend
- ❌ Login/Signup pages using mock implementations
- ❌ Password management pages don't exist

### Target State
- ✅ AuthCubit with all 6 backend API methods
- ✅ Login page calling real backend API
- ✅ Signup page calling real backend API
- ✅ Forgot Password page created and functional
- ✅ Reset Password page created and functional
- ✅ Change Password page created and functional
- ✅ Proper error handling and loading states
- ✅ Navigation flow complete

### Effort Estimate
**Total**: 14.5 hours (3 phases)
- Phase 1 (State Management): 4.5 hours
- Phase 2 (Fix Existing Pages): 5.5 hours
- Phase 3 (New Pages): 4.5 hours

---

## Analysis of Current Implementation

### 1. AuthCubit (lib/features/auth/presentation/cubit/auth_cubit.dart)

**Current Dependencies**:
```dart
class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUser;

  // Missing 6 backend use cases!
}
```

**Current Methods**:
- ✅ `checkAuthStatus()` - Works with local storage
- ✅ `signInGoogle()` - Keep as-is (OAuth)
- ✅ `signInApple()` - Keep as-is (OAuth)
- ✅ `logout()` - Works fine
- ❌ `signInWithMock()` - DELETE THIS (lines 67-83)

**Missing Methods** (need to add):
1. `loginWithEmail(username, password)` - Call backend login API
2. `signupWithEmail(username, password, fullName, email)` - Call backend signup API
3. `getUserProfile()` - Get user profile from backend
4. `changePassword(currentPassword, newPassword, confirmPassword)` - Change password
5. `requestPasswordReset(email)` - Forgot password flow
6. `resetPassword(token, newPassword, confirmPassword)` - Reset with token

### 2. AuthState (lib/features/auth/presentation/cubit/auth_state.dart)

**Current States**:
```dart
- AuthInitial
- AuthLoading
- AuthAuthenticated(User user)
- AuthUnauthenticated
- AuthError(String message)
```

**Assessment**: Current states are sufficient! We can reuse them for all operations.
- `AuthLoading` works for all loading states
- `AuthAuthenticated` works for successful login/signup
- `AuthError` works for all errors
- For password operations, we may need additional states

**New States to Add**:
```dart
class PasswordResetEmailSent extends AuthState {
  final String email;
  const PasswordResetEmailSent(this.email);
}

class PasswordChanged extends AuthState {}

class PasswordResetSuccess extends AuthState {}
```

### 3. Login Page (lib/features/auth/presentation/pages/new_login_page.dart)

**Current Issue** (lines 27-35):
```dart
void _handleLogin() {
  if (_formKey.currentState!.validate()) {
    // Mock login - always succeeds ❌
    context.read<AuthCubit>().signInWithMock(
          email: _emailController.text,
          name: 'User',
        );
  }
}
```

**Required Fix**:
```dart
void _handleLogin() {
  if (_formKey.currentState!.validate()) {
    // Extract username from email (before @)
    final username = _emailController.text.contains('@')
        ? _emailController.text.split('@').first
        : _emailController.text;

    // Call real backend login API ✅
    context.read<AuthCubit>().loginWithEmail(
      username: username,
      password: _passwordController.text,
    );
  }
}
```

**Additional Fix** (line 240-242):
```dart
// Current: TODO comment
TextButton(
  onPressed: () {
    // TODO: Navigate to forgot password
  },
  ...
)

// Fix: Navigate to forgot password page
TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/forgot-password');
  },
  ...
)
```

### 4. Signup Page (lib/features/auth/presentation/pages/new_signup_page.dart)

**Current Issue** (lines 32-40):
```dart
void _handleSignUp() {
  if (_formKey.currentState!.validate()) {
    // Navigate to email verification page ❌
    // Does NOT call backend API!
    Navigator.pushNamed(
      context,
      '/email-verification',
      arguments: _emailController.text,
    );
  }
}
```

**Required Fix**:
```dart
void _handleSignUp() {
  if (_formKey.currentState!.validate()) {
    // Extract username from email
    final username = _emailController.text.split('@').first;

    // Call backend signup API ✅
    context.read<AuthCubit>().signupWithEmail(
      username: username,
      password: _passwordController.text,
      fullName: _nameController.text,
      email: _emailController.text,
    );
  }
}
```

**BlocListener Update**:
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // After successful signup, navigate to home or verification
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  ...
)
```

### 5. Password Management Pages

**Status**: ❌ DO NOT EXIST

**Need to Create**:
1. `lib/features/auth/presentation/pages/forgot_password_page.dart`
2. `lib/features/auth/presentation/pages/reset_password_page.dart`
3. `lib/features/auth/presentation/pages/change_password_page.dart`

### 6. Dependency Injection (lib/core/di/injection_container.dart)

**Current Registration** (lines 84-99):
```dart
sl.registerFactory(
  () => AuthCubit(
    signInWithGoogle: sl(),
    signInWithApple: sl(),
    signOutUseCase: sl(),
    getCurrentUser: sl(),
    // Missing 6 use cases! ❌
  ),
);

// Use cases registered but not injected
sl.registerLazySingleton(() => Signup(sl()));
sl.registerLazySingleton(() => Login(sl()));
sl.registerLazySingleton(() => GetProfile(sl()));
sl.registerLazySingleton(() => ChangePassword(sl()));
sl.registerLazySingleton(() => ForgotPassword(sl()));
sl.registerLazySingleton(() => ResetPassword(sl()));
```

**Required Fix**:
```dart
sl.registerFactory(
  () => AuthCubit(
    signInWithGoogle: sl(),
    signInWithApple: sl(),
    signOutUseCase: sl(),
    getCurrentUser: sl(),
    // Add backend use cases ✅
    signup: sl(),
    login: sl(),
    getProfile: sl(),
    changePassword: sl(),
    forgotPassword: sl(),
    resetPassword: sl(),
  ),
);
```

---

## Phase 1: Update State Management (4.5 hours)

### Task 1.1: Update auth_state.dart (30 min)

**File**: `lib/features/auth/presentation/cubit/auth_state.dart`

**Add new states**:
```dart
// Add after AuthError class

class PasswordResetEmailSent extends AuthState {
  final String email;

  const PasswordResetEmailSent(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthState {}

class PasswordResetSuccess extends AuthState {}

class SignupSuccess extends AuthState {
  final String email;

  const SignupSuccess(this.email);

  @override
  List<Object?> get props => [email];
}
```

**Why**: These states allow UI to react to specific password operations.

### Task 1.2: Update AuthCubit Constructor (30 min)

**File**: `lib/features/auth/presentation/cubit/auth_cubit.dart`

**Current** (lines 10-21):
```dart
class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUser;

  AuthCubit({
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.signOutUseCase,
    required this.getCurrentUser,
  }) : super(AuthInitial());
```

**Updated**:
```dart
import '../../domain/usecases/signup.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/reset_password.dart';

class AuthCubit extends Cubit<AuthState> {
  // Keep existing OAuth dependencies
  final SignInWithGoogle signInWithGoogle;
  final SignInWithApple signInWithApple;
  final SignOut signOutUseCase;
  final GetCurrentUser getCurrentUser;

  // Add backend API dependencies
  final Signup signup;
  final Login login;
  final GetProfile getProfile;
  final ChangePassword changePassword;
  final ForgotPassword forgotPassword;
  final ResetPassword resetPassword;

  AuthCubit({
    // OAuth dependencies
    required this.signInWithGoogle,
    required this.signInWithApple,
    required this.signOutUseCase,
    required this.getCurrentUser,
    // Backend API dependencies
    required this.signup,
    required this.login,
    required this.getProfile,
    required this.changePassword,
    required this.forgotPassword,
    required this.resetPassword,
  }) : super(AuthInitial());
```

### Task 1.3: Add loginWithEmail method (45 min)

**Add to AuthCubit**:
```dart
/// Login with email/username and password using backend API
Future<void> loginWithEmail({
  required String username,
  required String password,
}) async {
  emit(AuthLoading());

  final result = await login(
    username: username,
    password: password,
  );

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (authResponse) {
      if (authResponse.success && authResponse.user != null) {
        // Convert UserInfo to User entity
        final user = User(
          id: authResponse.user!.id,
          email: authResponse.user!.email,
          name: authResponse.user!.fullName,
          photoUrl: authResponse.user!.photoUrl,
          authProvider: 'email',
          createdAt: DateTime.now(),
        );

        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError(authResponse.message ?? 'Login failed'));
      }
    },
  );
}
```

**Why**: Converts backend AuthResponse to domain User entity.

### Task 1.4: Add signupWithEmail method (45 min)

**Add to AuthCubit**:
```dart
/// Sign up with email and password using backend API
Future<void> signupWithEmail({
  required String username,
  required String password,
  required String fullName,
  required String email,
}) async {
  emit(AuthLoading());

  final result = await signup(
    username: username,
    password: password,
    fullName: fullName,
    email: email,
  );

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (authResponse) {
      if (authResponse.success) {
        // Option 1: Auto-login after signup
        if (authResponse.user != null) {
          final user = User(
            id: authResponse.user!.id,
            email: authResponse.user!.email,
            name: authResponse.user!.fullName,
            photoUrl: authResponse.user!.photoUrl,
            authProvider: 'email',
            createdAt: DateTime.now(),
          );
          emit(AuthAuthenticated(user));
        } else {
          // Option 2: Show success, require email verification
          emit(SignupSuccess(email));
        }
      } else {
        emit(AuthError(authResponse.message ?? 'Signup failed'));
      }
    },
  );
}
```

### Task 1.5: Add password management methods (2 hours)

**Add to AuthCubit**:
```dart
/// Get current user profile from backend
Future<void> getUserProfile() async {
  emit(AuthLoading());

  final result = await getProfile();

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (authResponse) {
      if (authResponse.success && authResponse.user != null) {
        final user = User(
          id: authResponse.user!.id,
          email: authResponse.user!.email,
          name: authResponse.user!.fullName,
          photoUrl: authResponse.user!.photoUrl,
          authProvider: 'email',
          createdAt: DateTime.now(),
        );
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Failed to load profile'));
      }
    },
  );
}

/// Change password for currently authenticated user
Future<void> changeUserPassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  emit(AuthLoading());

  final result = await changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
    confirmPassword: confirmPassword,
  );

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (authResponse) {
      if (authResponse.success) {
        emit(PasswordChanged());
        // Optionally re-emit authenticated state
        // or require re-login for security
      } else {
        emit(AuthError(authResponse.message ?? 'Failed to change password'));
      }
    },
  );
}

/// Request password reset email
Future<void> requestPasswordReset({required String email}) async {
  emit(AuthLoading());

  final result = await forgotPassword(email: email);

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (authResponse) {
      if (authResponse.success) {
        emit(PasswordResetEmailSent(email));
      } else {
        emit(AuthError(authResponse.message ?? 'Failed to send reset email'));
      }
    },
  );
}

/// Reset password with token from email
Future<void> resetUserPassword({
  required String token,
  required String newPassword,
  required String confirmPassword,
}) async {
  emit(AuthLoading());

  final result = await resetPassword(
    token: token,
    newPassword: newPassword,
    confirmPassword: confirmPassword,
  );

  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (authResponse) {
      if (authResponse.success) {
        emit(PasswordResetSuccess());
      } else {
        emit(AuthError(authResponse.message ?? 'Failed to reset password'));
      }
    },
  );
}
```

### Task 1.6: Remove signInWithMock method (15 min)

**Delete** lines 67-83 in auth_cubit.dart:
```dart
// DELETE THIS ENTIRE METHOD ❌
Future<void> signInWithMock({required String email, required String name}) async {
  // ... mock implementation
}
```

**Why**: No longer needed, using real backend API.

---

## Phase 2: Fix Existing Pages (5.5 hours)

### Task 2.1: Fix Login Page (2 hours)

**File**: `lib/features/auth/presentation/pages/new_login_page.dart`

**Change 1**: Update `_handleLogin()` method (lines 27-35)
```dart
void _handleLogin() {
  if (_formKey.currentState!.validate()) {
    // Extract username from email input
    final username = _emailController.text.contains('@')
        ? _emailController.text.split('@').first
        : _emailController.text;

    // Call real backend login API
    context.read<AuthCubit>().loginWithEmail(
      username: username,
      password: _passwordController.text,
    );
  }
}
```

**Change 2**: Fix forgot password navigation (lines 240-242)
```dart
TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/forgot-password');
  },
  child: const Text('Forgot Password?', ...),
)
```

**Change 3**: Update BlocListener for better error handling (lines 49-63)
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home when authenticated
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (state is AuthError) {
      // Show error message with details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  },
  child: Scaffold(...),
)
```

**Change 4**: Add loading indicator to login button
```dart
SizedBox(
  width: double.infinity,
  height: 48,
  child: BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      final isLoading = state is AuthLoading;

      return ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(...),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Login', ...),
      );
    },
  ),
)
```

### Task 2.2: Fix Signup Page (2.5 hours)

**File**: `lib/features/auth/presentation/pages/new_signup_page.dart`

**Change 1**: Update `_handleSignUp()` method (lines 32-40)
```dart
void _handleSignUp() {
  if (_formKey.currentState!.validate()) {
    // Extract username from email
    final username = _emailController.text.split('@').first;

    // Call backend signup API
    context.read<AuthCubit>().signupWithEmail(
      username: username,
      password: _passwordController.text,
      fullName: _nameController.text,
      email: _emailController.text,
    );
  }
}
```

**Change 2**: Update BlocListener (lines 55-68)
```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home when authenticated (auto-login after signup)
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (state is SignupSuccess) {
      // Show success message, navigate to email verification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created! Please check ${state.email} for verification.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );
      // Navigate to email verification page
      Navigator.pushNamed(
        context,
        '/email-verification',
        arguments: state.email,
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  },
  child: Scaffold(...),
)
```

**Change 3**: Add loading indicator to Create Account button
```dart
SizedBox(
  width: double.infinity,
  height: 48,
  child: BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      final isLoading = state is AuthLoading;

      return ElevatedButton(
        onPressed: isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(...),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Create Account', ...),
      );
    },
  ),
)
```

**Change 4**: Add username field (optional enhancement)
```dart
// Add after Full Name field, before Email field
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Username', style: ...),
    const SizedBox(height: 8),
    TextFormField(
      controller: _usernameController, // Add this controller to state
      decoration: InputDecoration(
        hintText: 'Choose a username',
        prefixIcon: Icon(Icons.alternate_email, ...),
        ...
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        if (value.length < 3) {
          return 'Username must be at least 3 characters';
        }
        return null;
      },
    ),
  ],
),
const SizedBox(height: 16),
```

### Task 2.3: Testing Login/Signup (1 hour)

**Test Cases**:
1. ✅ Login with valid credentials → Navigate to home
2. ✅ Login with invalid credentials → Show error
3. ✅ Login with empty fields → Show validation errors
4. ✅ Signup with valid data → Create account + navigate to home/verification
5. ✅ Signup with existing email → Show error
6. ✅ Signup with password mismatch → Show validation error
7. ✅ Signup with invalid email → Show validation error
8. ✅ Loading indicators work during API calls

---

## Phase 3: Create Password Management Pages (4.5 hours)

### Task 3.1: Create ForgotPasswordPage (1.5 hours)

**File**: `lib/features/auth/presentation/pages/forgot_password_page.dart`

**Full Implementation**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().requestPasswordReset(
            email: _emailController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSent) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent to ${state.email}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
            ),
          );
          // Navigate back to login
          Navigator.of(context).pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Reset Your Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter your email address and we\'ll send you instructions to reset your password.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? AppTheme.textSubtleDark
                              : AppTheme.textSubtleLight,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // Email field
                  Text(
                    'Email Address',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return ElevatedButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Back to login
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 3.2: Create ResetPasswordPage (1.5 hours)

**File**: `lib/features/auth/presentation/pages/reset_password_page.dart`

**Full Implementation**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token; // Token from email link

  const ResetPasswordPage({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetUserPassword(
            token: widget.token,
            newPassword: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset successful! Please login.'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate to login
          Navigator.of(context).pushReplacementNamed('/login');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Create New Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please enter your new password.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? AppTheme.textSubtleDark
                              : AppTheme.textSubtleLight,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // New Password field
                  Text(
                    'New Password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password field
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm new password',
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return ElevatedButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Task 3.3: Create ChangePasswordPage (1.5 hours)

**File**: `lib/features/auth/presentation/pages/change_password_page.dart`

**Full Implementation**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().changeUserPassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordChanged) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back or to login
          Navigator.of(context).pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Update Your Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please enter your current password and choose a new one.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? AppTheme.textSubtleDark
                              : AppTheme.textSubtleLight,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // Current Password field
                  Text(
                    'Current Password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: !_isCurrentPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Enter current password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isCurrentPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // New Password field
                  Text(
                    'New Password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isNewPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isNewPasswordVisible = !_isNewPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (value == _currentPasswordController.text) {
                        return 'New password must be different from current';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Confirm Password field
                  Text(
                    'Confirm New Password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm new password',
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;

                        return ElevatedButton(
                          onPressed: isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Phase 4: Navigation & DI (1 hour)

### Task 4.1: Update Dependency Injection (30 min)

**File**: `lib/core/di/injection_container.dart`

**Update AuthCubit registration** (lines 85-92):
```dart
sl.registerFactory(
  () => AuthCubit(
    // OAuth dependencies (keep as-is)
    signInWithGoogle: sl(),
    signInWithApple: sl(),
    signOutUseCase: sl(),
    getCurrentUser: sl(),
    // Backend API dependencies (ADD THESE)
    signup: sl(),
    login: sl(),
    getProfile: sl(),
    changePassword: sl(),
    forgotPassword: sl(),
    resetPassword: sl(),
  ),
);
```

**Verify use cases are registered** (should already exist around lines 95-99):
```dart
sl.registerLazySingleton(() => Signup(sl()));
sl.registerLazySingleton(() => Login(sl()));
sl.registerLazySingleton(() => GetProfile(sl()));
sl.registerLazySingleton(() => ChangePassword(sl()));
sl.registerLazySingleton(() => ForgotPassword(sl()));
sl.registerLazySingleton(() => ResetPassword(sl()));
```

### Task 4.2: Add Navigation Routes (30 min)

**File**: `lib/main.dart` (or wherever routes are defined)

**Add routes for password pages**:
```dart
routes: {
  '/': (context) => const SplashScreen(),
  '/welcome': (context) => const WelcomePage(),
  '/login': (context) => const NewLoginPage(),
  '/signup': (context) => const NewSignUpPage(),
  '/email-verification': (context) => const EmailVerificationPage(),
  '/home': (context) => const HomePage(),

  // Add these routes ✅
  '/forgot-password': (context) => const ForgotPasswordPage(),
  '/reset-password': (context) {
    // Extract token from arguments
    final token = ModalRoute.of(context)!.settings.arguments as String;
    return ResetPasswordPage(token: token);
  },
  '/change-password': (context) => const ChangePasswordPage(),
},
```

---

## Phase 5: Testing & Validation (2 hours)

### Test Checklist

**Login Flow** (30 min):
- [ ] Login with valid email/password → Navigate to home
- [ ] Login with invalid credentials → Show error
- [ ] Login with empty fields → Show validation
- [ ] Loading indicator appears during API call
- [ ] Forgot password link navigates correctly

**Signup Flow** (30 min):
- [ ] Signup with valid data → Create account + navigate
- [ ] Signup with existing email → Show error
- [ ] Password mismatch → Show validation error
- [ ] Weak password → Show validation error
- [ ] Loading indicator works

**Forgot Password Flow** (30 min):
- [ ] Enter email → Send reset link
- [ ] Success message shown
- [ ] Navigate back to login
- [ ] Invalid email → Show error

**Reset Password Flow** (30 min):
- [ ] Enter new password → Reset successful
- [ ] Password mismatch → Show validation
- [ ] Navigate to login after success
- [ ] Invalid token → Show error

**Change Password Flow** (30 min):
- [ ] Enter current + new password → Change successful
- [ ] Wrong current password → Show error
- [ ] Password mismatch → Show validation
- [ ] Same password as current → Show validation

---

## Implementation Order

**Day 1** (4-5 hours):
1. Phase 1 - Task 1.1: Update AuthState (30 min)
2. Phase 1 - Task 1.2: Update AuthCubit constructor (30 min)
3. Phase 1 - Task 1.3: Add loginWithEmail (45 min)
4. Phase 1 - Task 1.4: Add signupWithEmail (45 min)
5. Phase 1 - Task 1.5: Add password methods (2 hours)
6. Phase 4 - Task 4.1: Update DI (30 min)

**Day 2** (5-6 hours):
1. Phase 2 - Task 2.1: Fix login page (2 hours)
2. Phase 2 - Task 2.2: Fix signup page (2.5 hours)
3. Phase 3 - Task 3.1: Create ForgotPasswordPage (1.5 hours)

**Day 3** (4-5 hours):
1. Phase 3 - Task 3.2: Create ResetPasswordPage (1.5 hours)
2. Phase 3 - Task 3.3: Create ChangePasswordPage (1.5 hours)
3. Phase 4 - Task 4.2: Add navigation routes (30 min)
4. Phase 5: Complete testing (2 hours)

---

## Risk Assessment

### High Risk
1. **User Entity Mismatch**: Backend returns `UserInfo`, domain uses `User`
   - **Mitigation**: Proper conversion in AuthCubit methods

2. **Token Storage**: JWT tokens must persist across app restarts
   - **Mitigation**: AuthRemoteDataSource already handles this with SharedPreferences

3. **OAuth vs Backend Users**: Users created via OAuth vs email/password
   - **Mitigation**: `authProvider` field distinguishes them

### Medium Risk
1. **Email Verification**: Signup may require email verification
   - **Mitigation**: Added `SignupSuccess` state to handle verification flow

2. **Password Reset Token**: How to get token from email link
   - **Mitigation**: Deep linking will be needed for production

### Low Risk
1. **Loading States**: Multiple operations using same `AuthLoading` state
   - **Mitigation**: Current design is acceptable, can add operation-specific states later

---

## Success Criteria

✅ **Phase 1 Complete**:
- AuthCubit has all 6 backend methods
- AuthState has password operation states
- signInWithMock removed

✅ **Phase 2 Complete**:
- Login page calls backend API
- Signup page calls backend API
- Loading indicators work
- Error handling works

✅ **Phase 3 Complete**:
- ForgotPasswordPage created and functional
- ResetPasswordPage created and functional
- ChangePasswordPage created and functional

✅ **Phase 4 Complete**:
- Dependency injection updated
- Navigation routes added

✅ **Phase 5 Complete**:
- All test cases pass
- No console errors
- Smooth user experience

---

## Next Steps After Implementation

1. **Add Deep Linking**: Handle password reset tokens from email
2. **Add Email Verification**: Verify email after signup
3. **Add Profile Page**: Allow users to view/edit profile using GetProfile
4. **Add Biometric Auth**: Face ID / Fingerprint for quick login
5. **Add Remember Me**: Persist login across sessions
6. **Add Logout Confirmation**: Prevent accidental logouts

---

**Last Updated**: 2025-11-22
**Author**: Claude Code
**Status**: Ready for Implementation
