import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/database_helper.dart';
import '../../storage/secure_storage_service.dart';
import '../../storage/secure_storage_service_impl.dart';

Future<void> registerStorageModule(GetIt sl) async {
  // External - Must be registered first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Secure Storage
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(),
  );

  // Database
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
