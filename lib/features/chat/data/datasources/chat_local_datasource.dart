import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages(String botId, {int? limit});
  Future<void> saveMessage(MessageModel message);
  Future<void> saveMessages(List<MessageModel> messages);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);
  Future<void> clearChatHistory(String botId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final DatabaseHelper databaseHelper;

  ChatLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<MessageModel>> getMessages(String botId, {int? limit}) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.messagesTable,
      where: 'bot_id = ?',
      whereArgs: [botId],
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
      AppConstants.messagesTable,
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
        await txn.insert(
          AppConstants.messagesTable,
          message.toJson(),
          // Use ignore to prevent duplicates (idempotent operation)
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    final db = await databaseHelper.database;
    await db.update(
      AppConstants.messagesTable,
      message.toJson(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    final db = await databaseHelper.database;
    await db.delete(
      AppConstants.messagesTable,
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  @override
  Future<void> clearChatHistory(String botId) async {
    final db = await databaseHelper.database;
    await db.delete(
      AppConstants.messagesTable,
      where: 'bot_id = ?',
      whereArgs: [botId],
    );
  }
}
