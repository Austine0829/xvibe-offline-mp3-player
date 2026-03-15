import 'package:sqflite_common/sqlite_api.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

class SongRepository implements IRepository {
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
  Future<List<Song>> getAll() async {
    final db = await _db;
    final List<dynamic> songs = await db.query(tableSong);
    
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

    db.update(
      tableSong, 
      song.toMap(),
      where: "id = ?",
      whereArgs: [id]
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await _db;

    db.delete(
      tableSong, 
      where: "id = ?",
      whereArgs: [id]
    );
  }
}