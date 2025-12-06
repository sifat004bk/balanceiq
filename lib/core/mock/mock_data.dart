import 'package:balance_iq/core/constants/app_constants.dart';

/// Mock data for testing without real API calls
class MockData {
  // Mock chat responses for different bot types
  static Map<String, List<String>> getChatResponses(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return {
          'general': [
            '✅ Got it! I\'ve recorded your expense.\n\n```ui:metric\n{\n  "title": "Current Balance",\n  "value": "45,500 BDT",\n  "change": "-500 BDT today",\n  "trend": "down",\n  "icon": "wallet"\n}\n```',
            '📊 Here\'s your financial overview:\n\n```ui:metric\n{\n  "title": "Net Balance",\n  "value": "45,500 BDT",\n  "change": "+40,500 BDT this month",\n  "trend": "up",\n  "icon": "trending_up"\n}\n```\n\n**Income vs Expenses:**\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Monthly Summary",\n  "data": [\n    {"label": "Income", "value": 50000, "color": "#4CAF50"},\n    {"label": "Expenses", "value": 4500, "color": "#FF5252"}\n  ]\n}\n```',
            '💰 I\'ve added that income to your account!\n\n```ui:metric\n{\n  "title": "New Balance",\n  "value": "95,500 BDT",\n  "change": "+50,000 BDT",\n  "trend": "up",\n  "icon": "savings"\n}\n```',
            '🎯 Your spending breakdown:\n\n```ui:chart\n{\n  "type": "pie",\n  "title": "Expense Categories",\n  "data": [\n    {"label": "Food", "value": 2500, "color": "#FF6B6B"},\n    {"label": "Transport", "value": 1000, "color": "#4ECDC4"},\n    {"label": "Shopping", "value": 800, "color": "#95E1D3"},\n    {"label": "Other", "value": 200, "color": "#F9CA24"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "View Details", "icon": "view", "style": "primary"},\n    {"label": "Add Expense", "icon": "add", "style": "secondary"}\n  ]\n}\n```',
          ],
          'balance': [
            '💰 Your financial snapshot:\n\n```ui:metric\n{\n  "title": "Total Balance",\n  "value": "45,500 BDT",\n  "change": "+91% savings rate",\n  "trend": "up",\n  "icon": "savings"\n}\n```\n\n**This Month:**\n\n```ui:table\n{\n  "columns": ["Metric", "Amount", "Trend"],\n  "rows": [\n    ["Income", "50,000 BDT", "↑ 15%"],\n    ["Expenses", "4,500 BDT", "↓ 8%"],\n    ["Savings", "45,500 BDT", "↑ 22%"]\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "View Report", "icon": "chart", "style": "primary"},\n    {"label": "Download", "icon": "download", "style": "secondary"}\n  ]\n}\n```',
          ],
          'expense': [
            '✅ Expense recorded!\n\n```ui:metric\n{\n  "title": "Remaining Balance",\n  "value": "45,000 BDT",\n  "change": "-500 BDT",\n  "trend": "down",\n  "icon": "wallet"\n}\n```\n\n**Recent Expenses (Last 7 days):**\n\n```ui:chart\n{\n  "type": "line",\n  "title": "Spending Trend",\n  "data": [\n    {"label": "Mon", "value": 450},\n    {"label": "Tue", "value": 620},\n    {"label": "Wed", "value": 380},\n    {"label": "Thu", "value": 720},\n    {"label": "Fri", "value": 890},\n    {"label": "Sat", "value": 540},\n    {"label": "Sun", "value": 900}\n  ]\n}\n```',
          ],
          'income': [
            '🎉 Income added!\n\n```ui:metric\n{\n  "title": "New Balance",\n  "value": "95,000 BDT",\n  "change": "+50,000 BDT",\n  "trend": "up",\n  "icon": "attach_money"\n}\n```\n\n```ui:table\n{\n  "columns": ["Description", "Amount"],\n  "rows": [\n    ["Previous Balance", "45,000 BDT"],\n    ["Income Added", "+50,000 BDT"],\n    ["New Balance", "95,000 BDT"],\n    ["Monthly Income", "100,000 BDT"]\n  ]\n}\n```',
          ],
        };

      case AppConstants.investmentGuruID:
        return {
          'general': [
            '📈 **Investment Tips for Beginners:**\n\n```ui:table\n{\n  "columns": ["Tip", "Description"],\n  "rows": [\n    ["Start Small", "Begin with low-risk index funds"],\n    ["Diversify", "Don\'t put all eggs in one basket"],\n    ["Long-term", "Stay invested for 5+ years"],\n    ["Emergency Fund", "Keep 6 months expenses first"],\n    ["Learn", "Understand your investments"]\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Learn More", "icon": "details", "style": "primary"},\n    {"label": "Start Investing", "icon": "add", "style": "secondary"}\n  ]\n}\n```',
            '💼 **Portfolio Diversification Strategy:**\n\n```ui:chart\n{\n  "type": "pie",\n  "title": "Recommended Portfolio Mix",\n  "data": [\n    {"label": "Bonds", "value": 40, "color": "#4CAF50"},\n    {"label": "Stocks", "value": 40, "color": "#2196F3"},\n    {"label": "International", "value": 15, "color": "#FF9800"},\n    {"label": "Alternative", "value": 5, "color": "#9C27B0"}\n  ]\n}\n```\n\n```ui:metric\n{\n  "title": "Expected Annual Return",\n  "value": "8-12%",\n  "change": "Moderate risk profile",\n  "trend": "up",\n  "icon": "trending_up"\n}\n```',
            '💹 **Investment Growth Projection:**\n\n```ui:chart\n{\n  "type": "line",\n  "title": "10-Year Growth (10,000 BDT @ 10%)",\n  "data": [\n    {"label": "Y1", "value": 11000},\n    {"label": "Y3", "value": 13310},\n    {"label": "Y5", "value": 16105},\n    {"label": "Y7", "value": 19487},\n    {"label": "Y10", "value": 25937}\n  ]\n}\n```\n\n```ui:table\n{\n  "columns": ["Period", "Investment", "Growth", "Total"],\n  "rows": [\n    ["1 Year", "10,000", "+1,000", "11,000"],\n    ["5 Years", "10,000", "+6,105", "16,105"],\n    ["10 Years", "10,000", "+15,937", "25,937"]\n  ]\n}\n```',
            '📊 **Current Market Trends:**\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Sector Performance (YTD)",\n  "data": [\n    {"label": "DSE", "value": 2.3, "color": "#4CAF50"},\n    {"label": "Banking", "value": 6.5, "color": "#2196F3"},\n    {"label": "Tech", "value": 15, "color": "#FF9800"},\n    {"label": "Real Estate", "value": 4.2, "color": "#9C27B0"}\n  ]\n}\n```\n\n```ui:metric\n{\n  "title": "Market Sentiment",\n  "value": "Positive",\n  "change": "+2.3% this week",\n  "trend": "up",\n  "icon": "trending_up"\n}\n```',
          ],
        };

      case AppConstants.budgetPlannerID:
        return {
          'general': [
            '📋 Here\'s your monthly budget plan:\n\n```ui:progress\n{\n  "title": "Essential Expenses (50%)",\n  "current": 25000,\n  "target": 25000,\n  "label": "25,000 / 25,000 BDT - On track ✅"\n}\n```\n\n```ui:progress\n{\n  "title": "Financial Goals (30%)",\n  "current": 12000,\n  "target": 15000,\n  "label": "12,000 / 15,000 BDT - Save 3,000 more"\n}\n```\n\n```ui:progress\n{\n  "title": "Lifestyle (20%)",\n  "current": 8500,\n  "target": 10000,\n  "label": "8,500 / 10,000 BDT - 1,500 BDT remaining"\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Adjust Budget", "icon": "edit", "style": "primary"},\n    {"label": "View History", "icon": "chart", "style": "secondary"}\n  ]\n}\n```',
            '📊 Category spending analysis:\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Budget vs Actual",\n  "data": [\n    {"label": "Food", "value": 8500, "color": "#FF6B6B"},\n    {"label": "Housing", "value": 15000, "color": "#4ECDC4"},\n    {"label": "Transport", "value": 4000, "color": "#95E1D3"},\n    {"label": "Fun", "value": 5000, "color": "#F9CA24"}\n  ]\n}\n```\n\n⚠️ **Budget Alerts:**\n\n```ui:table\n{\n  "columns": ["Category", "Budget", "Spent", "Status"],\n  "rows": [\n    ["Food", "7,000", "8,500", "⚠️ Over"],\n    ["Housing", "15,000", "15,000", "✅ On track"],\n    ["Transport", "5,000", "4,000", "✅ Under"],\n    ["Fun", "5,000", "5,000", "✅ On track"]\n  ]\n}\n```',
            '💡 Savings goal tracker:\n\n```ui:progress\n{\n  "title": "Monthly Savings Goal",\n  "current": 8200,\n  "target": 10000,\n  "label": "1,800 BDT to go! You\'re at 82%"\n}\n```\n\n**How to reach your goal:**\n\n```ui:table\n{\n  "columns": ["Action", "Potential Savings"],\n  "rows": [\n    ["Reduce dining out", "1,000 BDT"],\n    ["Cancel subscriptions", "500 BDT"],\n    ["Use public transport", "300 BDT"]\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Set Reminder", "icon": "settings", "style": "primary"},\n    {"label": "View Tips", "icon": "details", "style": "secondary"}\n  ]\n}\n```',
            '⚠️ **Budget Alert Analysis:**\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Overspending Categories",\n  "data": [\n    {"label": "Food", "value": 8500, "color": "#FF6B6B"},\n    {"label": "Shopping", "value": 4200, "color": "#FF9F43"}\n  ]\n}\n```\n\n**Recommendations:**\n\n```ui:table\n{\n  "columns": ["Category", "Over By", "Tip"],\n  "rows": [\n    ["Food & Dining", "+1,500 BDT", "Reduce eating out"],\n    ["Shopping", "+1,200 BDT", "Wait 24hrs before buying"]\n  ]\n}\n```',
          ],
        };

      case AppConstants.finTipsID:
        return {
          'general': [
            '💡 **50/30/20 Money Management Rule:**\n\n```ui:chart\n{\n  "type": "pie",\n  "title": "Budget Allocation Strategy",\n  "data": [\n    {"label": "Needs", "value": 50, "color": "#4CAF50"},\n    {"label": "Wants", "value": 30, "color": "#2196F3"},\n    {"label": "Savings", "value": 20, "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:table\n{\n  "columns": ["Category", "Percentage", "Example (50K)"],\n  "rows": [\n    ["Needs", "50%", "25,000 BDT"],\n    ["Wants", "30%", "15,000 BDT"],\n    ["Savings", "20%", "10,000 BDT"]\n  ]\n}\n```',
            '📚 **Compound Interest Power:**\n\n```ui:chart\n{\n  "type": "line",\n  "title": "10,000 BDT @ 10% Annual Return",\n  "data": [\n    {"label": "Start", "value": 10000},\n    {"label": "5Y", "value": 16105},\n    {"label": "10Y", "value": 25937},\n    {"label": "15Y", "value": 41772},\n    {"label": "20Y", "value": 67275}\n  ]\n}\n```\n\n```ui:metric\n{\n  "title": "20-Year Growth",\n  "value": "67,275 BDT",\n  "change": "+57,275 BDT profit (572%)",\n  "trend": "up",\n  "icon": "trending_up"\n}\n```\n\n*The key is time. Start early!*',
            '🚨 **Emergency Fund Progress:**\n\n```ui:progress\n{\n  "title": "Emergency Fund Goal (6 months)",\n  "current": 75000,\n  "target": 150000,\n  "label": "75,000 / 150,000 BDT - Halfway there!"\n}\n```\n\n**Where to keep it:**\n\n```ui:table\n{\n  "columns": ["Account Type", "Interest", "Liquidity"],\n  "rows": [\n    ["Savings", "4-5%", "✅ High"],\n    ["Liquid Funds", "6-7%", "✅ High"],\n    ["FD (3-6m)", "7-8%", "⚠️ Medium"]\n  ]\n}\n```\n\n**When to use:**\n- Job loss\n- Medical emergencies  \n- Urgent repairs\n- NOT for vacations!',
            '💳 **Credit Card Best Practices:**\n\n```ui:table\n{\n  "columns": ["DO ✅", "DON\'T ❌"],\n  "rows": [\n    ["Pay full balance monthly", "Carry balance"],\n    ["Use for rewards", "Only minimum payment"],\n    ["Set up autopay", "Max out cards"],\n    ["Track weekly", "Too many cards"],\n    ["Keep <30% utilization", "Impulse purchases"]\n  ]\n}\n```\n\n```ui:metric\n{\n  "title": "Recommended Utilization",\n  "value": "<30%",\n  "change": "Helps credit score",\n  "trend": "neutral",\n  "icon": "payment"\n}\n```',
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
