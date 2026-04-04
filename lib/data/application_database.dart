import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ApplicationDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "xvibe.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE song(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        vibe TEXT,
        path TEXT,
        isFavorite INTEGER
      )
    """);

     await db.execute("""
      CREATE TABLE playlist(
        id TEXT PRIMARY KEY,
        name TEXT,
        backgroundColor INTEGER
      )
    """);
  }
}