import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../error/exceptions.dart';

class DatabaseHelper {
  static const String _dbName = 'clean_shopping_list.db';
  static const int _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    try {
      if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);

      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
      );
    } catch (e) {
      throw CacheException('Failed to initialize database: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shopping_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT,
        description TEXT,
        image_url TEXT,
        market_image_url TEXT,
        is_completed INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE archived_lists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        total_amount REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE archived_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        list_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT,
        description TEXT,
        is_completed INTEGER DEFAULT 0,
        FOREIGN KEY (list_id) REFERENCES archived_lists (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
