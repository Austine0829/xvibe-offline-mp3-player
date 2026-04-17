import 'package:sqflite_common/sqlite_api.dart';
import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_playlist_song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';

class PlaylistSongRepository implements IPlaylistSongRepository {
  late final Future<Database> _db;
  final String tablePlaylistSongs = "playlist_song";

  PlaylistSongRepository({required ApplicationDatabase appDb}) {
    _db = appDb.database;
  }

  @override
  Future<void> add(PlaylistSong playlistSong) async {
    final db = await _db;

    await db.insert(tablePlaylistSongs, playlistSong.toMap());
  }

  @override
  Future<List<PlaylistSongDTO>> getAll(String playlistId) async {
    final db = await _db;
    final List<dynamic> playlistSongs = await db.rawQuery("""
      SELECT playlist_song.id AS playlist_song_id, 
        song.id AS song_id, 
        song.title, 
        song.vibe, 
        song.path
      FROM playlist_song
      INNER JOIN song ON song.id = playlist_song.songId
      INNER JOIN playlist ON playlist.id = playlist_song.playlistId
      WHERE playlist.id = ?
    """,
    [playlistId]);
    
    return playlistSongs.map((playlistSong) => PlaylistSongDTO.toObject(playlistSong)).toList();
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    await db.delete(
      tablePlaylistSongs, 
      where: "id = ?",
      whereArgs: [id]
    );
  }
  
  @override
  Future<PlaylistSong> getByPlaylistIdAndSongId(String playlistId, int songId) async {
    final db = await _db;

    final playlistSong = await db.query(
      tablePlaylistSongs, 
      where: "playlistId = ? AND songId = ?",
      whereArgs: [playlistId, songId],
      limit: 1
    );

    if (playlistSong.isNotEmpty) return PlaylistSong.toObject(playlistSong.first);

    return PlaylistSong(
      id: "-1", 
      playlistId: "-1", 
      songId: -1
    );
  }
}