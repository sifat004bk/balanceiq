import 'package:dolfin_core/constants/app_constants.dart';

/// Mock data for testing without real API calls
class MockData {
  // Mock chat responses for different bot types
  static Map<String, List<String>> getChatResponses(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return {
          'general': [
            '```ui:summary_card\n{\n  "title": "Total Balance",\n  "value": "45,500 BDT",\n  "trend": "+12%",\n  "trendColor": "green",\n  "icon": "wallet"\n}\n```\n\n```ui:chart\n{\n  "type": "pie",\n  "title": "Spending by Category",\n  "data": [\n    {"label": "Food", "value": 2500, "color": "#FF6B6B"},\n    {"label": "Transport", "value": 1000, "color": "#4ECDC4"},\n    {"label": "Shopping", "value": 800, "color": "#95E1D3"},\n    {"label": "Other", "value": 200, "color": "#F9CA24"}\n  ]\n}\n```\n\n```ui:table\n{\n  "columns": ["Category", "Spent", "Budget"],\n  "rows": [\n    ["Food", "2,500", "3,000"],\n    ["Transport", "1,000", "1,500"],\n    ["Shopping", "800", "1,000"]\n  ]\n}\n```\n\n```ui:action_list\n{\n  "title": "Quick Actions",\n  "actions": [\n    {"label": "Add Transaction", "action": "add_transaction"},\n    {"label": "View Report", "action": "view_report"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "bar",\n  "title": "Income vs Expenses",\n  "data": [\n    {"label": "Income", "value": 50000, "color": "#4CAF50"},\n    {"label": "Expenses", "value": 4500, "color": "#FF5252"}\n  ],\n  "gradient": true\n}\n```\n\n```ui:summary_card\n{\n  "title": "Great Savings!",\n  "value": "91% Saved",\n  "trend": "Excellent",\n  "trendColor": "green",\n  "icon": "savings"\n}\n```',
            '```ui:summary_card\n{\n  "title": "Updated Balance",\n  "value": "95,500 BDT",\n  "trend": "+50,000",\n  "trendColor": "green",\n  "icon": "trending_up"\n}\n```\n\n```ui:chart\n{\n  "type": "line",\n  "title": "7-Day Spending Trend",\n  "data": [\n    {"label": "Mon", "value": 450},\n    {"label": "Tue", "value": 620},\n    {"label": "Wed", "value": 380},\n    {"label": "Thu", "value": 720},\n    {"label": "Fri", "value": 890},\n    {"label": "Sat", "value": 540},\n    {"label": "Sun", "value": 900}\n  ],\n  "gradient": true\n}\n```\n\n```ui:action_list\n{\n  "title": "Next Steps",\n  "actions": [\n    {"label": "View Breakdown", "action": "view_breakdown"},\n    {"label": "Set Budget", "action": "set_budget"}\n  ]\n}\n```',
          ],
          'balance': [
            '```ui:summary_card\n{\n  "title": "Total Balance",\n  "value": "45,500 BDT",\n  "trend": "+40.5K",\n  "trendColor": "green",\n  "icon": "wallet"\n}\n```\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Monthly Summary",\n  "data": [\n    {"label": "Income", "value": 50000, "color": "#4CAF50"},\n    {"label": "Expenses", "value": 4500, "color": "#FF5252"},\n    {"label": "Savings", "value": 45500, "color": "#2196F3"}\n  ],\n  "gradient": true\n}\n```\n\n```ui:action_list\n{\n  "title": "Options",\n  "actions": [\n    {"label": "Download Report", "action": "download"},\n    {"label": "Share", "action": "share"}\n  ]\n}\n```',
          ],
          'expense': [
            '```ui:summary_card\n{\n  "title": "Expense Recorded",\n  "value": "500 BDT",\n  "trend": "Balance: 45K",\n  "trendColor": "grey",\n  "icon": "shopping_bag"\n}\n```\n\n```ui:chart\n{\n  "type": "line",\n  "title": "Last 7 Days",\n  "data": [\n    {"label": "Mon", "value": 450},\n    {"label": "Tue", "value": 620},\n    {"label": "Wed", "value": 380},\n    {"label": "Thu", "value": 720},\n    {"label": "Fri", "value": 890},\n    {"label": "Sat", "value": 540},\n    {"label": "Today", "value": 500}\n  ],\n  "gradient": true\n}\n```',
          ],
          'income': [
            '```ui:summary_card\n{\n  "title": "Income Added",\n  "value": "+50,000 BDT",\n  "trend": "New: 95K",\n  "trendColor": "green",\n  "icon": "trending_up"\n}\n```\n\n```ui:summary_card\n{\n  "title": "Income Milestone",\n  "value": "100K Total",\n  "trend": "Target Hit",\n  "trendColor": "green",\n  "icon": "savings"\n}\n```',
          ],
        };

      case AppConstants.investmentGuruID:
        return {
          'general': [
            '```ui:summary_card\n{\n  "title": "Investment Tip",\n  "value": "Start Small",\n  "trend": "Low Risk",\n  "trendColor": "green",\n  "icon": "lightbulb"\n}\n```\n\n```ui:action_list\n{\n  "title": "Learn More",\n  "actions": [\n    {"label": "Read Guide", "action": "read_guide"},\n    {"label": "Start Investing", "action": "start_investing"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "pie",\n  "title": "Recommended Portfolio",\n  "data": [\n    {"label": "Bonds", "value": 40, "color": "#4CAF50"},\n    {"label": "Stocks", "value": 40, "color": "#2196F3"},\n    {"label": "Intl", "value": 15, "color": "#FF9800"},\n    {"label": "Alt", "value": 5, "color": "#9C27B0"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "line",\n  "title": "Growth Projection (10Y)",\n  "data": [\n    {"label": "Y1", "value": 11000},\n    {"label": "Y3", "value": 13310},\n    {"label": "Y5", "value": 16105},\n    {"label": "Y7", "value": 19487},\n    {"label": "Y10", "value": 25937}\n  ],\n  "gradient": true\n}\n```\n\n```ui:summary_card\n{\n  "title": "Compound Interest",\n  "value": "2.5x Growth",\n  "trend": "10 Years",\n  "trendColor": "green",\n  "icon": "trending_up"\n}\n```',
          ],
        };

      case AppConstants.budgetPlannerID:
        return {
          'general': [
            '```ui:summary_card\n{\n  "title": "Essential Expenses",\n  "value": "50% Used",\n  "trend": "On Track",\n  "trendColor": "green",\n  "icon": "check"\n}\n```\n\n```ui:action_list\n{\n  "title": "Actions",\n  "actions": [\n    {"label": "Adjust Budget", "action": "adjust_budget"},\n    {"label": "View History", "action": "view_history"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "bar",\n  "title": "Budget vs Actual",\n  "data": [\n    {"label": "Food", "value": 8500, "color": "#FF6B6B"},\n    {"label": "Rent", "value": 15000, "color": "#4ECDC4"},\n    {"label": "Travel", "value": 4000, "color": "#95E1D3"}\n  ],\n  "gradient": true\n}\n```\n\n```ui:summary_card\n{\n  "title": "Budget Alert",\n  "value": "Food Over",\n  "trend": "-1,500",\n  "trendColor": "red",\n  "icon": "shopping_bag"\n}\n```',
          ],
        };

      case AppConstants.finTipsID:
        return {
          'general': [
            '💡 **50/30/20 Rule:**\n\n```ui:chart\n{\n  "type": "pie",\n  "title": "Budget Allocation",\n  "data": [\n    {"label": "Needs", "value": 50, "color": "#4CAF50"},\n    {"label": "Wants", "value": 30, "color": "#2196F3"},\n    {"label": "Savings", "value": 20, "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:table\n{\n  "columns": ["Category", "Percentage", "Example"],\n  "rows": [\n    ["Needs", "50%", "25k"],\n    ["Wants", "30%", "15k"],\n    ["Savings", "20%", "10k"]\n  ]\n}\n```',
            '📚 **Compound Interest:**\n\n```ui:chart\n{\n  "type": "line",\n  "title": "Growth Curve",\n  "data": [\n    {"label": "Start", "value": 10000},\n    {"label": "5Y", "value": 16105},\n    {"label": "10Y", "value": 25937},\n    {"label": "20Y", "value": 67275}\n  ],\n  "gradient": true\n}\n```\n\n```ui:summary_card\n{\n  "title": "20-Year Growth",\n  "value": "67,275 BDT",\n  "trend": "+572%",\n  "trendColor": "green",\n  "icon": "trending_up"\n}\n```',
            '🚨 **Emergency Fund:**\n\n```ui:summary_card\n{\n  "title": "Fund Goal",\n  "value": "75,000 BDT",\n  "trend": "50% Done",\n  "trendColor": "green",\n  "icon": "savings"\n}\n```\n\n```ui:table\n{\n  "columns": ["Type", "Interest", "Liquidity"],\n  "rows": [\n    ["Savings", "4-5%", "High"],\n    ["FD", "7-8%", "Medium"]\n  ]\n}\n```',
            '💳 **Credit Card Tips:**\n\n```ui:table\n{\n  "columns": ["DO ✅", "DON\'T ❌"],\n  "rows": [\n    ["Pay Full", "Carry Balance"],\n    ["Rewards", "Min Payment"],\n    ["Autopay", "Max Out"]\n  ]\n}\n```\n\n```ui:summary_card\n{\n  "title": "Utilization",\n  "value": "<30%",\n  "trend": "Good",\n  "trendColor": "green",\n  "icon": "credit_card"\n}\n```',
          ],
        };

      default:
        return {
          'general': [
            'I can help you with financial management. What would you like to know?',
          ],
        };
    }
  }

  // Get a random response based on message content
  static String getResponse(String botId, String userMessage) {
    final responses = getChatResponses(botId);
    final lowerMessage = userMessage.toLowerCase();

    // Balance Tracker specific
    if (botId == AppConstants.balanceTrackerID) {
      if (lowerMessage.contains('balance') ||
          lowerMessage.contains('how much') ||
          lowerMessage.contains('total')) {
        return responses['balance']!.first;
      } else if (lowerMessage.contains('spent') ||
          lowerMessage.contains('expense') ||
          lowerMessage.contains('bought')) {
        return responses['expense']!.first;
      } else if (lowerMessage.contains('income') ||
          lowerMessage.contains('salary') ||
          lowerMessage.contains('received')) {
        return responses['income']!.first;
      }
    }

    // Return random response from general category
    final generalResponses = responses['general']!;
    return generalResponses[
        DateTime.now().millisecond % generalResponses.length];
  }

  // Mock dashboard summary data matching DashboardSummaryModel structure
  static Map<String, dynamic> getMockDashboardSummary({
    required String userId,
    required String botId,
  }) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysRemaining = daysInMonth - now.day;

    return {
      // Required fields for DashboardSummaryModel
      'total_income': 50000.0,
      'total_expense': 4500.0,
      'net_balance': 45500.0,
      'expense_ratio': 0.09, // 4500 / 50000
      'savings_rate': 0.91, // 45500 / 50000
      'income_transactions': 2,
      'expense_transactions': 8,
      'avg_income': 25000.0, // 50000 / 2 transactions
      'avg_expense': 562.5, // 4500 / 8 transactions

      // Spending trend (last 7 days)
      'spending_trend': [
        {'day': 1, 'amount': 450.0},
        {'day': 2, 'amount': 620.0},
        {'day': 3, 'amount': 380.0},
        {'day': 4, 'amount': 720.0},
        {'day': 5, 'amount': 890.0},
        {'day': 6, 'amount': 540.0},
        {'day': 7, 'amount': 900.0},
      ],

      // Categories as Map<String, double> (category_name: amount)
      'categories': {
        'Food & Dining': 2500.0,
        'Transportation': 1000.0,
        'Shopping': 800.0,
        'Entertainment': 150.0,
        'Others': 50.0,
      },

      // Accounts breakdown as Map<String, double> (account_name: balance)
      'accounts_breakdown': {
        'Cash': 5500.0,
        'Bank': 35000.0,
        'Mobile Banking': 5000.0,
      },

      // Biggest expense details
      'biggest_expense_amount': 1200.0,
      'biggest_expense_description': 'Clothing purchase at shopping mall',
      'expense_category': 'Shopping',
      'expense_account': 'Bank',

      // Biggest category details
      'biggest_category_name': 'Food & Dining',
      'biggest_category_amount': 2500.0,

      // Period information
      'period': 'January 2025',
      'days_remaining_in_month': daysRemaining,
    };
  }
}
