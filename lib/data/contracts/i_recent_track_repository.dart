import 'package:xvibe_offline_mp3_player/models/recent_track.dart';

abstract class IRecentTrackRepository {
  Future<void> add(RecentTrack recentTrack);
  Future<List<int>> getSongsId({required String date});
  Future<List<RecentTrack>> getRecentTracks();
}