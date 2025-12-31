# Market Research: AI-Powered Small Business Finance App

**Date:** January 1, 2026
**Target Audience:** Small Business Owners, Freelancers, Solopreneurs
**Concept:** "Dolfin Biz" - An AI-native CFO that automates bookkeeping, invoicing, and financial insights via chat.

---

## 1. Market Landscape & Competitors

The market is shifting from *passive* accounting software to *active* AI assistants.

| Competitor | Core Value Prop | AI Features | Price Point |
|:-----------|:----------------|:------------|:------------|
| **Xero (JAX)** | Comprehensive Accounting | "Just Ask Xero" - Draft invoices/emails via chat. | $15–$80/mo |
| **Intuit Assist** | Ecosystem Integration | Analyze cash flow, flag anomalies, "what if" scenarios. | Expensive |
| **Ramp** | Spend Management | Automated expense categorization & receipt matching. | Free (makes $ on interchange) |
| **Docyt** | Automation | Real-time bookkeeping & reconciliation. | $50+/mo |
| **Cleo** | Personal Humor | "Roasting" spending habits (Personal finance, but good UI ref). | Freemium |

### gap in the Market
Most competitors are **Legacy Software + AI Plugin**.
*   **Opportunity:** A **Chat-First** platform where the AI *is* the interface, not just a sidebar.
*   **Niche:** "Solopreneurs who hate QuickBooks."

---

## 2. Core Features for "Dolfin Biz"

Based on competitor analysis and small business needs, these are the must-have features, mapped to your Dolfin architecture.

### 🟢 Phase 1: The "AI Bookkeeper" (MVP)
*   **Conversational Dashboard:** "How much did I make this week?" (Uses `feature_chat` + `spending_trend_chart`).
*   **Automated Categorization:** Bank feed imports -> AI suggests "Office Supply" or "Client Meal".
*   **Receipt Capture:** Snap a photo -> AI extracts Date, Amount, Vendor (New `feature_expense`).

### 🟡 Phase 2: The "AI Controller" (Growth)
*   **Smart Invoicing:**
    *   User: "Draft an invoice for Acme Corp for $500 for web design."
    *   AI: Generates PDF invoice & emails it.
*   **Cash Flow Forecasting:** "Can I afford a new laptop next month?" (Predictive modeling).

### 🔴 Phase 3: The "AI CFO" (Scale)
*   **Tax Estimation:** Real-time set-aside recommendations for taxes.
*   **Dunning Management:** AI politely chases overdue invoices.

---

## 3. Technical Feasibility (Dolfin Architecture)

| Feature | Difficulty | Dolfin Component | Strategy |
|:--------|:----------:|:-----------------|:---------|
| **Chat Interface** | 🟢 Low | `feature_chat` | **Reuse 100%**. Change system prompt to "Act as a CFO". |
| **Auth/Login** | 🟢 Low | `feature_auth` | **Reuse 90%**. Add "Business Name" field. |
| **Dashboard** | 🟡 Med | `feature_home` | **Refactor**. Replace "Spending" with "Profit & Loss". |
| **Invoicing** | 🔴 High | `[NEW] feature_invoicing` | Build from scratch. Entities: `Invoice`, `Customer`, `Item`. |
| **Receipt OCR** | 🔴 High | `[NEW] feature_expense` | Integrate Google ML Kit or OpenAI Vision API. |

---

## 4. Monetization Strategy

1.  **Freemium:** Basic bookkeeping + Manual entry.
2.  **Pro ($15/mo):** Bank sync, Unlimited AI Chat, Invoicing.
3.  **Business ($30/mo):** Receipt OCR, Tax export, Cash flow forecasting.

## 5. Unique Selling Point (USP)
**"Accounting without the Interface."**
Unlike QuickBooks where you navigate complex menus, Dolfin Biz lets you manage your business entirely through a chat stream.

> _"Don't fill out a form to send an invoice. Just tell Dolfin to send it."_
