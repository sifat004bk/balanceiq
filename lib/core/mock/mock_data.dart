import 'package:balance_iq/core/constants/app_constants.dart';

/// Mock data for testing without real API calls
class MockData {
  // Mock chat responses for different bot types
  static Map<String, List<String>> getChatResponses(String botId) {
    switch (botId) {
      case AppConstants.balanceTrackerID:
        return {
          'general': [
            '✅ Got it! I\'ve recorded your expense. Your current balance is **45,500 BDT**.',
            '📊 Based on your recent transactions:\n\n- Total Income: **50,000 BDT**\n- Total Expenses: **4,500 BDT**\n- Current Balance: **45,500 BDT**',
            '💰 I\'ve added that income to your account. Your updated balance is **95,500 BDT**.',
            '🎯 Here\'s your spending breakdown for this month:\n\n**Top Categories:**\n1. Food & Dining - 2,500 BDT (55%)\n2. Transportation - 1,000 BDT (22%)\n3. Shopping - 800 BDT (18%)\n4. Others - 200 BDT (5%)',
          ],
          'balance': [
            '💰 Your current financial status:\n\n**Total Balance:** 45,500 BDT\n**This Month:**\n- Income: 50,000 BDT\n- Expenses: 4,500 BDT\n- Savings: 45,500 BDT (91%)',
          ],
          'expense': [
            '✅ Expense recorded successfully!\n\n**Transaction Details:**\n- Amount: 500 BDT\n- Category: Auto-detected\n- Remaining Balance: 45,000 BDT',
          ],
          'income': [
            '🎉 Income added to your account!\n\n**Transaction Details:**\n- Amount: 50,000 BDT\n- New Balance: 95,000 BDT\n- Monthly Income: 100,000 BDT',
          ],
        };

      case AppConstants.investmentGuruID:
        return {
          'general': [
            '📈 **Investment Tips for Beginners:**\n\n1. **Start Small**: Begin with low-risk investments like index funds\n2. **Diversify**: Don\'t put all eggs in one basket\n3. **Long-term Focus**: Stay invested for at least 5+ years\n4. **Emergency Fund**: Keep 6 months expenses before investing\n5. **Learn Continuously**: Understand what you\'re investing in',
            '💼 **Stocks vs Mutual Funds:**\n\n**Stocks:**\n- Higher potential returns\n- More volatile\n- Requires active management\n- Best for experienced investors\n\n**Mutual Funds:**\n- Professional management\n- Diversified automatically\n- Lower risk\n- Better for beginners',
            '🎯 **Portfolio Diversification Strategy:**\n\n**Conservative (Low Risk):**\n- 60% Bonds/Fixed Income\n- 30% Large-cap stocks\n- 10% Cash/Emergency fund\n\n**Moderate (Medium Risk):**\n- 40% Bonds\n- 40% Stocks (mix of large/mid-cap)\n- 15% International funds\n- 5% Alternative investments',
            '📊 **Current Market Trends (Mock Data):**\n\n- **Dhaka Stock Exchange**: +2.3% this week\n- **Banking Sector**: Stable with dividend yields 5-7%\n- **Tech Stocks**: Growing at 15% annually\n- **Real Estate**: Moderate growth in major cities',
          ],
        };

      case AppConstants.budgetPlannerID:
        return {
          'general': [
            '📋 **Monthly Budget Plan (Based on 50,000 BDT):**\n\n**Essential (50%)**\n- Rent/Housing: 15,000 BDT\n- Utilities: 3,000 BDT\n- Food: 7,000 BDT\n\n**Financial Goals (30%)**\n- Savings: 10,000 BDT\n- Investments: 5,000 BDT\n\n**Lifestyle (20%)**\n- Entertainment: 5,000 BDT\n- Shopping: 3,000 BDT\n- Misc: 2,000 BDT',
            '📊 **Your spending by category this month:**\n\n1. 🍽️ **Food & Dining**: 8,500 BDT (38%)\n   - Budget: 7,000 BDT\n   - ⚠️ Over by 1,500 BDT\n\n2. 🏠 **Housing**: 15,000 BDT (33%)\n   - Budget: 15,000 BDT\n   - ✅ On track\n\n3. 🚗 **Transportation**: 4,000 BDT (18%)\n   - Budget: 5,000 BDT\n   - ✅ Under budget\n\n4. 🎬 **Entertainment**: 5,000 BDT (11%)\n   - Budget: 5,000 BDT\n   - ✅ On track',
            '💡 **How to save 20% of your income:**\n\n**Step 1: Automate Savings**\n- Set up automatic transfer on payday\n- Save 10,000 BDT (20% of 50,000 BDT)\n\n**Step 2: Cut Unnecessary Expenses**\n- Cancel unused subscriptions\n- Cook at home more often\n- Use public transport\n\n**Step 3: Track Everything**\n- Use this app to monitor spending\n- Review weekly\n- Adjust budget as needed',
            '⚠️ **Budget Alert Analysis:**\n\nYou\'re overspending in:\n\n1. **Food & Dining** (+21%)\n   - Current: 8,500 BDT\n   - Budget: 7,000 BDT\n   - Tip: Reduce eating out\n\n2. **Shopping** (+40%)\n   - Current: 4,200 BDT\n   - Budget: 3,000 BDT\n   - Tip: Wait 24hrs before purchases',
          ],
        };

      case AppConstants.finTipsID:
        return {
          'general': [
            '💡 **Practical Money Management Tips:**\n\n1. **50/30/20 Rule**\n   - 50% Needs (housing, food)\n   - 30% Wants (entertainment)\n   - 20% Savings & investments\n\n2. **Track Every Expense**\n   - Use apps like this one\n   - Review weekly\n   - Identify patterns\n\n3. **Avoid Lifestyle Inflation**\n   - Don\'t increase spending with salary\n   - Save the difference\n\n4. **Build Emergency Fund**\n   - 6 months of expenses\n   - Keep in liquid accounts',
            '📚 **Understanding Compound Interest:**\n\n**Simple Example:**\nInvest 10,000 BDT at 10% annual interest\n\n- **Year 1**: 10,000 + 1,000 = 11,000 BDT\n- **Year 2**: 11,000 + 1,100 = 12,100 BDT\n- **Year 5**: 16,105 BDT\n- **Year 10**: 25,937 BDT\n- **Year 20**: 67,275 BDT\n\n*The key is time. Start early!*',
            '🚨 **Emergency Fund Guide:**\n\n**How much to save:**\n- Minimum: 3 months expenses\n- Recommended: 6 months\n- Ideal: 12 months\n\n**Where to keep it:**\n- High-interest savings account\n- Liquid mutual funds\n- Fixed deposits (short-term)\n\n**When to use:**\n- Job loss\n- Medical emergencies\n- Urgent home repairs\n- NOT for vacations or shopping!',
            '💳 **Credit Card Best Practices:**\n\n**DO:**\n✅ Pay full balance every month\n✅ Use for rewards/cashback\n✅ Set up autopay\n✅ Track spending weekly\n✅ Keep utilization under 30%\n\n**DON\'T:**\n❌ Carry balance month-to-month\n❌ Make only minimum payments\n❌ Max out cards\n❌ Apply for too many cards\n❌ Use for impulse purchases',
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
