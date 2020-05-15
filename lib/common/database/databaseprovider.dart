import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final int DB_VERSION = 3;
  final String DB_NAME = "own-space.db";
  static String NOTES_TABLE = "notes";
  static String TASKS_TABLE = "tasks";
  static String ENTRIES_TABLE = "entries";

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
    await _createEntriesTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await _createTasksTable(db);
    }
    if ((oldVersion == 1 || oldVersion == 2) && newVersion == 3) {
      await _createEntriesTable(db);
    }
  }

  Future _createEntriesTable(Database db) async {
    await db.execute('''
    CREATE TABLE `$ENTRIES_TABLE` ( 
    `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
    `date` TEXT,
    `weight` REAL,
    `type` INTEGER NOT NULL)
        ''');
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