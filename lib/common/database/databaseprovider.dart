import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final int DB_VERSION = 1;
  final String DB_NAME = "own-space.db";
  static String NOTES_TABLE = "notes";

  Future<Database> open() async {
    String path = await getDatabasesPath();
    return await openDatabase(
        join(path, DB_NAME),
        version: DB_VERSION,
        onCreate: (Database db, int version) async {
          await _createTables(db);
        });
  }

  Future _createTables(Database db) async {
    await db.execute('''
    CREATE TABLE `$NOTES_TABLE` ( 
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `contents` TEXT,
      `index` INTEGER NOT NULL)
    ''');
  }
}