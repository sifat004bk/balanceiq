import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/mock/mock_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_history_response_model.dart';
import '../models/message_model.dart';
import '../../domain/entities/chart_data.dart';
import 'chat_remote_datasource.dart';

/// Mock implementation of ChatRemoteDataSource for testing without API calls
class ChatMockDataSource implements ChatRemoteDataSource {
  final SharedPreferences sharedPreferences;

  ChatMockDataSource(this.sharedPreferences);

  /// Simulate network delay (300-800ms)
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(
      Duration(milliseconds: 300 + DateTime.now().millisecond % 500),
    );
  }

  @override
  Future<MessageModel> sendMessage({
    required String botId,
    required String content,
    String? imagePath,
    String? audioPath,
  }) async {
    // Get user ID from SharedPreferences
    final userId =
        sharedPreferences.getString(GetIt.instance<AppConstants>().keyUserId) ??
            '';

    // Simulate network delay
    await _simulateNetworkDelay();

    // Get contextual response based on bot and message
    final responseText = MockData.getResponse(botId, content);

    // Create mock response message
    final botMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      botId: botId,
      sender: GetIt.instance<AppConstants>().senderBot,
      content: responseText,
      imageUrl: null,
      audioUrl: null,
      timestamp: DateTime.now(),
      isSending: false,
      hasError: false,
    );

    return botMessage;
  }

  @override
  Future<ChatHistoryResponseModel> getChatHistory({
    required String userId,
    required int page,
    int? limit,
  }) async {
    // Simulate network delay
    await _simulateNetworkDelay();

    // Return mock chat history with Gen UI examples
    return ChatHistoryResponseModel(
      userId: int.tryParse(userId) ?? 0,
      conversations: [
        ConversationModel(
          id: 1,
          userMessage: "Show detailed financial report",
          aiResponse:
              'Here is your comprehensive financial report with detailed metrics:',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          feedback: 'LIKE',
          hasTable: true,
          tableData: const GenUITableData(
            rows: [
              {
                'ID': 'TRX-001',
                'Date': '2024-12-14',
                'Type': 'Expense',
                'Category': 'Groceries',
                'Method': 'Credit Card',
                'Bank': 'City Bank',
                'Merchant': 'Shwapno',
                'Amount': '5,200',
                'Tax': '250',
                'Status': 'Completed',
              },
              {
                'ID': 'TRX-002',
                'Date': '2024-12-13',
                'Type': 'Income',
                'Category': 'Salary',
                'Method': 'Bank Transfer',
                'Bank': 'EBL',
                'Merchant': 'Tech Corp',
                'Amount': '125,000',
                'Tax': '12,500',
                'Status': 'Received',
              },
              {
                'ID': 'TRX-003',
                'Date': '2024-12-12',
                'Type': 'Expense',
                'Category': 'Electronics',
                'Method': 'Debit Card',
                'Bank': 'Brac Bank',
                'Merchant': 'Star Tech',
                'Amount': '85,000',
                'Tax': '4,250',
                'Status': 'Processed',
              },
              {
                'ID': 'TRX-004',
                'Date': '2024-12-10',
                'Type': 'Transfer',
                'Category': 'Savings',
                'Method': 'App',
                'Bank': 'Bkash',
                'Merchant': 'Self',
                'Amount': '10,000',
                'Tax': '0',
                'Status': 'Success',
              },
            ],
          ),
        ),
        ConversationModel(
          id: 2,
          userMessage: "Show my portfolio performance trend",
          aiResponse:
              'Here is the performance trend of your investment portfolio over the last 6 months:',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          feedback: null,
          graphType: GraphType.line,
          graphData: const GraphData(
            labels: ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [
              ChartDataset(
                label: 'Portfolio Value (k)',
                data: [120, 135, 128, 142, 155, 165],
              ),
              ChartDataset(
                label: 'Benchmark (k)',
                data: [110, 115, 120, 125, 130, 135],
              ),
            ],
          ),
        ),
        ConversationModel(
          id: 3,
          userMessage: "Analyze expenses by department",
          aiResponse:
              'Here is the expense breakdown across 8 different departments:',
          createdAt: DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          feedback: null,
          graphType: GraphType.bar,
          graphData: const GraphData(
            labels: [
              'HR',
              'IT',
              'Marketing',
              'Sales',
              'Ops',
              'Finance',
              'Legal',
              'R&D'
            ],
            datasets: [
              ChartDataset(
                label: 'Expenses (M)',
                data: [1.2, 3.5, 2.1, 2.8, 1.5, 0.9, 0.5, 4.2],
              ),
            ],
          ),
        ),
      ],
      pagination: PaginationModel(
        currentPage: page,
        limit: limit ?? 20,
        returned: 3,
        hasNext: false,
        nextPage: null,
      ),
    );
  }
}
