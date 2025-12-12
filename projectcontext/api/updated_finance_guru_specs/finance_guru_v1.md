# FinanceGuru Dashboard API

## Get User Dashboard

Retrieve a comprehensive financial dashboard for the authenticated user. This endpoint aggregates transaction data to provide summaries, trends, and top income/expense items for a specified date range.

**URL**
`GET /api/finance-guru/v1/dashboard`

**Authentication**
Requires a valid JWT Bearer token.

### Query Parameters

| Parameter | Type | Required | Description | Default |
| :--- | :--- | :--- | :--- | :--- |
| `startDate` | Date (ISO 8601) | No | Start date for the dashboard data (YYYY-MM-DD). | First day of current month |
| `endDate` | Date (ISO 8601) | No | End date for the dashboard data (YYYY-MM-DD). | Last day of current month |

### Response Structure

The response is a JSON object [DashboardResponse](file:///Users/saif.vivasoft/IdeaProjects/autobiz/src/main/kotlin/com/bluesea/autobiz/financeGuru/dto/DashboardResponse.kt#6-22) containing the following fields:

| Field | Type | Description |
| :--- | :--- | :--- |
| `userId` | Long | The ID of the user. |
| `startDate` | Date (YYYY-MM-DD) | The start date of the dashboard period. |
| `endDate` | Date (YYYY-MM-DD) | The end date of the dashboard period. |
| `totalIncome` | number | Total income amount for the period. |
| `totalExpense` | number | Total expense amount for the period. |
| `netBalance` | number | Net balance (Income - Expense). |
| `expenseRatio` | number | Ratio of expenses to income (0-100). |
| `savingsRate` | number | Ratio of savings (Net Balance) to income (0-100). |
| `categoryBreakdown` | Array | List of spending by category. |
| `dailySpendingTrend` | Array | Daily aggregate of expenses. |
| `biggestExpense` | Object | The single largest expense transaction in the period. |
| `biggestIncome` | Object | The single largest income transaction in the period. |
| `daysRemainingInMonth` | Integer | Number of days left in the month (0 if viewing past periods). |

** Expense/Income Item Structure **
| Field | Type | Description |
| :--- | :--- | :--- |
| `amount` | number | Transaction amount. |
| `category` | String | Category name. |
| `description` | String | Transaction description. |

### Example Request

```http
GET /api/finance-guru/v1/dashboard?startDate=2025-12-01&endDate=2025-12-31 HTTP/1.1
Authorization: Bearer <your_token>
```

### Example Response

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

### Error Codes

| Status | Code | Description |
| :--- | :--- | :--- |
| 200 | OK | Success. |
| 401 | UNAUTHORIZED | Invalid or missing authentication token. |
| 500 | INTERNAL_SERVER_ERROR | Server error processing the request. |


# FinanceGuru Transaction Search API

## Search Transactions

Retrieve a list of transactions with flexible filtering capabilities.

**URL**
`GET /api/finance-guru/v1/transactions`

**Authentication**
Requires a valid JWT Bearer token.

### Query Parameters

| Parameter | Type | Required | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| [search](file:///Users/saif.vivasoft/IdeaProjects/autobiz/src/main/kotlin/com/bluesea/autobiz/financeGuru/service/TransactionSearchService.kt#50-76) | String | No | Text to search in descriptions and categories (supports fuzzy matching). | `coffee` |
| `category` | String | No | Filter by category name (partial match). | `Food` |
| `type` | String | No | Filter by transaction type: `INCOME`, `EXPENSE`, `TRANSFER`. | `EXPENSE` |
| `startDate` | Date (ISO) | No | Start date for the transaction range (YYYY-MM-DD). | `2025-12-01` |
| `endDate` | Date (ISO) | No | End date for the transaction range (YYYY-MM-DD). | `2025-12-31` |
| `minAmount` | Double | No | Minimum transaction amount. | `100.0` |
| `maxAmount` | Double | No | Maximum transaction amount. | `5000.0` |
| `limit` | Integer | No | Maximum number of results to return (max 200). | `50` |

### Response Structure

The response is a JSON object containing the results.

| Field | Type | Description |
| :--- | :--- | :--- |
| `success` | Boolean | True if the request was successful. |
| [count](file:///Users/saif.vivasoft/IdeaProjects/autobiz/src/main/kotlin/com/bluesea/autobiz/financeGuru/query/SqlHelper.kt#186-200) | Integer | Number of transactions returned. |
| `data` | Array | List of transaction objects. |

** Transaction Object **
| Field | Type | Description |
| :--- | :--- | :--- |
| `transaction_id` | Long | Unique ID of the transaction. |
| `type` | String | Type (INCOME, EXPENSE). |
| `amount` | Number | Transaction amount. |
| `category` | String | Category name. |
| `description` | String | Description. |
| `transaction_date` | Date | Date of the transaction. |
| `created_at` | Timestamp | Server timestamp when created. |
| `relevance_score` | Number | Search relevance score (if search text provided). |

### Example Request

```http
GET /api/finance-guru/v1/transactions?category=Food&startDate=2025-12-01 HTTP/1.1
Authorization: Bearer <your_token>
```

### Example Response

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


# FinanceGuru Chat Feedback API

## Submit Chat Feedback

Allow users to provide feedback ("LIKE" or "DISLIKE") on specific chat messages.

**URL**
`POST /api/finance-guru/v1/chat-history/{id}/feedback`

**Authentication**
Requires a valid JWT Bearer token. The user must be the owner of the chat message.

### Path Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| [id](file:///Users/saif.vivasoft/IdeaProjects/autobiz/src/main/kotlin/com/bluesea/autobiz/financeGuru/query/SqlHelper.kt#54-61) | Integer | Yes | The ID of the chat message (returned in chat history). |

### Request Body

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `feedback` | String | Yes | Feedback value: `LIKE`, `DISLIKE`, or `NONE`. |

### Example Request

```http
POST /api/finance-guru/v1/chat-history/123/feedback HTTP/1.1
Authorization: Bearer <your_token>
Content-Type: application/json

{
  "feedback": "LIKE"
}
```

### Example Response

```json
{
  "success": true,
  "message": "Feedback updated"
}
```

### Error Codes

| Status | Code | Description |
| :--- | :--- | :--- |
| 200 | OK | Success. |
| 400 | BAD_REQUEST | Invalid feedback value or ID. |
| 403 | FORBIDDEN | User does not own the chat message. |
| 404 | NOT_FOUND | Chat message ID not found. |


# FinanceGuru Chat API - Action Types

The [actionType](file:///Users/saif.vivasoft/IdeaProjects/autobiz/src/main/kotlin/com/bluesea/autobiz/financeGuru/query/SqlHelper.kt#30-37) field in the `ChatResponse` indicates the nature of the operation performed or the intent processed. This allows the frontend to render specific UI components (e.g., charts for trends, success cards for transactions).

## Transaction Actions
| Action Type | Description |
| :--- | :--- |
| `record_income` | A single income transaction was successfully recorded. |
| `record_expense` | A single expense transaction was successfully recorded. |
| `record_transaction` | A transaction was recorded (generic fallback). |
| `batch_record_transaction` | Multiple transactions were recorded in a batch. |
| `update_transaction` | An existing transaction was updated. |
| `delete_transaction` | A transaction was deleted. |
| `batch_update_transaction` | Multiple transactions were updated. |
| `batch_delete_transaction` | Multiple transactions were deleted. |
| `search_transactions` | A search for transactions was performed (likely returns a list). |

## Analytics & Reporting
| Action Type | Description |
| :--- | :--- |
| `summary` | A general financial summary was retrieved. |
| `balance`, `get_balance` | Current account balance(s) were retrieved. |
| `top_expenses` | A list of top spending items or categories. |
| `monthly_trend` | Monthly spending/income trend data. |
| `category_breakdown` | Spending breakdown by category (pie chart data). |
| `compare_periods` | Comparison between time periods (e.g., this month vs last). |
| `financial_health` | Financial health score or assessment. |

## Category Management
| Action Type | Description |
| :--- | :--- |
| `list_categories` | A list of available categories was retrieved. |
| `manage_category` | A category was created, updated, or deleted. |

## System & Conversation
| Action Type | Description |
| :--- | :--- |
| `general_chat` | Non-financial conversation (greeting, chit-chat). |
| `clarification_needed` | The bot needs more information to proceed (e.g., "How much?"). |
| `error` | An error occurred while processing the request. |


# FinanceGuru Token Usage API

## Get User Token Usage

Retrieve tracking statistics for the user's token consumption in the FinanceGuru chat system. This data is useful for monitoring usage limits or billing.

**URL**
`GET /api/finance-guru/v1/token-usage`

**Authentication**
Requires a valid JWT Bearer token.

### Response Structure

The response is a JSON object containing usage summary and history.

| Field | Type | Description |
| :--- | :--- | :--- |
| `totalUsage` | Long | Total tokens used by this user over all time. |
| `todayUsage` | Long | Tokens used since midnight (00:00:00) today. |
| `history` | Array | List of recent usage events (last 10). |

**History Item Structure**
| Field | Type | Description |
| :--- | :--- | :--- |
| `amount` | Integer | Number of tokens consumed in this event. |
| [action](file:///Users/saif.vivasoft/IdeaProjects/autobiz/src/main/kotlin/com/bluesea/autobiz/financeGuru/entity/Transaction.kt#10-64) | String | The action type associated with this usage (e.g., `QUERY`, `LOG_EXPENSE`). |
| `timestamp` | DateTime | Timestamp of the event (ISO 8601). |

### Example Request

```http
GET /api/finance-guru/v1/token-usage HTTP/1.1
Authorization: Bearer <your_token>
```

### Example Response

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

### Error Codes

| Status | Code | Description |
| :--- | :--- | :--- |
| 200 | OK | Success. |
| 401 | UNAUTHORIZED | Invalid or missing authentication token. |
| 500 | INTERNAL_SERVER_ERROR | Server error. |


# Finance Guru - chat history api

### Endpoint:
`GET /api/finance-guru/v1/chat-history?page=1&size=20`

### Response:
```
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
        },
        {
            "id": 8,
            "userMessage": "have I paid my gas bill this month?",
            "aiResponse": "✅ **Your gas bill is paid**\n\n#### Details\n\n| **Category** | **Amount (৳)** |\n|--------------|----------------|\n| **Gas**      | **৪২০০.০০**    |\n",
            "createdAt": "2025-12-08T10:33:44.71815",
            "feedback": null
        },
        {
            "id": 7,
            "userMessage": "Change back to expense my bad",
            "aiResponse": "✅ **Transaction Updated**\n\nYour transaction has been updated successfully.",
            "createdAt": "2025-12-08T10:33:18.035269",
            "feedback": null
        },
        {
            "id": 6,
            "userMessage": "Change this to income",
            "aiResponse": "✅ **Transaction Updated**\n\nYour transaction has been updated successfully.",
            "createdAt": "2025-12-08T09:59:50.278489",
            "feedback": null
        },
        {
            "id": 5,
            "userMessage": "Rent 30k",
            "aiResponse": "✅ **Expense Recorded!**\n\n| Field | Value |\n|-------|-------|\n| Amount | ৳30000.00 |\n| Category | rent |",
            "createdAt": "2025-12-08T09:59:36.653459",
            "feedback": null
        },
        {
            "id": 4,
            "userMessage": " 4.2k",
            "aiResponse": "✅ **Expense Recorded!**\n\n| Field | Value |\n|-------|-------|\n| Amount | ৳4200.00 |\n| Category | gas |",
            "createdAt": "2025-12-08T09:59:31.687432",
            "feedback": null
        },
        {
            "id": 3,
            "userMessage": "Paid my gas bill 4k on 2nd december 4.2k",
            "aiResponse": "You mentioned two amounts (4k and 4.2k) for the gas bill on 2nd December. Which amount should be recorded, or are these two separate transactions?",
            "createdAt": "2025-12-08T09:59:24.932858",
            "feedback": null
        },
        {
            "id": 2,
            "userMessage": "Paid my electricity bill 4k on 2nd december",
            "aiResponse": "✅ **Expense Recorded!**\n\n| Field | Value |\n|-------|-------|\n| Amount | ৳4000.00 |\n| Category | electricity |",
            "createdAt": "2025-12-08T09:59:13.948761",
            "feedback": null
        },
        {
            "id": 1,
            "userMessage": "Got salary 100k, put into dps 5k and ate at kfc for 1755 taka. All from SCB bank",
            "aiResponse": "✅ **Batch Transactions Recorded!**\n\n| Summary | Value |\n|---------|-------|\n| Transactions | 3 |\n| Total Expenses | ৳6755.00 |\n| Total Income | ৳100000.00 |",
            "createdAt": "2025-12-08T09:58:28.940849",
            "feedback": null
        }
    ],
    "pagination": {
        "currentPage": 1,
        "limit": 20,
        "returned": 10,
        "hasNext": false,
        "nextPage": null
    }
}
```
#  Finance guru - chat api

### Api Endpoint:
`POST /api/finance-guru/v1/chat`


### Response:
```json
{
    "success": true,
    "message": "#### **Current Balance Summary**\n\n| • | Amount |\n|---|---|\n| **Total Balance** | ৳55,045.00 |\n| **Total Income** | ৳100,000.00 |\n| **Total Expense** | ৳44,955.00 |\n",
    "userId": 5,
    "timestamp": "2025-12-09T07:35:02.666856751",
    "tokenUsage": {
        "promptTokens": 2764,
        "completionTokens": 557,
        "totalTokens": 3321
    },
    "actionType": "get_balance"
}
```

