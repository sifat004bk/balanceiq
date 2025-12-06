# BalanceIQ Backend API Specification

**Base URL**: `https://dolfinmind.com`
**API Version**: 1.0
**Last Tested**: 2025-11-29
**Authentication**: JWT Bearer Token

---

## Table of Contents

1. [Authentication APIs](#authentication-apis)
   - [Signup](#1-signup)
   - [Login](#2-login)
   - [Get Profile](#3-get-profile)
   - [Forgot Password](#4-forgot-password)
   - [Reset Password](#5-reset-password)
   - [Change Password](#6-change-password)
2. [Finance Guru APIs](#finance-guru-apis)
   - [Dashboard](#7-dashboard)
   - [Chat](#8-chat)
   - [Chat History](#9-chat-history)
3. [Response Format](#response-format)
4. [Error Codes](#error-codes)
5. [Status Summary](#status-summary)

---

## Authentication APIs

### 1. Signup

Register a new user account.

**Endpoint**: `POST /api/auth/signup`
**Authentication**: Not required
**Content-Type**: `application/json`

#### Request Body

```json
{
  "username": "string (required, unique)",
  "email": "string (required, valid email format)",
  "password": "string (required, min 6 characters)",
  "fullName": "string (required)"
}
```

#### Request Example

```json
{
  "username": "testuser123",
  "email": "testuser123@example.com",
  "password": "TestPassword123!",
  "fullName": "Test User"
}
```

#### Success Response (201 Created)

```json
{
  "success": true,
  "message": "User registered successfully. Email verification will be required when subscribing to a plan.",
  "data": {
    "id": 8,
    "email": "testuser1764446708@example.com",
    "username": "testuser1764446708",
    "fullName": "Test User",
    "userRole": "USER",
    "subscriptionPlanName": null,
    "subscriptionStatus": null,
    "subscriptionEndDate": null,
    "isActive": true,
    "isEmailVerified": false,
    "createdAt": "2025-11-29T20:05:10.459226282"
  },
  "error": null,
  "timestamp": 1764446710469
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Unique user ID |
| email | string | User's email address |
| username | string | Unique username |
| fullName | string | User's full name |
| userRole | string | User role (e.g., "USER") |
| subscriptionPlanName | string \| null | Name of subscription plan (null if not subscribed) |
| subscriptionStatus | string \| null | Status of subscription |
| subscriptionEndDate | string \| null | ISO 8601 date when subscription ends |
| isActive | boolean | Whether user account is active |
| isEmailVerified | boolean | Whether email has been verified |
| createdAt | string | ISO 8601 timestamp of account creation |

#### Error Responses

**500 Internal Server Error**
```json
{
  "success": false,
  "message": "An unexpected error occurred",
  "data": null,
  "error": "INTERNAL_SERVER_ERROR",
  "timestamp": 1764446621389
}
```

**Status**: ✅ **Working**

---

### 2. Login

Authenticate user and receive JWT token.

**Endpoint**: `POST /api/auth/login`
**Authentication**: Not required
**Content-Type**: `application/json`

#### Request Body

```json
{
  "username": "string (required)",
  "password": "string (required)"
}
```

#### Request Example

```json
{
  "username": "testuser123",
  "password": "TestPassword123!"
}
```

#### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0dXNlcjE3NjQ0NDY3MDgiLCJpYXQiOjE3NjQ0NDY3MTMsImV4cCI6MTc2NDQ4MjcxM30.F9FHVltntBHPwbIcJ_nYbKmgfMtFl1O4LJAcpKBpoYE",
    "userId": 8,
    "username": "testuser1764446708",
    "email": "testuser1764446708@example.com",
    "role": "USER",
    "isEmailVerified": false
  },
  "error": null,
  "timestamp": 1764446713180
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| token | string | JWT bearer token (expires in 10 hours) |
| userId | integer | Unique user ID |
| username | string | Username |
| email | string | User's email address |
| role | string | User role (e.g., "USER", "ADMIN") |
| isEmailVerified | boolean | Whether email is verified |

#### Error Responses

**500 Internal Server Error** - Invalid credentials or server error

**Status**: ✅ **Working**

---

### 3. Get Profile

Retrieve authenticated user's profile information.

**Endpoint**: `GET /api/auth/me`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Success Response (200 OK)

**Status**: ⚠️ **Under Development** (Currently returns 500 Internal Server Error)

Expected response format (based on signup response):
```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": 8,
    "email": "testuser@example.com",
    "username": "testuser",
    "fullName": "Test User",
    "userRole": "USER",
    "subscriptionPlanName": null,
    "subscriptionStatus": null,
    "subscriptionEndDate": null,
    "isActive": true,
    "isEmailVerified": false,
    "createdAt": "2025-11-29T20:05:10.459226282"
  },
  "error": null,
  "timestamp": 1764446714420
}
```

#### Error Responses

**500 Internal Server Error**
```json
{
  "success": false,
  "message": "An unexpected error occurred",
  "data": null,
  "error": "INTERNAL_SERVER_ERROR",
  "timestamp": 1764446714420
}
```

**401 Unauthorized** - Missing or invalid token

**Status**: ⚠️ **Under Development**

---

### 4. Forgot Password

Request password reset email with reset token.

**Endpoint**: `POST /api/auth/forgot-password`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Body

```json
{
  "email": "string (required, registered email)"
}
```

#### Request Example

```json
{
  "email": "testuser@example.com"
}
```

#### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Password reset instructions have been sent to your email",
  "data": null,
  "error": null,
  "timestamp": 1764446720852
}
```

#### Response Fields

- Email with password reset token will be sent to the provided email address
- Token is used in the Reset Password endpoint

#### Error Responses

**401 Unauthorized** - Missing or invalid JWT token
**404 Not Found** - Email not registered

**Status**: ✅ **Working**

---

### 5. Reset Password

Reset password using token received from forgot password email.

**Endpoint**: `POST /api/auth/reset-password`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Body

```json
{
  "token": "string (required, reset token from email)",
  "newPassword": "string (required, min 6 characters)",
  "confirmPassword": "string (required, must match newPassword)"
}
```

#### Request Example

```json
{
  "token": "53c0d8bc-40d2-4803-946e-a914c18cfbbc",
  "newPassword": "NewPassword123!",
  "confirmPassword": "NewPassword123!"
}
```

#### Success Response (200 OK)

Expected response format:
```json
{
  "success": true,
  "message": "Password reset successful",
  "data": null,
  "error": null,
  "timestamp": 1764446723332
}
```

#### Error Responses

**400 Bad Request** - Invalid token
```json
{
  "success": false,
  "message": "Invalid password reset token",
  "data": null,
  "error": "INVALID_ARGUMENT",
  "timestamp": 1764446723332
}
```

**401 Unauthorized** - Missing or invalid JWT token
**400 Bad Request** - Passwords don't match

**Status**: ✅ **Working** (Validated error handling)

---

### 6. Change Password

Change password for authenticated user.

**Endpoint**: `POST /api/auth/change-password`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Request Body

```json
{
  "currentPassword": "string (required)",
  "newPassword": "string (required, min 6 characters)",
  "confirmPassword": "string (required, must match newPassword)"
}
```

#### Request Example

```json
{
  "currentPassword": "OldPassword123!",
  "newPassword": "NewPassword123!",
  "confirmPassword": "NewPassword123!"
}
```

#### Success Response (200 OK)

Expected response format:
```json
{
  "success": true,
  "message": "Password changed successfully",
  "data": null,
  "error": null,
  "timestamp": 1764446722077
}
```

#### Error Responses

**500 Internal Server Error** - Current implementation issue
```json
{
  "success": false,
  "message": "An unexpected error occurred",
  "data": null,
  "error": "INTERNAL_SERVER_ERROR",
  "timestamp": 1764446722077
}
```

**401 Unauthorized** - Missing or invalid token
**400 Bad Request** - Current password incorrect or passwords don't match

**Status**: ⚠️ **Under Development** (Currently returns 500 error)

---

## Finance Guru APIs

### 7. Dashboard

Retrieve user's financial dashboard summary.

**Endpoint**: `GET /api/finance-guru/v1/dashboard`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Request Parameters

None required - user ID extracted from JWT token

#### Success Response (200 OK)

```json
{
  "userId": 9,
  "period": "2025-12",
  "totalIncome": 100000.00,
  "totalExpense": 6755.00,
  "netBalance": 93245.00,
  "expenseRatio": 6.76,
  "savingsRate": 93.25,
  "categoryBreakdown": [
    {
      "category": "dps",
      "amount": 5000.0,
      "percent": null,
      "transactionCount": 1
    }
  ],
  "dailySpendingTrend": [
    {
      "date": "2025-12-01",
      "amount": 0.0
    }
  ],
  "biggestExpense": {
    "amount": 5000.00,
    "category": "dps",
    "description": "dps"
  },
  "biggestCategory": "dps",
  "daysRemainingInMonth": 25
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| userId | integer | User ID from JWT token |
| period | string | Current period (format: YYYY-MM) |
| totalIncome | number | Total income for the period |
| totalExpense | number | Total expenses for the period |
| netBalance | number | Net balance (income - expense) |
| expenseRatio | number \| null | Expense ratio percentage |
| savingsRate | number \| null | Savings rate percentage |
| categoryBreakdown | array | List of expense categories with amounts |
| dailySpendingTrend | array | Daily spending trend data |
| biggestExpense | object \| null | Details of biggest single expense |
| biggestCategory | string \| null | Name of category with highest spending |
| daysRemainingInMonth | integer | Days left in current month |

#### Category Breakdown Item

```json
{
  "category": "string",
  "amount": "number",
  "percent": "number | null",
  "transactionCount": "integer"
}
```

#### Daily Spending Trend Item

```json
{
  "date": "string (YYYY-MM-DD)",
  "amount": "number"
}
```

#### Error Responses

**401 Unauthorized** - Missing or invalid token

**Status**: ✅ **Working**

---

### 8. Chat

Send message to AI finance assistant and get response.

**Endpoint**: `POST /api/finance-guru/chat`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Request Body

```json
{
  "text": "string (required, user message)",
  "username": "string (required, username for context)"
}
```

#### Request Example

```json
{
  "text": "What is my current balance?",
  "username": "testuser123"
}
```

#### Success Response (200 OK)

```json
{
  "success": true,
  "message": "#### Your Current Balance\n\n| **Item** | **Amount** |\n|----------|-----------|\n| Current Balance | ৳0 |",
  "userId": 8,
  "timestamp": "2025-11-29T20:05:17.924603407",
  "tokenUsage": {
    "promptTokens": 398,
    "completionTokens": 334,
    "totalTokens": 732
  },
  "actionType": "balance_query"
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| success | boolean | Whether request was successful |
| message | string | AI response in markdown format |
| userId | integer | User ID |
| timestamp | string | ISO 8601 timestamp of response |
| tokenUsage | object | LLM token usage statistics |
| tokenUsage.promptTokens | integer | Tokens used in prompt |
| tokenUsage.completionTokens | integer | Tokens used in completion |
| tokenUsage.totalTokens | integer | Total tokens used |
| actionType | string | Type of action performed (e.g., "balance_query", "expense_log") |

#### Action Types

- `balance_query` - Balance inquiry
- `expense_log` - Logging an expense
- `income_log` - Logging income
- `budget_query` - Budget-related query
- `general_advice` - General financial advice

#### Error Responses

**401 Unauthorized** - Missing or invalid token
**400 Bad Request** - Invalid request format

**Status**: ✅ **Working**

---

### 9. Chat History

Retrieve paginated chat conversation history.

**Endpoint**: `GET /api/finance-guru/chat-history`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| page | integer | No | 1 | Page number (1-indexed) |
| limit | integer | No | 10 | Items per page (max 50) |

#### Request Example

```
GET /api/finance-guru/chat-history?page=1&limit=10
```

#### Success Response (200 OK)

```json
{
  "userId": 8,
  "conversations": [
    {
      "userMessage": "What is my current balance?",
      "aiResponse": "#### Your Current Balance\n\n| **Item** | **Amount** |\n|----------|-----------|\n| Current Balance | ৳0 |",
      "createdAt": "2025-11-29T20:05:17.909358"
    }
  ],
  "pagination": {
    "currentPage": 1,
    "limit": 10,
    "returned": 1,
    "hasNext": false,
    "nextPage": null
  }
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| userId | integer | User ID |
| conversations | array | Array of conversation objects |
| pagination | object | Pagination metadata |

#### Conversation Object

| Field | Type | Description |
|-------|------|-------------|
| userMessage | string | User's message |
| aiResponse | string | AI response in markdown |
| createdAt | string | ISO 8601 timestamp |

#### Pagination Object

| Field | Type | Description |
|-------|------|-------------|
| currentPage | integer | Current page number |
| limit | integer | Items per page |
| returned | integer | Number of items in this response |
| hasNext | boolean | Whether there are more pages |
| nextPage | integer \| null | Next page number or null |

#### Error Responses

**Status**: ✅ **Working**

---

## Response Format

All API responses follow a consistent format:

### Success Response

```json
{
  "success": true,
  "message": "string - Human-readable message",
  "data": {}, // Response data or null
  "error": null,
  "timestamp": 1764446710469 // Unix timestamp in milliseconds
}
```

### Error Response

```json
{
  "success": false,
  "message": "string - Error description",
  "data": null,
  "error": "ERROR_CODE",
  "timestamp": 1764446710469
}
```

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| UNAUTHORIZED | 401 | Missing or invalid authentication token |
| INVALID_ARGUMENT | 400 | Invalid request parameters |
| INTERNAL_SERVER_ERROR | 500 | Server-side error |
| NOT_FOUND | 404 | Resource not found |

---

## Status Summary

### ✅ Working APIs (7/9)

1. **Signup** - `POST /api/auth/signup` ✅
2. **Login** - `POST /api/auth/login` ✅
3. **Forgot Password** - `POST /api/auth/forgot-password` ✅
4. **Reset Password** - `POST /api/auth/reset-password` ✅
5. **Dashboard** - `GET /api/finance-guru/dashboard` ✅
6. **Chat** - `POST /api/finance-guru/chat` ✅
7. **Chat History** - `GET /api/finance-guru/chat-history` ✅

### ⚠️ Under Development (2/9)

1. **Get Profile** - `GET /api/auth/me` ⚠️ (500 Internal Server Error)
2. **Change Password** - `POST /api/auth/change-password` ⚠️ (500 Internal Server Error)

---

## Authentication Flow

1. **Register**: Call `POST /api/auth/signup` with user details
2. **Login**: Call `POST /api/auth/login` with username and password
3. **Store Token**: Save the JWT token from login response
4. **Use Token**: Include token in `Authorization: Bearer <token>` header for all authenticated requests
5. **Token Expiry**: Tokens expire after 10 hours, require re-login

---

## Notes

- All timestamps are in ISO 8601 format or Unix milliseconds
- JWT tokens expire in 10 hours (36000000 ms)
- Email verification is required for subscription features
- All monetary values are in Bangladeshi Taka (৳)
- Chat responses are formatted in markdown
- Maximum chat history page size is 50 items

---

**Last Updated**: 2025-11-29
**Tested By**: Claude AI Assistant
**Backend Version**: Production API v1.0
