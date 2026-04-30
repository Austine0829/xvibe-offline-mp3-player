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
      onConfigure: _onConfigure,
      onCreate: _onCreate
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute("""
      PRAGMA foreign_keys = ON
    """);
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

     await db.execute("""
      CREATE TABLE playlist_song(
        id TEXT PRIMARY KEY,
        playlistId TEXT,
        songId INTEGER,
        FOREIGN KEY(playlistId) REFERENCES playlist(id) ON DELETE CASCADE,
        FOREIGN KEY(songId) REFERENCES song(id) ON DELETE CASCADE
      )
    """);

      await db.execute("""
      CREATE TABLE recent_track(
        id TEXT PRIMARY KEY,
        songId INTEGER,
        date TEXT,
        FOREIGN KEY(songId) REFERENCES song(id) ON DELETE CASCADE
      )
    """);
  }
}