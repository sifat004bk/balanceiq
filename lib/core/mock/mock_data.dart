import 'package:balance_iq/core/constants/app_constants.dart';

/// Mock data for testing without real API calls
class MockData {
  // Mock chat responses for different bot types
  static Map<String, List<String>> getChatResponses(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return {
          'general': [
            '```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Total Income", "value": "50,000", "icon": "trending_up", "trend": "up", "color": "#4CAF50"},\n    {"label": "Total Expenses", "value": "4,500", "icon": "shopping_cart", "trend": "down", "color": "#FF5252"},\n    {"label": "Net Balance", "value": "45,500", "icon": "wallet", "trend": "up", "color": "#2196F3"},\n    {"label": "Savings Rate", "value": "91%", "icon": "savings", "trend": "up", "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:chart\n{\n  "type": "pie",\n  "title": "Spending by Category",\n  "data": [\n    {"label": "Food", "value": 2500, "color": "#FF6B6B"},\n    {"label": "Transport", "value": 1000, "color": "#4ECDC4"},\n    {"label": "Shopping", "value": 800, "color": "#95E1D3"},\n    {"label": "Other", "value": 200, "color": "#F9CA24"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Add Transaction", "icon": "add", "style": "primary"},\n    {"label": "View Report", "icon": "chart", "style": "secondary"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "bar",\n  "title": "Income vs Expenses",\n  "data": [\n    {"label": "Income", "value": 50000, "color": "#4CAF50"},\n    {"label": "Expenses", "value": 4500, "color": "#FF5252"}\n  ]\n}\n```\n\n```ui:insight\n{\n  "title": "Great Savings!",\n  "description": "You\'re saving 91% of your income this month. Keep it up!",\n  "icon": "star",\n  "type": "success",\n  "items": [\n    {"title": "Monthly Savings", "value": "45,500 BDT", "icon": "savings"},\n    {"title": "Avg Daily Spending", "value": "150 BDT", "icon": "wallet"},\n    {"title": "Days Till Payday", "value": "12 days", "icon": "info"}\n  ]\n}\n```',
            '```ui:metric\n{\n  "title": "Updated Balance",\n  "value": "95,500 BDT",\n  "change": "+50,000 BDT added",\n  "trend": "up",\n  "icon": "attach_money"\n}\n```\n\n```ui:stats\n{\n  "columns": 3,\n  "stats": [\n    {"label": "This Month", "value": "100K", "icon": "trending_up", "color": "#4CAF50"},\n    {"label": "Last Month", "value": "50K", "icon": "attach_money", "color": "#2196F3"},\n    {"label": "Growth", "value": "+100%", "icon": "chart", "color": "#FF9800"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "line",\n  "title": "7-Day Spending Trend",\n  "data": [\n    {"label": "Mon", "value": 450},\n    {"label": "Tue", "value": 620},\n    {"label": "Wed", "value": 380},\n    {"label": "Thu", "value": 720},\n    {"label": "Fri", "value": 890},\n    {"label": "Sat", "value": 540},\n    {"label": "Sun", "value": 900}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Avg Daily", "value": "643", "icon": "chart", "color": "#4CAF50"},\n    {"label": "Highest Day", "value": "890", "icon": "trending_up", "color": "#FF5252"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "View Breakdown", "icon": "view", "style": "primary"},\n    {"label": "Set Budget", "icon": "target", "style": "secondary"}\n  ]\n}\n```',
          ],
          'balance': [
            '```ui:metric\n{\n  "title": "Total Balance",\n  "value": "45,500 BDT",\n  "change": "+40,500 BDT this month",\n  "trend": "up",\n  "icon": "wallet"\n}\n```\n\n```ui:stats\n{\n  "columns": 3,\n  "stats": [\n    {"label": "Cash", "value": "5.5K", "icon": "wallet", "color": "#4CAF50"},\n    {"label": "Bank", "value": "35K", "icon": "account_balance", "color": "#2196F3"},\n    {"label": "Mobile", "value": "5K", "icon": "payment", "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Monthly Summary",\n  "data": [\n    {"label": "Income", "value": 50000, "color": "#4CAF50"},\n    {"label": "Expenses", "value": 4500, "color": "#FF5252"},\n    {"label": "Savings", "value": 45500, "color": "#2196F3"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Download Report", "icon": "download", "style": "primary"},\n    {"label": "Share", "icon": "share", "style": "secondary"}\n  ]\n}\n```',
          ],
          'expense': [
            '```ui:metric\n{\n  "title": "Expense Recorded",\n  "value": "-500 BDT",\n  "change": "Balance: 45,000 BDT",\n  "trend": "down",\n  "icon": "shopping_cart"\n}\n```\n\n```ui:chart\n{\n  "type": "line",\n  "title": "Last 7 Days",\n  "data": [\n    {"label": "Mon", "value": 450},\n    {"label": "Tue", "value": 620},\n    {"label": "Wed", "value": 380},\n    {"label": "Thu", "value": 720},\n    {"label": "Fri", "value": 890},\n    {"label": "Sat", "value": 540},\n    {"label": "Today", "value": 500}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Today\'s Total", "value": "500", "icon": "shopping_cart", "color": "#FF5252"},\n    {"label": "Weekly Avg", "value": "585", "icon": "chart", "color": "#2196F3"}\n  ]\n}\n```',
          ],
          'income': [
            '```ui:metric\n{\n  "title": "Income Added",\n  "value": "+50,000 BDT",\n  "change": "New Balance: 95,000 BDT",\n  "trend": "up",\n  "icon": "attach_money"\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Previous", "value": "45K", "icon": "wallet", "color": "#9E9E9E"},\n    {"label": "Current", "value": "95K", "icon": "trending_up", "color": "#4CAF50"}\n  ]\n}\n```\n\n```ui:insight\n{\n  "title": "Income Milestone",\n  "description": "You\'ve reached 100K total income this month!",\n  "icon": "star",\n  "type": "success"\n}\n```',
          ],
        };

      case AppConstants.investmentGuruID:
        return {
          'general': [
            '```ui:insight\n{\n  "title": "Investment Tips for Beginners",\n  "description": "Start your investment journey with these key principles",\n  "icon": "lightbulb",\n  "type": "info",\n  "items": [\n    "Start small with low-risk index funds",\n    "Diversify - don\'t put all eggs in one basket",\n    "Stay invested for 5+ years minimum",\n    "Keep 6 months emergency fund first",\n    "Understand what you\'re investing in"\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Recommended", "value": "Index Funds", "icon": "chart", "color": "#4CAF50"},\n    {"label": "Min Period", "value": "5 Years", "icon": "trending_up", "color": "#2196F3"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Learn More", "icon": "details", "style": "primary"},\n    {"label": "Start Investing", "icon": "add", "style": "secondary"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "pie",\n  "title": "Recommended Portfolio Mix",\n  "data": [\n    {"label": "Bonds", "value": 40, "color": "#4CAF50"},\n    {"label": "Stocks", "value": 40, "color": "#2196F3"},\n    {"label": "International", "value": 15, "color": "#FF9800"},\n    {"label": "Alternative", "value": 5, "color": "#9C27B0"}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Expected Return", "value": "8-12%", "icon": "trending_up", "color": "#4CAF50"},\n    {"label": "Risk Level", "value": "Moderate", "icon": "chart", "color": "#2196F3"}\n  ]\n}\n```\n\n```ui:insight\n{\n  "title": "Diversification Benefits",\n  "description": "Spreading investments reduces risk and improves long-term returns",\n  "icon": "check",\n  "type": "success"\n}\n```',
            '```ui:chart\n{\n  "type": "line",\n  "title": "Growth: 10K @ 10% Annual",\n  "data": [\n    {"label": "Y1", "value": 11000},\n    {"label": "Y3", "value": 13310},\n    {"label": "Y5", "value": 16105},\n    {"label": "Y7", "value": 19487},\n    {"label": "Y10", "value": 25937}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 3,\n  "stats": [\n    {"label": "1 Year", "value": "+10%", "icon": "trending_up", "color": "#4CAF50"},\n    {"label": "5 Years", "value": "+61%", "icon": "trending_up", "color": "#2196F3"},\n    {"label": "10 Years", "value": "+159%", "icon": "trending_up", "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:insight\n{\n  "title": "Power of Compounding",\n  "description": "Your 10,000 BDT becomes 25,937 BDT in 10 years!",\n  "icon": "star",\n  "type": "success"\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Calculate My Returns", "icon": "chart", "style": "primary"},\n    {"label": "Start Planning", "icon": "target", "style": "secondary"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "bar",\n  "title": "Sector Performance (YTD)",\n  "data": [\n    {"label": "DSE", "value": 2.3, "color": "#4CAF50"},\n    {"label": "Banking", "value": 6.5, "color": "#2196F3"},\n    {"label": "Tech", "value": 15, "color": "#FF9800"},\n    {"label": "Real Estate", "value": 4.2, "color": "#9C27B0"}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Market Trend", "value": "Positive", "icon": "trending_up", "trend": "up", "color": "#4CAF50"},\n    {"label": "This Week", "value": "+2.3%", "icon": "chart", "trend": "up", "color": "#2196F3"}\n  ]\n}\n```\n\n```ui:insight\n{\n  "title": "Market Outlook",\n  "description": "Tech sector showing strongest growth at 15% annually",\n  "icon": "info",\n  "type": "info",\n  "items": [\n    {"title": "Banking Sector", "value": "Stable 6.5%"},\n    {"title": "Tech Stocks", "value": "Growing 15%"},\n    {"title": "Real Estate", "value": "Moderate 4.2%"}\n  ]\n}\n```',
          ],
        };

      case AppConstants.budgetPlannerID:
        return {
          'general': [
            '```ui:progress\n{\n  "title": "Essential Expenses (50%)",\n  "current": 25000,\n  "target": 25000,\n  "label": "On track ✅"\n}\n```\n\n```ui:progress\n{\n  "title": "Financial Goals (30%)",\n  "current": 12000,\n  "target": 15000,\n  "label": "Save 3,000 more"\n}\n```\n\n```ui:progress\n{\n  "title": "Lifestyle (20%)",\n  "current": 8500,\n  "target": 10000,\n  "label": "1,500 BDT remaining"\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "On Budget", "value": "3/4", "icon": "check", "color": "#4CAF50"},\n    {"label": "Over Budget", "value": "1/4", "icon": "warning", "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Adjust Budget", "icon": "edit", "style": "primary"},\n    {"label": "View History", "icon": "chart", "style": "secondary"}\n  ]\n}\n```',
            '```ui:chart\n{\n  "type": "bar",\n  "title": "Budget vs Actual Spending",\n  "data": [\n    {"label": "Food", "value": 8500, "color": "#FF6B6B"},\n    {"label": "Housing", "value": 15000, "color": "#4ECDC4"},\n    {"label": "Transport", "value": 4000, "color": "#95E1D3"},\n    {"label": "Fun", "value": 5000, "color": "#F9CA24"}\n  ]\n}\n```\n\n```ui:insight\n{\n  "title": "Budget Alert",\n  "description": "You\'re over budget in Food & Dining by 1,500 BDT this month.",\n  "icon": "warning",\n  "type": "warning",\n  "items": [\n    "Reduce eating out to save 1,000 BDT",\n    "Cook at home 3 more times per week",\n    "Set daily spending limit of 250 BDT"\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Budget", "value": "7,000", "icon": "target", "color": "#2196F3"},\n    {"label": "Spent", "value": "8,500", "icon": "restaurant", "color": "#FF5252"}\n  ]\n}\n```',
            '```ui:progress\n{\n  "title": "Monthly Savings Goal",\n  "current": 8200,\n  "target": 10000,\n  "label": "82% Complete - Almost there!"\n}\n```\n\n```ui:insight\n{\n  "title": "Quick Savings Tips",\n  "description": "Save 1,800 BDT more to reach your goal",\n  "icon": "lightbulb",\n  "type": "info",\n  "items": [\n    {"title": "Reduce dining out", "value": "1,000 BDT"},\n    {"title": "Cancel subscriptions", "value": "500 BDT"},\n    {"title": "Use public transport", "value": "300 BDT"}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 3,\n  "stats": [\n    {"label": "Saved", "value": "8.2K", "icon": "savings", "color": "#4CAF50"},\n    {"label": "Goal", "value": "10K", "icon": "target", "color": "#2196F3"},\n    {"label": "To Go", "value": "1.8K", "icon": "trending_up", "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Set Reminder", "icon": "settings", "style": "primary"},\n    {"label": "View Tips", "icon": "lightbulb", "style": "secondary"}\n  ]\n}\n```',
            '```ui:insight\n{\n  "title": "Overspending Alert",\n  "description": "You\'re over budget in 2 categories this month",\n  "icon": "warning",\n  "type": "warning",\n  "items": [\n    {"title": "Food & Dining", "value": "+1,500 BDT"},\n    {"title": "Shopping", "value": "+1,200 BDT"}\n  ]\n}\n```\n\n```ui:chart\n{\n  "type": "bar",\n  "title": "Overspending by Category",\n  "data": [\n    {"label": "Food", "value": 1500, "color": "#FF6B6B"},\n    {"label": "Shopping", "value": 1200, "color": "#FF9F43"}\n  ]\n}\n```\n\n```ui:stats\n{\n  "columns": 2,\n  "stats": [\n    {"label": "Total Over", "value": "2,700", "icon": "trending_down", "color": "#FF5252"},\n    {"label": "Budget Impact", "value": "6%", "icon": "warning", "color": "#FF9800"}\n  ]\n}\n```\n\n```ui:actions\n{\n  "actions": [\n    {"label": "Adjust Budget", "icon": "edit", "style": "primary"},\n    {"label": "View Details", "icon": "view", "style": "secondary"}\n  ]\n}\n```',
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
