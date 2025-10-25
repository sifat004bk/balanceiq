import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<MessageModel>> getMessages(String botId);
  Future<void> saveMessage(MessageModel message);
  Future<void> updateMessage(MessageModel message);
  Future<void> deleteMessage(String messageId);
  Future<void> clearChatHistory(String botId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final DatabaseHelper databaseHelper;

  ChatLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<MessageModel>> getMessages(String botId) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.messagesTable,
      where: 'bot_id = ?',
      whereArgs: [botId],
      orderBy: 'timestamp ASC',
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
