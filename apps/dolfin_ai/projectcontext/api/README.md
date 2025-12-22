# API Documentation

This directory contains all API-related documentation for BalanceIQ.

## Files

### API_SPECIFICATION.md
Complete backend API specification with all endpoints, request/response formats, and status.

**Contents:**
- Authentication APIs (signup, login, profile, password management)
- Finance Guru APIs (dashboard, chat, chat history)
- Response formats and error codes
- Live testing results and status

**Base URL:** `https://dolfinmind.com`
**Last Tested:** 2025-11-29

### API_INTEGRATION.md
n8n webhook integration guide and legacy API documentation.

**Contents:**
- n8n webhook endpoints (chat, dashboard)
- Request/response formats for n8n
- Data flow diagrams
- Error handling patterns
- Testing instructions

**Note:** This documents the legacy n8n workflow APIs. New development should use the backend APIs in API_SPECIFICATION.md.

## Quick Reference

### Backend APIs (Preferred)
```
POST /api/auth/signup              # Register new user
POST /api/auth/login               # Email/password login
GET  /api/auth/me                  # Get user profile
POST /api/auth/forgot-password     # Request password reset
POST /api/auth/reset-password      # Reset password with OTP
POST /api/auth/change-password     # Change password
GET  /api/finance-guru/dashboard   # Get dashboard data
POST /api/finance-guru/chat        # Send chat message
GET  /api/finance-guru/chat-history # Get chat history
```

### n8n Webhooks (Legacy)
```
POST {N8N_WEBHOOK_URL}             # Send chat message
POST {N8N_DASHBOARD_URL}           # Get dashboard data
POST {N8N_CHAT_HISTORY_URL}        # Get chat history
```

## Environment Variables

```bash
# Backend APIs (Primary)
BACKEND_BASE_URL=https://dolfinmind.com

# n8n Webhooks (Legacy)
N8N_WEBHOOK_URL=https://n8n-instance/webhook/balance-iq
N8N_DASHBOARD_URL=https://n8n-instance/webhook-test/get-user-dashboard
N8N_CHAT_HISTORY_URL=https://n8n-instance/webhook/get-user-chat-history

# Mock Mode (Development)
MOCK_MODE=true  # Enable/disable mock data sources
```

## Testing APIs

### Postman Collection
Complete API testing collection available at:
`projectcontext/project_summary/tech/Business.postman_collection.json`

Import this collection into Postman to test all backend endpoints.

### Mock Development
For offline development without backend dependency, see:
`projectcontext/project_summary/tech/MOCK_ENVIRONMENT_GUIDE.md`

## Related Documentation

- **API Implementation**: `/projectcontext/implementation/API_IMPLEMENTATION_SUMMARY.md`
- **UI/API Sync Issues**: `/projectcontext/implementation/UI_LAYER_EVALUATION.md`
- **Backend Architecture**: `/projectcontext/project_summary/tech/backend.md`
- **n8n Workflows**: `/projectcontext/project_summary/tech/n8n.md`

---

**Last Updated**: 2025-11-30
