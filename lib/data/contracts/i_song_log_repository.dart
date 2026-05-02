import 'package:xvibe_offline_mp3_player/models/song_log.dart';

abstract class ISongLogRepository {
  Future<void> add(SongLog songLog);
  Future<List<int>> getSongsId({required String date});
  Future<List<SongLog>> getRecentTracks();
  Future<List<int>> getTopListenSongsIdWithLimit({int limit = 25});
}