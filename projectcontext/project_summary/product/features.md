# BalanceIQ Feature List (Bangladesh First)

This document outlines the features for BalanceIQ, prioritized for the Bangladesh market launch. Our
strategy is centered on providing the best manual expense tracking experience in the world.

---

## MVP: The Effortless Manual Tracker (Months 1-3)

The focus of the MVP is to make logging cash and mobile money transactions faster and easier than
using a notebook or spreadsheet.

### P0: Critical for Launch

| Feature Name                           | Description                                                                                                                  | User Stories                                                                                                                                                                                                          | Dependencies                               |
|:---------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------|
| **Chat-Based Transaction Logging**     | The core feature. Users can log expenses and income by typing natural language messages in both English and Bangla.          | - As a user, I want to type "Rickshaw 50 taka" and have the expense logged instantly.<br>- As a user, I want to tell the AI "পেট্রোল কিনলাম ৫০০ টাকা" and have it understand and categorize the expense.              | - AI/n8n Backend<br>- Bilingual NLP Model  |
| **AI-Powered Categorization**          | The AI assistant automatically parses the user's text to identify the amount, category, and merchant from a simple sentence. | - As a user, I want the app to automatically categorize "lunch at Khanas" as a 'Food' expense.<br>- As a user, I want to be able to easily correct a category if the AI gets it wrong.                                | - Chat-Based Logging                       |
| **Manual Account Management**          | Users can create and manage different pots of money like 'Cash', 'bKash', 'Nagad', or a bank account to track balances.      | - As a user, I want to create a 'bKash' account and a 'Cash' wallet to track my spending from each.<br>- As a user, I want to specify which account a transaction belongs to, e.g., "Paid rent from my bank account". | - Core Architecture                        |
| **Basic Financial Dashboard**          | The main screen provides a high-level overview of financial health based on manually entered data.                           | - As a user, I want to see a summary of my total spending, income, and balance for the month.<br>- As a user, I want to see a simple chart of my top spending categories.                                             | - Manual Accounts<br>- Transaction Logging |
| **Full Email/Password Authentication** | A complete and secure user authentication system allowing users to sign up, sign in, and recover their password.             | - As a new user, I want to create an account using my email and a secure password.<br>- As a user who forgot my password, I want a simple way to reset it.                                                            | - Backend Infrastructure                   |

### P1: Highly Important (Post-Launch Polish)

| Feature Name                      | Description                                                                               | User Stories                                                                                                                                                              | Dependencies                 |
|:----------------------------------|:------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------|
| **Basic Budgeting**               | Users can create simple monthly spending limits for their most important categories.      | - As a user, I want to set a 5,000 BDT budget for 'Groceries' to control my spending.<br>- As a user, I want to see how much of my budget I have spent so far this month. | - Transaction Categorization |
| **Transaction History & Editing** | A dedicated screen to view, search, and edit all logged transactions.                     | - As a user, I want to see a list of all my expenses from last week.<br>- As a user, I want to fix a typo in an expense I logged yesterday.                               | - Transaction Logging        |
| **Bangla Language UI**            | The entire app interface, including buttons, menus, and settings, is available in Bangla. | - As a user who is more comfortable with Bangla, I want to use the app entirely in my native language.                                                                    | - Localization Framework     |

---

## Phase 1: The Proactive AI Assistant (Months 4-9)

This phase focuses on adding proactive and automated features that form the core of the Premium
offering.

| Feature Name                   | Description                                                                                        | User Stories                                                                                                                                                                                                                  | Dependencies                      |
|:-------------------------------|:---------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------|
| **Voice & Photo Logging**      | Allow users to log expenses by sending a voice message or snapping a picture of a receipt.         | - As a user in a rickshaw, I want to send a voice note saying "rent 50 taka" to log my expense hands-free.<br>- As a user, I want to take a photo of my restaurant bill and have the app automatically read the total amount. | - Speech-to-Text API<br>- OCR API |
| **Spending Alerts & Insights** | The AI assistant provides proactive notifications and simple insights based on spending patterns.  | - As a user, I want a notification if I'm about to exceed my 'Dining Out' budget.<br>- As a user, I want the AI to tell me, "You've spent 30% more on Uber this month compared to last month."                                | - AI/n8n Backend<br>- Budgeting   |
| **Data Export**                | Allow users to export their transaction history to a CSV or Excel file for their personal records. | - As a user, I want to download my full year's expenses to do my own analysis in Excel.                                                                                                                                       | - Transaction History             |
| **Manual Bill Reminders**      | Users can set up manual reminders for recurring payments like rent, internet, or utility bills.    | - As a user, I want to set a reminder for my 5,000 BDT rent payment on the 1st of every month.                                                                                                                                | - Notification System             |

---

## Phase 2: The Financial Wellness Platform (Months 10-18)

This phase expands the app's capabilities beyond simple tracking to holistic financial management,
solidifying long-term retention.

| Feature Name                 | Description                                                                                                       | User Stories                                                                                                                                                                                           | Dependencies           |
|:-----------------------------|:------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------|
| **Savings Goals**            | Users can create goals for specific savings targets (e.g., "iPhone 18," "Wedding Fund") and track their progress. | - As a user, I want to set a goal to save 100,000 BDT for a new phone and track how close I am.<br>- As a user, I want the app to suggest how much I need to save each month to reach my goal on time. | - Manual Accounts      |
| **Shared Budgets**           | Allow family members, partners, or roommates to contribute to and track a shared budget.                          | - As a user, I want to share a 'Household Expenses' budget with my spouse.<br>- As a user, I want to track expenses for a trip with my friends in a shared space.                                      | - User Profile System  |
| **Spending Forecasts**       | The AI predicts future spending and account balances based on historical data.                                    | - As a user, I want the app to warn me, "At your current spending rate, you might run out of cash in your bKash account before your next salary."                                                      | - Advanced AI/ML Model |
| **Community & Gamification** | Introduce features like anonymous spending benchmarks and savings challenges to drive engagement.                 | - As a user, I want to see how my spending on 'Transport' compares to other users in Dhaka.<br>- As a user, I want to join a "No-Buy-July" challenge with my friends.                                  | - User Base > 10k      |