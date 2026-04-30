import 'package:sqflite_common/sqlite_api.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_recent_track_repository.dart';
import 'package:xvibe_offline_mp3_player/models/recent_track.dart';

class RecentTrackRepository implements IRecentTrackRepository {
   late final Future<Database> _db;
  final String _tableRecentTrack = "recent_track";

  RecentTrackRepository({required ApplicationDatabase appDb}) {
    _db = appDb.database;
  }

  @override
  Future<void> add(RecentTrack recentTrack) async {
    final db = await _db;

    await db.insert(_tableRecentTrack, recentTrack.toMap());
  }

  @override
  Future<List<int>> getSongsId({required String date}) async {
    final db = await _db;
    List<Map<String, Object?>> recentTracks = await db
      .rawQuery("SELECT songId FROM $_tableRecentTrack WHERE date = ?", [date]);
    
    return recentTracks.map((recentTrack) => recentTrack["songId"] as int).toList();
  }
  
  @override
  Future<List<RecentTrack>> getRecentTracks() async {
    final db = await _db;
      List<dynamic> recentTracks = await db
        .query(_tableRecentTrack);
  
    return recentTracks.map((recentTrack) => RecentTrack.toObject(recentTrack)).toList(); 
  }
}