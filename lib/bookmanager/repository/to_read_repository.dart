import 'dart:async';

import 'package:ownspace/bookmanager/model/to_read.dart';
import 'package:ownspace/common/database/database_provider.dart';

class ToReadRepository {

  Future<List<ToRead>> fetchToRead() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor =
      await db.query(DatabaseProvider.BOOKS_TO_READ_TABLE);
    db.close();
    return cursor.map((row) => ToRead.fromEntity(row)).toList();
  }

  Future addToRead(ToRead toRead) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.BOOKS_TO_READ_TABLE, toRead.toMap());
    db.close();
  }

  Future deleteToRead(ToRead toRead) async {
    var db = await DatabaseProvider().open();
    await db.delete(
        DatabaseProvider.BOOKS_TO_READ_TABLE,
        where: "id = ?",
        whereArgs: [toRead.id]);
    db.close();
  }
}