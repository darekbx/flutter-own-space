import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ownspace/bookmanager/model/book.dart';
import 'package:ownspace/bookmanager/model/charge_log.dart';
import 'package:ownspace/bookmanager/model/to_read.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BooksRepository {

  final String LEGACY_BACKUP_FILE = "raw/book_manager.sqlite";

  /**
   * Import steps:
   * 1. Copy `book_manager.sqlite` databasefile from raw/
   * 2. Save temp file
   * 3. Read records
   * 4. Close database and delete temp file
   * 5. Insert new values
   */
  Future import() async {
    // 1.
    ByteData data = await rootBundle.load(LEGACY_BACKUP_FILE);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String outPath = join(documentsDirectory.path, "book_manager.sqlite");

    // 2.
    await File(outPath).writeAsBytes(bytes, mode: FileMode.write);

    // 3.
    Database database = await openDatabase(outPath);
    var books = (await database.query("books")).map((row) => Book.fromEntity(row)).toList();
    var toRead = (await database.query("to_read")).map((row) => ToRead.fromEntity(row)).toList();
    var chargeLog = (await database.query("charge_log")).map((row) => ChargeLog.fromEntity(row)).toList();

    // 4.
    await database.close();
    await File(outPath).delete();

    // 5.
    var db = await DatabaseProvider().open();

    await db.delete(DatabaseProvider.BOOKS_TABLE);
    await Future.forEach(books, (book) async {
      await db.insert(DatabaseProvider.BOOKS_TABLE, book.toMap());
    });

    await db.delete(DatabaseProvider.BOOKS_TO_READ_TABLE);
    await Future.forEach(toRead, (toRead) async {
      await db.insert(DatabaseProvider.BOOKS_TO_READ_TABLE, toRead.toMap());
    });

    await db.delete(DatabaseProvider.BOOKS_CHARE_LOG_TABLE);
    await Future.forEach(chargeLog, (chargeLog) async {
      await db.insert(DatabaseProvider.BOOKS_CHARE_LOG_TABLE, chargeLog.toMap());
    });

    db.close();
  }

  Future<List<Book>> fetchBooks() async {
    var db = await DatabaseProvider().open();
    final List<Map<String, dynamic>> cursor =
      await db.query(DatabaseProvider.BOOKS_TABLE);
    db.close();
    return cursor.map((row) => Book.fromEntity(row)).toList();
  }

  Future addBook(Book book) async {
    var db = await DatabaseProvider().open();
    await db.insert(DatabaseProvider.BOOKS_TABLE, book.toMap());
    db.close();
  }

  Future deleteBook(Book book) async {
    var db = await DatabaseProvider().open();
    await db.delete(
        DatabaseProvider.BOOKS_TABLE,
        where: "id = ?",
        whereArgs: [book.id]);
    db.close();
  }

  Future updateBook(Book book) async {
    var db = await DatabaseProvider().open();
    await db.update(
        DatabaseProvider.BOOKS_TABLE,
        book.toMap(),
        where: "id = ?",
        whereArgs: [book.id]);
    db.close();
  }
}