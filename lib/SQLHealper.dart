import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE archive(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE stories(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE today(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE inProg(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE done(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'scrumBoard.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String tblName, String title) async {
    final db = await SQLHelper.db();

    final data = {'title': title};
    final id = await db.insert(tblName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Empty table before inserting
  static Future<int> emptyTable(String tblName) async {
    final db = await SQLHelper.db();

    await db.delete(tblName);

    return 1;
  }

  // Create new item (journal)
  static Future<int> addItems(String tblName, List<String> items) async {
    final db = await SQLHelper.db();

    for (String item in items) {
      final data = {'title': item};
      await db.insert(tblName, data,
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
    return 1;
  }

  // Read all items from respective tables
  static Future<List<Map<String, dynamic>>> getArchive() async {
    final db = await SQLHelper.db();
    return db.query('archive', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getStories() async {
    final db = await SQLHelper.db();
    return db.query('stories', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await SQLHelper.db();
    return db.query('tasks', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getToday() async {
    final db = await SQLHelper.db();
    return db.query('today', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getInProg() async {
    final db = await SQLHelper.db();
    return db.query('inProg', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getDone() async {
    final db = await SQLHelper.db();
    return db.query('done', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItemById(
      String tblName, int id) async {
    final db = await SQLHelper.db();
    return db.query(tblName, where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItemById(
      int id, String tblName, String title) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'createdAt': DateTime.now().toString()};

    final result =
        await db.update(tblName, data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItemById(String tblName, int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(tblName, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
