import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:synchronized/synchronized.dart';

class ApplicationDatabase {
  static final ApplicationDatabase instance = ApplicationDatabase._();
  static Database? _database;
  static final _lock = Lock();

  ApplicationDatabase._();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;

    return await _lock.synchronized(() async {
      if (_database != null && _database!.isOpen) return _database!;

       _database = await _initDatabase();
       return _database!;
    });
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "xvibe.db");

    return await openDatabase(
        path,
        version: 1,
        onConfigure: _onConfig,
        onCreate: _onCreate,
    );
  }

  Future<void> _onConfig(Database db) async {
    await db.execute("""
      PRAGMA foreign_keys = ON
    """);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS song(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        vibe TEXT,
        path TEXT,
        isFavorite INTEGER,
        backgroundColor INTEGER
      )
    """);

     await db.execute("""
      CREATE TABLE IF NOT EXISTS playlist(
        id TEXT PRIMARY KEY,
        name TEXT,
        backgroundColor INTEGER
      )
    """);

     await db.execute("""
      CREATE TABLE IF NOT EXISTS playlist_song(
        id TEXT PRIMARY KEY,
        playlistId TEXT,
        songId INTEGER,
        FOREIGN KEY(playlistId) REFERENCES playlist(id) ON DELETE CASCADE,
        FOREIGN KEY(songId) REFERENCES song(id) ON DELETE CASCADE
      )
    """);

      await db.execute("""
      CREATE TABLE IF NOT EXISTS song_log(
        id TEXT PRIMARY KEY,
        songId INTEGER,
        date TEXT,
        weekDay TEXT,
        FOREIGN KEY(songId) REFERENCES song(id) ON DELETE CASCADE
      )
    """);
  }
}