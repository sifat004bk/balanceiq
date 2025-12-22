import 'package:sqflite/sqflite.dart';
import 'package:dolfin_core/constants/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dolfin_core/database/database_helper.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages(String userId, String botId,
      {int? limit});
  Future<void> saveMessage(MessageModel message);
  Future<void> saveMessages(List<MessageModel> messages);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);
  Future<void> clearChatHistory(String userId, String botId);
  Future<void> clearAllUserMessages(String userId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final DatabaseHelper databaseHelper;

  ChatLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<MessageModel>> getMessages(String userId, String botId,
      {int? limit}) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      GetIt.instance<AppConstants>().messagesTable,
      where: 'user_id = ? AND bot_id = ?',
      whereArgs: [userId, botId],
      // Order by server_created_at DESC for reverse ListView (newest first in data)
      // If server_created_at is null, fallback to timestamp
      // Secondary sort by sender ASC (bot before user) to ensure bot response is "newer" if timestamps equal
      orderBy: 'COALESCE(server_created_at, timestamp) DESC, sender ASC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return MessageModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> saveMessage(MessageModel message) async {
    final db = await databaseHelper.database;
    await db.insert(
      GetIt.instance<AppConstants>().messagesTable,
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveMessages(List<MessageModel> messages) async {
    final db = await databaseHelper.database;

    // Use transaction for batch insert (atomic operation)
    await db.transaction((txn) async {
      for (var message in messages) {
        // If this is a synced message (has server_created_at),
        // check for and delete any corresponding local pending message (server_created_at IS NULL)
        // to prevent duplicates.
        if (message.serverCreatedAt != null) {
          await txn.delete(
            GetIt.instance<AppConstants>().messagesTable,
            where: '''
              user_id = ? AND 
              bot_id = ? AND 
              sender = ? AND 
              content = ? AND 
              server_created_at IS NULL
            ''',
            whereArgs: [
              message.userId,
              message.botId,
              message.sender,
              message.content
            ],
          );
        }

        await txn.insert(
          GetIt.instance<AppConstants>().messagesTable,
          message.toJson(),
          // Use replace to ensure updates (like feedback) are applied
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    final db = await databaseHelper.database;
    await db.update(
      GetIt.instance<AppConstants>().messagesTable,
      message.toJson(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final db = await databaseHelper.database;
    await db.delete(
      GetIt.instance<AppConstants>().messagesTable,
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  @override
  Future<void> clearChatHistory(String userId, String botId) async {
    final db = await databaseHelper.database;
    await db.delete(
      GetIt.instance<AppConstants>().messagesTable,
      where: 'user_id = ? AND bot_id = ?',
      whereArgs: [userId, botId],
    );
  }

  @override
  Future<void> clearAllUserMessages(String userId) async {
    final db = await databaseHelper.database;
    await db.delete(
      GetIt.instance<AppConstants>().messagesTable,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
