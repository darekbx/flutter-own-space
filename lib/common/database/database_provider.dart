import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {

  final int DB_VERSION = 8;

  static final String DB_NAME = "own-space.db";
  static final String NOTES_TABLE = "notes";
  static final String TASKS_TABLE = "tasks";
  static final String ENTRIES_TABLE = "entries";
  static final String FUEL_TABLE = "fuel";
  static final String SUGAR_TABLE = "sugar";
  static final String VAULT_TABLE = "vault";
  static final String SAVED_LINKS_TABLE = "saved_links";
  static final String NEWS_TAG_TABLE = "news_tag";
  static final String BOOKS_TABLE = "books";
  static final String BOOKS_TO_READ_TABLE = "books_to_read";
  static final String BOOKS_CHARE_LOG_TABLE = "books_charge_log";
  static final String ALLEGRO_FILTER_TABLE = "allegro_filter";
  static final String ALLEGRO_ITEM_TABLE = "allegro_item";

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
    await _createVaultTable(db);
    await _createSavedLinksTable(db);
    await _createNewsTagTable(db);
    await _createBooksTable(db);
    await _createBooksToReadTable(db);
    await _createBooksChargeLogTable(db);
    await _createAllegroFilterTable(db);
    await _createAllegroItemTable(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _createTasksTable(db);
    await _createEntriesTable(db);
    await _createEntriesTable(db);
    await _createFuelTable(db);
    await _createSugarTable(db);
    await _createVaultTable(db);
    await _createSavedLinksTable(db);
    await _createNewsTagTable(db);
    await _createBooksTable(db);
    await _createBooksToReadTable(db);
    await _createBooksChargeLogTable(db);
    await _createAllegroFilterTable(db);
    await _createAllegroItemTable(db);
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

  Future _createVaultTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $VAULT_TABLE (
      `id` INTEGER PRIMARY KEY, 
      `key` TEXT, 
      `account` TEXT, 
      `password` TEXT
    )''');
  }

  Future _createSavedLinksTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS $SAVED_LINKS_TABLE (
      `id` INTEGER PRIMARY KEY, 
      `linkId` INTEGER,
      `title` TEXT, 
      `description` TEXT, 
      `imageUrl` TEXT
    )""");
  }

  Future _createNewsTagTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS $NEWS_TAG_TABLE (
      `id` INTEGER PRIMARY KEY, 
      `tag` TEXT,
      `count` INTEGER
    )""");
  }

  Future _createBooksTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS `$BOOKS_TABLE` (
      `_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      `author` TEXT, 
      `title` TEXT, 
      `flags` TEXT, 
      `year` INTEGER
    )""");
  }

  Future _createBooksToReadTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS `$BOOKS_TO_READ_TABLE` (
      `_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      `author` TEXT, 
      `title` TEXT
    )""");
  }

  Future _createBooksChargeLogTable(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS `$BOOKS_CHARE_LOG_TABLE` (
      `_id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      `date` TEXT
    )""");
  }


  Future _createAllegroFilterTable(Database db) async {
    await db.execute('''
      CREATE TABLE $ALLEGRO_FILTER_TABLE (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT NULL,
        priceFrom DOUBLE NULL,
        priceTo DOUBLE NULL,
        searchInDescription INTEGER DEFAULT 0,
        searchUsed INTEGER DEFAULT 0,
        searchNew INTEGER DEFAULT 1,
        categoryName TEXT NOT NULL,
        categoryId TEXT NOT NULL
      )
      ''');
  }

  Future _createAllegroItemTable(Database db) async {
    await db.execute('''
      CREATE TABLE $ALLEGRO_ITEM_TABLE (
        _id INTEGER PRIMARY KEY AUTOINCREMENT,
        allegroId TEXT NULL,
        isNew INTEGER DEFAULT 0,
        filterId INTEGER
      )
    ''');
  }
}