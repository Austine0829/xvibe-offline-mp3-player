import 'package:sqflite/sqflite.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

class SongRepository {
  final Future<Database> database = ApplicationDatabase.instance.database;

  Future<void> add(Song song) async {
    final db = await database;

    db.insert("song", song.toMap());
  }

  Future<List<Song>> getAll() async {
    final db = await database;
    final List<dynamic> songs = await db.query("song");
    
    return songs.map((song) => Song.toObject(song)).toList();
  }
}