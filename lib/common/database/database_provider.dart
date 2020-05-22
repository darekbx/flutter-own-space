import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final int DB_VERSION = 4;
  final String DB_NAME = "own-space.db";
  static String NOTES_TABLE = "notes";
  static String TASKS_TABLE = "tasks";
  static String ENTRIES_TABLE = "entries";
  static String FUEL_TABLE = "fuel";
  static String SUGAR_TABLE = "sugar";

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
    await _createFuelTable(db);
    await _createSugarTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _createTasksTable(db);
    await _createEntriesTable(db);
    await _createEntriesTable(db);
    await _createFuelTable(db);
    await _createSugarTable(db);
  }

  Future _createEntriesTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS `$ENTRIES_TABLE` ( 
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `date` TEXT,
      `weight` REAL,
      `type` INTEGER NOT NULL)
    ''');
  }

  Future _createTasksTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS `$TASKS_TABLE` ( 
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `name` TEXT,
      `content` TEXT,
      `date` TEXT,
      `flag` INTEGER NOT NULL)
    ''');
  }

  Future _createNotesTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS `$NOTES_TABLE` ( 
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `contents` TEXT,
      `index` INTEGER NOT NULL)
    ''');
  }

  Future _createFuelTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $FUEL_TABLE (
      `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
      `date` TEXT,
      `liters` REAL,
      `cost` REAL,
      `type` INTEGER)
    ''');
  }

  Future _createSugarTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $SUGAR_TABLE (
      `id` INTEGER PRIMARY KEY, 
      `name` TEXT, 
      `sugar` REAL, 
      `timestamp` INTEGER
    )''');
  }
}