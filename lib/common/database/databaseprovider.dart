import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final int DB_VERSION = 2;
  final String DB_NAME = "own-space.db";
  static String NOTES_TABLE = "notes";
  static String TASKS_TABLE = "tasks";

  Future<Database> open() async {
    String path = await getDatabasesPath();
    return await openDatabase(
        join(path, DB_NAME),
        version: DB_VERSION,
        onCreate: _createTables,
        onUpgrade: _onUpgrade
    );
  }

  Future _createTables(Database db, int version) async {
    await _createNotesTable(db);
    await _createTasksTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await _createTasksTable(db);
    }
  }

  Future _createTasksTable(Database db) async {
    await db.execute('''
    CREATE TABLE `$TASKS_TABLE` ( 
    `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
    `name` TEXT,
    `content` TEXT,
    `date` TEXT,
    `flag` INTEGER NOT NULL)
        ''');
  }

  Future _createNotesTable(Database db) async {
    await db.execute('''
    CREATE TABLE `$NOTES_TABLE` ( 
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `contents` TEXT,
      `index` INTEGER NOT NULL)
    ''');
  }
}