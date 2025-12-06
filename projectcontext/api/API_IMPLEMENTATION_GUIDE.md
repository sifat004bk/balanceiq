# API Implementation Guide

This guide details how to implement and consume APIs in the BalanceIQ application, following the centralization of API endpoints.

## Core Principles

1.  **Single Source of Truth**: All API URLs are defined in `lib/core/constants/api_endpoints.dart`.
2.  **Environment Configuration**: Base URLs are configured in the `.env` file.
3.  **No Hardcoding**: Never hardcode API URLs in data sources or repositories.

## Configuration (.env)

Ensure your `.env` file contains the following keys:

```properties
# Backend Base URL
BACKEND_BASE_URL=https://dolfinmind.com

# API Base URLs (Optional overrides, defaults derived from BACKEND_BASE_URL)
AUTH_BASE_URL=https://dolfinmind.com/api/auth
FINANCE_GURU_BASE_URL=https://dolfinmind.com/api/finance-guru
```

## Usage in Code

### 1. Import ApiEndpoints

```dart
import 'package:balance_iq/core/constants/api_endpoints.dart';
```

### 2. Access Endpoints

Use the static getters from `ApiEndpoints` to get the full URL.

```dart
// Authentication
final loginUrl = ApiEndpoints.login;
final signupUrl = ApiEndpoints.signup;

// Finance Guru
final chatUrl = ApiEndpoints.chat;
final dashboardUrl = ApiEndpoints.dashboard;
```

### 3. Example Implementation (Dio)

```dart
import 'package:dio/dio.dart';
import 'package:balance_iq/core/constants/api_endpoints.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  // ... constructor ...

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await dio.post(
      ApiEndpoints.login, // <--- Usage
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }
}
```

## Adding New Endpoints

1.  Open `lib/core/constants/api_endpoints.dart`.
2.  Add a new static getter for the endpoint.
3.  Use the appropriate base URL getter (`authBaseUrl` or `financeGuruBaseUrl`).

```dart
class ApiEndpoints {
  // ... existing endpoints ...

  // New Endpoint
  static String get newFeature => '$financeGuruBaseUrl/new-feature';
}
```
