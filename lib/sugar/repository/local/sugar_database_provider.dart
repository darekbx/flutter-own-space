import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:ownspace/sugar/own_space_date_utils.dart';
import 'package:ownspace/sugar/model/entry.dart';
import 'package:sqflite/sqflite.dart';

class SugarDatabaseProvider {

  SugarDatabaseProvider._();

  static final SugarDatabaseProvider instance = SugarDatabaseProvider._();

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

  Future<int> add(Entry entry) async =>
      await (await database).insert(DatabaseProvider.SUGAR_TABLE, entry.toMap());

  Future<double> todaysSugar() async {
    var date = DateTime.now();
    var nowString = OwnSpaceDateUtils.formatDate(date);
    var query = """
      SELECT 
        SUM(sugar) AS sum, strftime('%Y-%m-%d',DATETIME(timestamp/1000, 'unixepoch')) AS `date`
      FROM ${DatabaseProvider.SUGAR_TABLE} 
      WHERE `date` = '${nowString}'
      """;
    var cursor = await (await database).rawQuery(query);
    if (cursor.length == 0 || cursor[0]['sum'] == null) {
      return 0.0;
    }
    return cursor[0]['sum'] as double;
  }

  Future<List<double>> daySummary() async {
    var query = """
      SELECT 
        SUM(sugar) AS sum, 
        strftime('%Y-%m-%d',DATETIME(timestamp/1000, 'unixepoch'))
      FROM ${DatabaseProvider.SUGAR_TABLE} 
      GROUP BY strftime('%Y-%m-%d',DATETIME(timestamp/1000, 'unixepoch'))""";
    var cursor = await (await database).rawQuery(query);
    return cursor.isNotEmpty
        ? cursor.map((row) => row['sum'] as double).toList()
        : List<double>();
  }

  list() async {
    var cursor = await (await database).query(DatabaseProvider.SUGAR_TABLE, orderBy: "timestamp DESC");
    return _cursorToList(cursor);
  }

  distinctList() async {
    var cursor = await (await database).rawQuery("SELECT id, name, sugar, timestamp FROM ${DatabaseProvider.SUGAR_TABLE} GROUP BY name");
    return _cursorToList(cursor);
  }

  Future<int> delete(int id) async =>
      await (await database).delete(DatabaseProvider.SUGAR_TABLE, where: "id = ?", whereArgs: [id]);


  List<Entry> _cursorToList(List<Map<String, dynamic>> cursor) {
    return cursor.isNotEmpty
        ? cursor.map((row) => Entry.fromMap(row)).toList()
        : List<Entry>();
  }
}
