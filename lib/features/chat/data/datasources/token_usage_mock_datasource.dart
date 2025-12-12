import '../models/token_usage_model.dart';
import 'token_usage_datasource.dart';

class TokenUsageMockDataSource implements TokenUsageDataSource {
  @override
  Future<TokenUsageModel> getTokenUsage() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return TokenUsageModel(
      todayUsage: 1234,
      totalUsage: 1234,
      history: [],
    );
  }
}
