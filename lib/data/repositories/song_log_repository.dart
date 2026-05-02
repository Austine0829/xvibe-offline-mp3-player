import 'package:sqflite_common/sqlite_api.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_song_log_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song_log.dart';

class SongLogRepository implements ISongLogRepository {
   late final Future<Database> _db;
  final String _tableSongLog = "song_log";

  SongLogRepository({required ApplicationDatabase appDb}) {
    _db = appDb.database;
  }

  @override
  Future<void> add(SongLog songLog) async {
    final db = await _db;

    await db.insert(_tableSongLog, songLog.toMap());
  }

  @override
  Future<List<int>> getSongsId({required String date}) async {
    final db = await _db;
    List<Map<String, Object?>> recentTracks = await db
      .rawQuery("SELECT DISTINCT songId FROM $_tableSongLog WHERE date = ?", [date]);
    
    return recentTracks.map((recentTrack) => recentTrack["songId"] as int).toList();
  }
  
  @override
  Future<List<SongLog>> getRecentTracks() async {
    final db = await _db;
      List<dynamic> songLogs = await db
        .query(_tableSongLog);
  
    return songLogs.map((songLog) => SongLog.toObject(songLog)).toList(); 
  }
  
  @override
  Future<List<int>> getTopListenSongsIdWithLimit({int limit = 25}) async {
    final db = await _db;
    List<Map<String, Object?>> recentTracks = await db
      .rawQuery("""
        SELECT songId FROM $_tableSongLog
        GROUP BY songId ORDER BY COUNT(*) DESC
        LIMIT ?
      """, [limit]);
    
    return recentTracks.map((recentTrack) => recentTrack["songId"] as int).toList();
  }
}