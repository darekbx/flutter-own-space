import 'dart:async';
import 'dart:convert';

import 'package:ownspace/bookmanager/model/book.dart';
import 'package:ownspace/common/database/database_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class BooksRepository {

  //final String LEGACY_BACKUP_FILE = "raw/mniammniam.json";

  Future import() async {
 /*   String contentsString = await rootBundle.loadString(LEGACY_BACKUP_FILE);
    List<Book> books = await fetchbooksFromBackup(contentsString);
    await _addbooks(books);*/
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

  Future _addbooks(List<Book> books) async {
    var db = await DatabaseProvider().open();
    await db.delete(DatabaseProvider.BOOKS_TABLE);
    await Future.forEach(books, (Book) async {
      await db.insert(DatabaseProvider.BOOKS_TABLE, Book.toMap());
    });
    db.close();
  }
}