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

    // Create messages table (v2 schema with sync fields)
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
        has_error INTEGER NOT NULL DEFAULT 0,

        -- Sync fields (v2)
        server_created_at TEXT,
        is_synced INTEGER DEFAULT 0,
        sync_status TEXT DEFAULT 'pending',
        api_message_id TEXT,

        -- Deduplication constraint
        CONSTRAINT unique_message UNIQUE (bot_id, sender, server_created_at, content)
      )
    ''');

    // Create indexes for efficient queries
    await db.execute('''
      CREATE INDEX idx_messages_bot_server_time
      ON ${AppConstants.messagesTable}(bot_id, server_created_at DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_messages_bot_timestamp
      ON ${AppConstants.messagesTable}(bot_id, timestamp)
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Migrate from version 1 to 2: Add chat sync fields
    if (oldVersion < 2) {
      await _migrateToV2(db);
    }
  }

  Future<void> _migrateToV2(Database db) async {
    print('🔄 Migrating database from v1 to v2: Adding chat sync fields');

    // Create new messages table with sync fields and UNIQUE constraint
    await db.execute('''
      CREATE TABLE ${AppConstants.messagesTable}_new (
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
      INSERT OR IGNORE INTO ${AppConstants.messagesTable}_new
        (id, bot_id, sender, content, image_url, audio_url, timestamp, is_sending, has_error)
      SELECT id, bot_id, sender, content, image_url, audio_url, timestamp, is_sending, has_error
      FROM ${AppConstants.messagesTable}
    ''');

    // Drop old table
    await db.execute('DROP TABLE ${AppConstants.messagesTable}');

    // Rename new table to original name
    await db.execute(
        'ALTER TABLE ${AppConstants.messagesTable}_new RENAME TO ${AppConstants.messagesTable}');

    // Create new index for efficient queries (ordered by server_created_at)
    await db.execute('''
      CREATE INDEX idx_messages_bot_server_time
      ON ${AppConstants.messagesTable}(bot_id, server_created_at DESC)
    ''');

    // Keep old index for backward compatibility
    await db.execute('''
      CREATE INDEX idx_messages_bot_timestamp
      ON ${AppConstants.messagesTable}(bot_id, timestamp)
    ''');

    print('✅ Migration to v2 completed successfully');
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
