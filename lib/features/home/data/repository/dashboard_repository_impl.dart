import 'package:balance_iq/core/error/failures.dart';
import 'package:balance_iq/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:balance_iq/features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import 'package:balance_iq/features/home/domain/entities/dashbaord_summary.dart';
import 'package:balance_iq/features/home/domain/repository/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, DashboardSummary>> getDashboardSummary() async {
    try {
      // Get user from auth cache
      final user = await authLocalDataSource.getCachedUser();

      if (user == null) {
        return const Left(AuthFailure('User not logged in'));
      }

      // Validate user ID
      if (user.id.isEmpty) {
        return const Left(AuthFailure('Invalid user ID'));
      }

      // Split name into first and last name with type safety
      final String fullName = user.name;
      final List<String> nameParts = fullName.split(' ');
      final String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final String lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Get bot ID from environment (consider making this configurable)
      const String botId = 'balance_iq';

      // Fetch dashboard data
      final DashboardSummary dashboard =
          await remoteDataSource.getDashboardSummary(
        userId: "8130001838", //TODO: Change this
        botId: botId,
        firstName: firstName,
        lastName: lastName,
        username: user.email,
      );

      return Right(dashboard);
    } on FormatException catch (e) {
      // Handle JSON parsing errors
      return Left(ServerFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      final String errorMessage = e.toString();

      // Check for specific error cases
      if (errorMessage.contains('No dashboard data available')) {
        return const Left(ServerFailure('No dashboard data available'));
      }

      if (errorMessage.contains('Connection timeout')) {
        return const Left(ServerFailure(
            'Connection timeout. Please check your internet connection.'));
      }

      if (errorMessage.contains('No internet connection')) {
        return const Left(ServerFailure(
            'No internet connection. Please check your network.'));
      }

      if (errorMessage.contains('Server error')) {
        return const Left(
            ServerFailure('Server error. Please try again later.'));
      }

      return Left(ServerFailure(errorMessage));
    } catch (e) {
      // Catch-all for unexpected errors
      return Left(ServerFailure('Failed to load dashboard: ${e.toString()}'));
    }
  }
}
