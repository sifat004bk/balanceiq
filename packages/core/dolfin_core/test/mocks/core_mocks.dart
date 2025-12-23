import 'package:dolfin_core/config/environment_config.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:dolfin_core/database/database_helper.dart';
import 'package:dolfin_core/storage/secure_storage_service.dart';
import 'package:dolfin_core/tour/product_tour_service.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// Database
class MockDatabase extends Mock implements Database {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

// Services
class MockSecureStorageService extends Mock implements SecureStorageService {}

class MockProductTourService extends Mock implements ProductTourService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

// Configuration
class MockAppConstants extends Mock implements AppConstants {}

class MockEnvironmentConfig extends Mock implements EnvironmentConfig {}

// Network
class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

class MockRequestOptions extends Mock implements RequestOptions {}
