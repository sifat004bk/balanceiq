import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE ${AppConstants.usersTable} (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        photo_url TEXT,
        auth_provider TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create messages table
    await db.execute('''
      CREATE TABLE ${AppConstants.messagesTable} (
        id TEXT PRIMARY KEY,
        bot_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        content TEXT NOT NULL,
        image_url TEXT,
        audio_url TEXT,
        timestamp TEXT NOT NULL,
        is_sending INTEGER NOT NULL DEFAULT 0,
        has_error INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Create index on bot_id and timestamp for efficient queries
    await db.execute('''
      CREATE INDEX idx_messages_bot_timestamp
      ON ${AppConstants.messagesTable}(bot_id, timestamp)
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle future database upgrades
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
