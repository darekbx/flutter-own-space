import 'dart:async';

import 'package:ownspace/common/database/database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ownspace/news/model/savedlink.dart';

class NewsDatabaseProvider {

  NewsDatabaseProvider._();

  static final NewsDatabaseProvider instance = NewsDatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      // Check if DB is opened
      try {
        _database.rawQuery("SELECT 1");
      } catch (e) {
        // Reopen
        _database = await DatabaseProvider().open();
      }
      return _database;
    }
    _database = await DatabaseProvider().open();
    return _database;
  }

  void setTagCount(String tag, int count) async {
    await (await database).update(
        DatabaseProvider.NEWS_TAG_TABLE,
        { "count": count },
        where: "tag = ?",
        whereArgs: [tag]);
  }

  Future<int> getTagCount(String tag) async {
    var cursor = await (await database).query(
        DatabaseProvider.NEWS_TAG_TABLE,
        columns: ["count"],
        where: "tag = ?",
        whereArgs: [tag]);
    return cursor.isNotEmpty
        ? cursor.map((row) => int.parse(row["count"].toString())).first
        : 0;
  }

  Future<void> addTag(String tag) async =>
    await (await database).insert(
        DatabaseProvider.NEWS_TAG_TABLE,
        { "count": 0, "tag": tag });


  Future<List<String>> fetchTags() async {
    var cursor = await (await database).query(DatabaseProvider.NEWS_TAG_TABLE, columns: ["tag"]);
    return cursor.isNotEmpty
        ? cursor.map((row) => row["tag"].toString()).toList()
        : List<String>();
  }

  void deleteTag(String tag) async => await (await database)
      .delete(DatabaseProvider.NEWS_TAG_TABLE, where: "tag = ?", whereArgs: [tag]);

  Future<int> countTags() async => (await fetchTags()).length;

  Future<int> add(SavedLink link) async =>
      await (await database).insert(DatabaseProvider.SAVED_LINKS_TABLE, link.toMap());

  list() async {
    var cursor = await (await database).query(DatabaseProvider.SAVED_LINKS_TABLE);
    return _cursorToList(cursor);
  }

  Future<int> delete(int id) async => await (await database)
      .delete(DatabaseProvider.SAVED_LINKS_TABLE, where: "id = ?", whereArgs: [id]);

  List<SavedLink> _cursorToList(List<Map<String, dynamic>> cursor) {
    return cursor.isNotEmpty
        ? cursor.map((row) => SavedLink.fromMap(row)).toList()
        : List<SavedLink>();
  }
}
