import 'package:sqflite_common/sqlite_api.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

class SongRepository implements ISongRepository {
  late final Future<Database> _db;
  final String tableSong = "song";

  SongRepository({required ApplicationDatabase appDb}) {
    _db = appDb.database;
  }

  @override
  Future<void> add(Song song) async {
    final db = await _db;

    db.insert(tableSong, song.toMap());
  }

  @override
  Future<List<Song>> getAll({String? vibe}) async {
    final db = await _db;
    final List<dynamic> songs;

    if (vibe == null || vibe == "") {
      songs = await db.query(tableSong);
    } else {
      songs = await db.query(tableSong, where: "vibe = ?", whereArgs: [vibe]);
    }

    return songs.map((song) => Song.toObject(song)).toList();
  }

  @override
  Future<Song> get(int id) async {
    final db = await _db;
    final song = await db.query(
                  tableSong, 
                  where: "id = ?", 
                  whereArgs: [id]
                ); 

    if (song.isNotEmpty) return Song.toObject(song.first);

    return Song(
      id: 0,
      title: "No Title", 
      vibe: "No Vibe", 
      path: "No Path"
    );
  }

  @override
  Future<void> update(int id, Song song) async {
    final db = await _db;

    await db.update(
      tableSong, 
      song.toMap(),
      where: "id = ?",
      whereArgs: [id]
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await _db;

    await db.delete(
      tableSong, 
      where: "id = ?",
      whereArgs: [id]
    );
  }
}