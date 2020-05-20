import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:ownspace/common/database/databaseprovider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ownspace/weight/model/entry.dart';

class EntriesRepository {

  final String LEGACY_BACKUP_FILE = "raw/mniammniam.json";

  Future import() async {
    String contentsString = await rootBundle.loadString(LEGACY_BACKUP_FILE);
    List<Entry> entries = await fetchEntriesFromBackup(contentsString);
    await _addEntries(entries);
  }

  Future<List<Entry>> fetchEntriesFromBackup(String contentsString) async {
    return Future(() {
      List<dynamic> contents = jsonDecode(contentsString);
      return contents.map((row) => Entry(row['id'], row['date'], row['weight'], row['type'])).toList();
    });
  }

  Future<List<Entry>> fetchEntries() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor =
      await db.query(DatabaseProvider.ENTRIES_TABLE);
    db.close();
    return cursor.map((row) => Entry.fromEntity(row)).toList();
  }

  Future<List<double>> fetchMaxMinWeight() async {
    var db = await DatabaseProvider().open();
    final result = await db.rawQuery("SELECT MAX(weight) AS `max`, MIN(weight) AS `min` FROM ${DatabaseProvider.ENTRIES_TABLE}");
    db.close();
    return [result[0]['max'] as double, result[0]['min'] as double];
  }

  Future<int> fetchCount() async {
    var db = await DatabaseProvider().open();
    final result = await db.rawQuery("SELECT COUNT(*) AS `count` FROM ${DatabaseProvider.ENTRIES_TABLE}");
    db.close();
    return result[0]['count'] as int;
  }

  Future addEntry(Entry entry) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.ENTRIES_TABLE, entry.toMap());
    db.close();
  }

  Future deleteEntry(Entry entry) async {
    var db = await DatabaseProvider().open();
    await db.delete(
        DatabaseProvider.ENTRIES_TABLE,
        where: "id = ?",
        whereArgs: [entry.id]);
    db.close();
  }

  Future _addEntries(List<Entry> entries) async {
    var db = await DatabaseProvider().open();
    await db.delete(DatabaseProvider.ENTRIES_TABLE);
    await Future.forEach(entries, (entry) async {
      await db.insert(DatabaseProvider.ENTRIES_TABLE, entry.toMap());
    });
    db.close();
  }
}