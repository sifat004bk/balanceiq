import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dolfin_core/constants/api_endpoints.dart';

class AppNetworkConfig {
  static void init() {
    final backendUrl =
        dotenv.get('BACKEND_BASE_URL', fallback: 'http://localhost:8080');

    ApiEndpoints.init(
      backendBaseUrl: backendUrl,
      authBaseUrl:
          dotenv.get('AUTH_BASE_URL', fallback: '$backendUrl/api/auth'),
      agentBaseUrl: dotenv.get('FINANCE_GURU_BASE_URL',
          fallback: '$backendUrl/api/finance-guru'),
    );
  }
}
