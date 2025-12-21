import 'package:get_it/get_it.dart';
import "package:dolfin_core/constants/app_constants.dart";
import "package:dolfin_core/utils/app_logger.dart";

// Features - Dashboard
import '../../../features/home/data/datasource/remote_datasource/dashboard_finance_guru_datasource.dart';
import '../../../features/home/data/datasource/remote_datasource/dashboard_mock_datasource.dart';
import '../../../features/home/data/datasource/remote_datasource/dashboard_remote_datasource.dart';
import '../../../features/home/data/repository/dashboard_repository_impl.dart';
import '../../../features/home/domain/repository/dashboard_repository.dart';
import '../../../features/home/domain/usecase/get_user_dashbaord.dart';
import '../../../features/home/presentation/cubit/dashboard_cubit.dart';
import '../../../features/home/presentation/cubit/transactions_cubit.dart';
import '../../../features/home/presentation/cubit/transaction_filter_cubit.dart';

// Features - Home (Transaction Search)
import '../../../features/home/data/datasource/remote_datasource/transaction_search_datasource.dart';
import '../../../features/home/data/repositories/transaction_repository_impl.dart';
import '../../../features/home/domain/repositories/transaction_repository.dart';
import '../../../features/home/domain/usecases/search_transactions.dart';
import '../../../features/home/domain/usecases/update_transaction.dart';
import '../../../features/home/domain/usecases/delete_transaction.dart';

void registerDashboardModule(GetIt sl) {
  //! Features - Dashboard
  // Cubit
  sl.registerFactory(() => DashboardCubit(getDashboardSummary: sl()));
  sl.registerFactory(() => TransactionFilterCubit());
  sl.registerFactory(
    () => TransactionsCubit(
      searchTransactions: sl(),
      updateTransactionUseCase: sl(),
      deleteTransactionUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDashboardSummary(sl()));

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
      authLocalDataSource: sl(), // Use existing AuthLocalDataSource
    ),
  );

  // Data sources
  // Conditionally register mock or real API dashboard datasource
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () {
      if (AppConstants.isMockMode) {
        AppLogger.debug('Registering MOCK DashboardRemoteDataSource',
            name: 'DI');
        return DashboardMockDataSource();
      } else {
        AppLogger.debug(
            'Registering REAL DashboardRemoteDataSource (Finance Guru API)',
            name: 'DI');
        return DashboardFinanceGuruDataSource(sl(), sl());
      }
    },
  );

  //! Features - Transaction Search
  // Use cases
  sl.registerLazySingleton(() => SearchTransactions(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TransactionSearchDataSource>(
    () => TransactionSearchDataSourceImpl(sl(), sl()),
  );
}
