import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ApplicationDatabase {
  static Database? _database;
  static Future<Database>? _opening;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;

    _opening ??= _initDatabase().then((db) {
      _database = db;
      _opening = null;
      return db;
    });

    return await _opening!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "xvibe.db");

    try {
       return await openDatabase(
        path,
        version: 1,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
      );
    } catch (e) {
      debugPrint("Re-trying initialization of database");
      debugPrint("Error has occured while initializing database: $e");
      return await openDatabase(
        path,
        version: 1,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
      );
    }
  }

  Future<void> _onConfigure(Database db) async {
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