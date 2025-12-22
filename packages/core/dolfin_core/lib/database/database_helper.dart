import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../utils/app_logger.dart';
import 'package:get_it/get_it.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(GetIt.instance<AppConstants>().databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: GetIt.instance<AppConstants>().databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE ${GetIt.instance<AppConstants>().usersTable} (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        photo_url TEXT,
        auth_provider TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create messages table (v3 schema with user_id for isolation)
    await db.execute('''
      CREATE TABLE ${GetIt.instance<AppConstants>().messagesTable} (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        bot_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        content TEXT NOT NULL,
        image_url TEXT,
        audio_url TEXT,
        timestamp TEXT NOT NULL,
        is_sending INTEGER NOT NULL DEFAULT 0,
        has_error INTEGER NOT NULL DEFAULT 0,

        -- Sync fields (v2)
        server_created_at TEXT,
        is_synced INTEGER DEFAULT 0,
        sync_status TEXT DEFAULT 'pending',
        api_message_id TEXT,
        action_type TEXT,
        conversation_id INTEGER,
        feedback TEXT,

        -- Chart data fields (v7)
        has_table INTEGER DEFAULT 0,
        table_data TEXT,
        graph_type TEXT,
        graph_data TEXT,

        -- Deduplication constraint (v3: includes user_id)
        CONSTRAINT unique_message UNIQUE (user_id, bot_id, sender, server_created_at, content)
      )
    ''');

    // Create indexes for efficient queries (v3: includes user_id)
    await db.execute('''
      CREATE INDEX idx_messages_user_bot_server_time
      ON ${GetIt.instance<AppConstants>().messagesTable}(user_id, bot_id, server_created_at DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_user_bot_timestamp
      ON ${GetIt.instance<AppConstants>().messagesTable}(user_id, bot_id, timestamp DESC)
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Migrate from version 1 to 2: Add chat sync fields
    if (oldVersion < 2) {
      await _migrateToV2(db);
    }

    // Migrate from version 2 to 3: Add user_id for user isolation
    if (oldVersion < 3) {
      await _migrateToV3(db);
    }

    // Migrate from version 3 to 4: Add action_type column
    if (oldVersion < 4) {
      await _migrateToV4(db);
    }

    // Migrate from version 4 to 5: Add conversation_id column
    if (oldVersion < 5) {
      await _migrateToV5(db);
    }

    // Migrate from version 5 to 6: Add feedback column
    if (oldVersion < 6) {
      await _migrateToV6(db);
    }

    // Migrate from version 6 to 7: Add chart data fields
    if (oldVersion < 7) {
      await _migrateToV7(db);
    }
  }

  Future<void> _migrateToV2(Database db) async {
    AppLogger.info('Migrating database from v1 to v2: Adding chat sync fields',
        name: 'Database');

    // Create new messages table with sync fields and UNIQUE constraint
    await db.execute('''
      CREATE TABLE ${GetIt.instance<AppConstants>().messagesTable}_new (
        id TEXT PRIMARY KEY,
        bot_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        content TEXT NOT NULL,
        image_url TEXT,
        audio_url TEXT,
        timestamp TEXT NOT NULL,
        is_sending INTEGER NOT NULL DEFAULT 0,
        has_error INTEGER NOT NULL DEFAULT 0,

        -- New sync fields for v2
        server_created_at TEXT,
        is_synced INTEGER DEFAULT 0,
        sync_status TEXT DEFAULT 'pending',
        api_message_id TEXT,

        -- Deduplication constraint
        CONSTRAINT unique_message UNIQUE (bot_id, sender, server_created_at, content)
      )
    ''');

    // Copy existing data to new table
    await db.execute('''
      INSERT OR IGNORE INTO ${GetIt.instance<AppConstants>().messagesTable}_new
        (id, bot_id, sender, content, image_url, audio_url, timestamp, is_sending, has_error)
      SELECT id, bot_id, sender, content, image_url, audio_url, timestamp, is_sending, has_error
      FROM ${GetIt.instance<AppConstants>().messagesTable}
    ''');

    // Drop old table
    await db
        .execute('DROP TABLE ${GetIt.instance<AppConstants>().messagesTable}');

    // Rename new table to original name
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable}_new RENAME TO ${GetIt.instance<AppConstants>().messagesTable}');

    // Create new index for efficient queries (ordered by server_created_at)
    await db.execute('''
      CREATE INDEX idx_messages_bot_server_time
      ON ${GetIt.instance<AppConstants>().messagesTable}(bot_id, server_created_at DESC)
    ''');

    // Keep old index for backward compatibility
    await db.execute('''
      CREATE INDEX idx_messages_bot_timestamp
      ON ${GetIt.instance<AppConstants>().messagesTable}(bot_id, timestamp)
    ''');

    AppLogger.info('Migration to v2 completed successfully', name: 'Database');
  }

  Future<void> _migrateToV3(Database db) async {
    AppLogger.info(
        'Migrating database from v2 to v3: Adding user_id for user isolation',
        name: 'Database');

    // Strategy: Delete all existing messages (fresh start)
    // This ensures clean user isolation without orphaned data
    AppLogger.warning('Clearing all existing messages for fresh start...',
        name: 'Database');
    await db.delete(GetIt.instance<AppConstants>().messagesTable);

    // Drop old table
    await db
        .execute('DROP TABLE ${GetIt.instance<AppConstants>().messagesTable}');

    // Create new messages table with user_id column
    await db.execute('''
      CREATE TABLE ${GetIt.instance<AppConstants>().messagesTable} (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        bot_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        content TEXT NOT NULL,
        image_url TEXT,
        audio_url TEXT,
        timestamp TEXT NOT NULL,
        is_sending INTEGER NOT NULL DEFAULT 0,
        has_error INTEGER NOT NULL DEFAULT 0,

        -- Sync fields (v2)
        server_created_at TEXT,
        is_synced INTEGER DEFAULT 0,
        sync_status TEXT DEFAULT 'pending',
        api_message_id TEXT,

        -- Deduplication constraint (v3: includes user_id)
        CONSTRAINT unique_message UNIQUE (user_id, bot_id, sender, server_created_at, content)
      )
    ''');

    // Create new indexes for efficient user-specific queries
    await db.execute('''
      CREATE INDEX idx_messages_user_bot_server_time
      ON ${GetIt.instance<AppConstants>().messagesTable}(user_id, bot_id, server_created_at DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_user_bot_timestamp
      ON ${GetIt.instance<AppConstants>().messagesTable}(user_id, bot_id, timestamp DESC)
    ''');

    AppLogger.info('Migration to v3 completed successfully', name: 'Database');
    AppLogger.info('All previous messages have been cleared for user isolation',
        name: 'Database');
  }

  Future<void> _migrateToV4(Database db) async {
    AppLogger.info(
        'Migrating database from v3 to v4: Adding action_type column',
        name: 'Database');

    // Add action_type column to existing table
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN action_type TEXT');

    AppLogger.info('Migration to v4 completed successfully', name: 'Database');
  }

  Future<void> _migrateToV5(Database db) async {
    AppLogger.info(
        'Migrating database from v4 to v5: Adding conversation_id column',
        name: 'Database');

    // Add conversation_id column to existing table
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN conversation_id INTEGER');

    AppLogger.info('Migration to v5 completed successfully', name: 'Database');
  }

  Future<void> _migrateToV6(Database db) async {
    AppLogger.info('Migrating database from v5 to v6: Adding feedback column',
        name: 'Database');

    // Add feedback column to existing table
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN feedback TEXT');

    AppLogger.info('Migration to v6 completed successfully', name: 'Database');
  }

  Future<void> _migrateToV7(Database db) async {
    AppLogger.info('Migrating database from v6 to v7: Adding chart data fields',
        name: 'Database');

    // Add chart data columns to existing table
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN has_table INTEGER DEFAULT 0');
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN table_data TEXT');
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN graph_type TEXT');
    await db.execute(
        'ALTER TABLE ${GetIt.instance<AppConstants>().messagesTable} ADD COLUMN graph_data TEXT');

    AppLogger.info('Migration to v7 completed successfully', name: 'Database');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, GetIt.instance<AppConstants>().databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
