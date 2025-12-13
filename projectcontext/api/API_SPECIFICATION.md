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
   - [Transaction Search](#10-transaction-search)
   - [Chat Feedback](#11-chat-feedback)
   - [Token Usage](#12-token-usage)
   - [Action Types](#13-action-types)
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

Retrieve a comprehensive financial dashboard for the authenticated user. This endpoint aggregates transaction data to provide summaries, trends, and top income/expense items for a specified date range.

**Endpoint**: `GET /api/finance-guru/v1/dashboard`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Query Parameters

| Parameter | Type | Required | Description | Default |
|-----------|------|----------|-------------|---------|
| `startDate` | Date (ISO 8601) | No | Start date for the dashboard data (YYYY-MM-DD) | First day of current month |
| `endDate` | Date (ISO 8601) | No | End date for the dashboard data (YYYY-MM-DD) | Last day of current month |

#### Request Example

```
GET /api/finance-guru/v1/dashboard?startDate=2025-12-01&endDate=2025-12-31
Authorization: Bearer <JWT_TOKEN>
```

#### Success Response (200 OK)

```json
{
  "userId": 12345,
  "startDate": "2025-12-01",
  "endDate": "2025-12-31",
  "totalIncome": 50000.00,
  "totalExpense": 15450.50,
  "netBalance": 34549.50,
  "expenseRatio": 30.90,
  "savingsRate": 69.10,
  "categoryBreakdown": [
    {
      "category": "Rent",
      "amount": 12000.00,
      "transactionCount": 1
    },
    {
      "category": "Groceries",
      "amount": 3450.50,
      "transactionCount": 5
    }
  ],
  "dailySpendingTrend": [
    {
      "date": "2025-12-01",
      "amount": 12000.00
    },
    {
      "date": "2025-12-05",
      "amount": 540.00
    }
  ],
  "biggestExpense": {
    "amount": 12000.00,
    "category": "Rent",
    "description": "Monthly House Rent"
  },
  "biggestIncome": {
    "amount": 45000.00,
    "category": "Salary",
    "description": "December Salary"
  },
  "daysRemainingInMonth": 24
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| userId | integer | User ID from JWT token |
| startDate | Date (YYYY-MM-DD) | The start date of the dashboard period |
| endDate | Date (YYYY-MM-DD) | The end date of the dashboard period |
| totalIncome | number | Total income amount for the period |
| totalExpense | number | Total expense amount for the period |
| netBalance | number | Net balance (Income - Expense) |
| expenseRatio | number | Ratio of expenses to income (0-100) |
| savingsRate | number | Ratio of savings (Net Balance) to income (0-100) |
| categoryBreakdown | array | List of spending by category |
| dailySpendingTrend | array | Daily aggregate of expenses |
| biggestExpense | object \| null | The single largest expense transaction in the period |
| biggestIncome | object \| null | The single largest income transaction in the period |
| daysRemainingInMonth | integer | Number of days left in the month (0 if viewing past periods) |

#### Category Breakdown Item

```json
{
  "category": "string",
  "amount": "number",
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

#### Expense/Income Item Structure

```json
{
  "amount": "number",
  "category": "string",
  "description": "string"
}
```

#### Error Responses

**401 Unauthorized** - Missing or invalid token
**500 Internal Server Error** - Server error processing the request

**Status**: ✅ **Working**

---

### 8. Chat

Send message to AI finance assistant and get response.

**Endpoint**: `POST /api/finance-guru/v1/chat`
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
  "username": "string (optional, username for context)",
  "imageBase64": "string (optional, base64 encoded image)"
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
  "message": "#### Markdown formatted text",
  "userId": 5,
  "timestamp": "2025-12-13T12:39:50.938",
  "tokenUsage": {
    "promptTokens": 500,
    "completionTokens": 100,
    "totalTokens": 600
  },
  "actionType": "record_expense",
  "table": false,
  "tableData": null,
  "graphType": null,
  "graphData": null
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| success | boolean | Whether request was successful |
| message | string | AI response in markdown format (no tables in markdown) |
| userId | integer | User ID |
| timestamp | string | ISO 8601 timestamp of response |
| tokenUsage | object | LLM token usage statistics |
| tokenUsage.promptTokens | integer | Tokens used in prompt |
| tokenUsage.completionTokens | integer | Tokens used in completion |
| tokenUsage.totalTokens | integer | Total tokens used |
| actionType | string | Type of action performed (see Action Types below) |
| table | boolean | Whether to render a table (if true, use tableData) |
| tableData | array \| null | Array of objects for table rendering: `[{"col1": "val1", "col2": "val2"}, ...]` |
| graphType | string \| null | Type of graph: `"line"`, `"bar"`, or `null` |
| graphData | object \| null | Chart.js compatible format (see graphData Format below) |

#### graphData Format

When `graphType` is not null, the `graphData` field contains Chart.js compatible data:

```json
{
  "labels": ["Jan", "Feb", "Mar"],
  "datasets": [
    {
      "label": "Expenses",
      "data": [1000, 2000, 1500]
    },
    {
      "label": "Income",
      "data": [5000, 5500, 6000]
    }
  ]
}
```

#### Graph Type Mapping

| graphType | Common Action Types |
|-----------|---------------------|
| `"line"` | summary, top_expenses, compare_periods, monthly_trend, financial_health |
| `"bar"` | balance, get_balance, list_accounts, list_categories, category_breakdown |
| `null` | record_transaction, batch_record_transaction, delete_transaction, update_transaction, search_transactions |

#### Action Types

**Transaction Actions:**
- `record_expense` - A single expense transaction was recorded
- `record_income` - A single income transaction was recorded
- `record_transaction` - A transaction was recorded (generic)
- `batch_record_transaction` - Multiple transactions recorded in batch
- `update_transaction` - An existing transaction was updated
- `delete_transaction` - A transaction was deleted
- `batch_update_transaction` - Multiple transactions updated
- `batch_delete_transaction` - Multiple transactions deleted
- `search_transactions` - Transaction search performed

**Analytics & Reporting:**
- `summary` - General financial summary retrieved
- `balance`, `get_balance` - Current account balance(s) retrieved
- `top_expenses` - List of top spending items or categories
- `monthly_trend` - Monthly spending/income trend data
- `category_breakdown` - Spending breakdown by category
- `compare_periods` - Comparison between time periods
- `financial_health` - Financial health score or assessment

**Category Management:**
- `list_categories` - List of available categories retrieved
- `list_accounts` - List of accounts retrieved
- `manage_category` - Category created, updated, or deleted

**System & Conversation:**
- `general_chat` - Non-financial conversation
- `clarification_needed` - Bot needs more information
- `error` - Error occurred while processing

#### Error Responses

**401 Unauthorized** - Missing or invalid token
**400 Bad Request** - Invalid request format

**Status**: ✅ **Working**

---

### 9. Chat History

Retrieve paginated chat conversation history.

**Endpoint**: `GET /api/finance-guru/v1/chat-history`
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
| size | integer | No | 20 | Items per page (max 50) |

#### Request Example

```
GET /api/finance-guru/v1/chat-history?page=1&size=20
```

#### Success Response (200 OK)

```json
{
  "userId": 5,
  "conversations": [
    {
      "id": 10,
      "userMessage": "and maid? have I paid her?",
      "aiResponse": "⚠️ **No maid expense found**\n\n• Your recent expense breakdown does not include a maid payment.\n• Please check your records or try again later.",
      "createdAt": "2025-12-08T10:34:10.756031",
      "feedback": null
    },
    {
      "id": 9,
      "userMessage": "what about rent?",
      "aiResponse": "#### 📊 **Rent Breakdown**\n\n| Category | Total (৳) | Percent | Transactions | Avg (৳) |\n|---|---|---|---|---|\n| **Rent** | 30,000.00 | 66.73% | 1 | 30,000.00 |\n",
      "createdAt": "2025-12-08T10:33:54.831077",
      "feedback": null
    }
  ],
  "pagination": {
    "currentPage": 1,
    "limit": 20,
    "returned": 2,
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
| id | integer | Unique conversation ID (required for feedback) |
| userMessage | string | User's message |
| aiResponse | string | AI response in markdown |
| createdAt | string | ISO 8601 timestamp |
| feedback | string \| null | User feedback: "LIKE", "DISLIKE", or null |

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

### 10. Transaction Search

Retrieve a list of transactions with flexible filtering capabilities.

**Endpoint**: `GET /api/finance-guru/v1/transactions`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Query Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `search` | String | No | Text to search in descriptions and categories (supports fuzzy matching) | `coffee` |
| `category` | String | No | Filter by category name (partial match) | `Food` |
| `type` | String | No | Filter by transaction type: `INCOME`, `EXPENSE`, `TRANSFER` | `EXPENSE` |
| `startDate` | Date (ISO) | No | Start date for the transaction range (YYYY-MM-DD) | `2025-12-01` |
| `endDate` | Date (ISO) | No | End date for the transaction range (YYYY-MM-DD) | `2025-12-31` |
| `minAmount` | Double | No | Minimum transaction amount | `100.0` |
| `maxAmount` | Double | No | Maximum transaction amount | `5000.0` |
| `limit` | Integer | No | Maximum number of results to return (max 200) | `50` |

#### Request Example

```
GET /api/finance-guru/v1/transactions?category=Food&startDate=2025-12-01
Authorization: Bearer <JWT_TOKEN>
```

#### Success Response (200 OK)

```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "transaction_id": 101,
      "type": "EXPENSE",
      "amount": 450.00,
      "category": "Food & Dining",
      "description": "Lunch at Cafe",
      "transaction_date": "2025-12-05",
      "created_at": "2025-12-05T12:30:00",
      "relevance_score": 1.0,
      "total_matches": 2
    },
    {
      "transaction_id": 102,
      "type": "EXPENSE",
      "amount": 120.00,
      "category": "Food",
      "description": "Snacks",
      "transaction_date": "2025-12-06",
      "created_at": "2025-12-06T15:00:00",
      "relevance_score": 1.0,
      "total_matches": 2
    }
  ]
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| success | boolean | True if the request was successful |
| count | integer | Number of transactions returned |
| data | array | List of transaction objects |

#### Transaction Object

| Field | Type | Description |
|-------|------|-------------|
| transaction_id | integer | Unique ID of the transaction |
| type | string | Type (INCOME, EXPENSE, TRANSFER) |
| amount | number | Transaction amount |
| category | string | Category name |
| description | string | Description |
| transaction_date | Date (YYYY-MM-DD) | Date of the transaction |
| created_at | DateTime (ISO 8601) | Server timestamp when created |
| relevance_score | number | Search relevance score (if search text provided) |
| total_matches | integer | Total number of matches found |

#### Error Responses

**401 Unauthorized** - Missing or invalid token
**400 Bad Request** - Invalid query parameters
**500 Internal Server Error** - Server error

**Status**: ✅ **Working**

---

### 11. Chat Feedback

Allow users to provide feedback ("LIKE" or "DISLIKE") on specific chat messages.

**Endpoint**: `POST /api/finance-guru/v1/chat-history/{id}/feedback`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | Integer | Yes | The ID of the chat message (returned in chat history) |

#### Request Body

```json
{
  "feedback": "LIKE"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `feedback` | String | Yes | Feedback value: `LIKE`, `DISLIKE`, or `NONE` |

#### Request Example

```http
POST /api/finance-guru/v1/chat-history/123/feedback HTTP/1.1
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

{
  "feedback": "LIKE"
}
```

#### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Feedback updated"
}
```

#### Error Responses

**400 Bad Request** - Invalid feedback value or ID
```json
{
  "success": false,
  "message": "Invalid feedback value. Must be LIKE, DISLIKE, or NONE",
  "error": "INVALID_ARGUMENT"
}
```

**403 Forbidden** - User does not own the chat message
```json
{
  "success": false,
  "message": "You can only provide feedback on your own messages",
  "error": "FORBIDDEN"
}
```

**404 Not Found** - Chat message ID not found
```json
{
  "success": false,
  "message": "Chat message not found",
  "error": "NOT_FOUND"
}
```

**401 Unauthorized** - Missing or invalid token

**Status**: ✅ **Working**

---

### 12. Token Usage

Retrieve tracking statistics for the user's token consumption in the FinanceGuru chat system. This data is useful for monitoring usage limits or billing.

**Endpoint**: `GET /api/finance-guru/v1/token-usage`
**Authentication**: Required (Bearer Token)
**Content-Type**: `application/json`

#### Request Headers

```
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

#### Request Example

```
GET /api/finance-guru/v1/token-usage
Authorization: Bearer <JWT_TOKEN>
```

#### Success Response (200 OK)

```json
{
  "totalUsage": 4500,
  "todayUsage": 1250,
  "history": [
    {
      "amount": 250,
      "action": "QUERY",
      "timestamp": "2025-12-07T16:30:45.123"
    },
    {
      "amount": 100,
      "action": "LOG_EXPENSE",
      "timestamp": "2025-12-07T16:28:10.555"
    }
  ]
}
```

#### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| totalUsage | integer | Total tokens used by this user over all time |
| todayUsage | integer | Tokens used since midnight (00:00:00) today |
| history | array | List of recent usage events (last 10) |

#### History Item Structure

| Field | Type | Description |
|-------|------|-------------|
| amount | integer | Number of tokens consumed in this event |
| action | string | The action type associated with this usage (e.g., `QUERY`, `LOG_EXPENSE`) |
| timestamp | DateTime (ISO 8601) | Timestamp of the event |

#### Error Responses

**401 Unauthorized** - Missing or invalid token
**500 Internal Server Error** - Server error

**Status**: ✅ **Working**

---

### 13. Action Types

The `actionType` field in the Chat API response indicates the nature of the operation performed or the intent processed. This allows the frontend to render specific UI components (e.g., charts for trends, success cards for transactions).

#### Transaction Actions

| Action Type | Description |
|-------------|-------------|
| `record_income` | A single income transaction was successfully recorded |
| `record_expense` | A single expense transaction was successfully recorded |
| `record_transaction` | A transaction was recorded (generic fallback) |
| `batch_record_transaction` | Multiple transactions were recorded in a batch |
| `update_transaction` | An existing transaction was updated |
| `delete_transaction` | A transaction was deleted |
| `batch_update_transaction` | Multiple transactions were updated |
| `batch_delete_transaction` | Multiple transactions were deleted |
| `search_transactions` | A search for transactions was performed (likely returns a list) |

#### Analytics & Reporting Actions

| Action Type | Description |
|-------------|-------------|
| `summary` | A general financial summary was retrieved |
| `balance`, `get_balance` | Current account balance(s) were retrieved |
| `top_expenses` | A list of top spending items or categories |
| `monthly_trend` | Monthly spending/income trend data |
| `category_breakdown` | Spending breakdown by category (pie chart data) |
| `compare_periods` | Comparison between time periods (e.g., this month vs last) |
| `financial_health` | Financial health score or assessment |

#### Category Management Actions

| Action Type | Description |
|-------------|-------------|
| `list_categories` | A list of available categories was retrieved |
| `manage_category` | A category was created, updated, or deleted |

#### System & Conversation Actions

| Action Type | Description |
|-------------|-------------|
| `general_chat` | Non-financial conversation (greeting, chit-chat) |
| `clarification_needed` | The bot needs more information to proceed (e.g., "How much?") |
| `error` | An error occurred while processing the request |

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
| FORBIDDEN | 403 | User does not have permission to access the resource |
| INVALID_ARGUMENT | 400 | Invalid request parameters |
| INTERNAL_SERVER_ERROR | 500 | Server-side error |
| NOT_FOUND | 404 | Resource not found |

---

## Status Summary

### ✅ Working APIs (10/13)

**Authentication (4/6)**
1. **Signup** - `POST /api/auth/signup` ✅
2. **Login** - `POST /api/auth/login` ✅
3. **Forgot Password** - `POST /api/auth/forgot-password` ✅
4. **Reset Password** - `POST /api/auth/reset-password` ✅

**Finance Guru (6/6)**
5. **Dashboard** - `GET /api/finance-guru/v1/dashboard` ✅
6. **Chat** - `POST /api/finance-guru/chat` ✅
7. **Chat History** - `GET /api/finance-guru/chat-history` ✅
8. **Transaction Search** - `GET /api/finance-guru/v1/transactions` ✅
9. **Chat Feedback** - `POST /api/finance-guru/v1/chat-history/{id}/feedback` ✅
10. **Token Usage** - `GET /api/finance-guru/v1/token-usage` ✅

### ⚠️ Under Development (2/13)

1. **Get Profile** - `GET /api/auth/me` ⚠️ (500 Internal Server Error)
2. **Change Password** - `POST /api/auth/change-password` ⚠️ (500 Internal Server Error)

### 🔄 To Be Implemented in Flutter App (3/6)

The following FinanceGuru APIs are working on the backend but not yet integrated in the Flutter app:
1. **Transaction Search** - `GET /api/finance-guru/v1/transactions` (planned)
2. **Chat Feedback** - `POST /api/finance-guru/v1/chat-history/{id}/feedback` (planned)
3. **Token Usage** - `GET /api/finance-guru/v1/token-usage` (planned)

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
- Dashboard API supports custom date ranges via `startDate` and `endDate` query parameters
- Transaction search supports fuzzy matching and multiple filter combinations
- Chat feedback allows users to rate AI responses (LIKE, DISLIKE, NONE)
- Token usage tracking helps monitor LLM consumption for billing and limits
- All Finance Guru v1 endpoints require JWT Bearer authentication

---

**Last Updated**: 2025-12-12
**Tested By**: Claude AI Assistant
**Backend Version**: Production API v1.0
**Updated**: Finance Guru v1 API endpoints (chat and chat-history)
