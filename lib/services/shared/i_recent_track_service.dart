import 'package:flutter/foundation.dart';
import 'package:xvibe_offline_mp3_player/DTO/recent_track_dto.dart';

abstract class IRecentTrackService extends ChangeNotifier {
  List<int> get getRecenTracksSongId;

  Future<void> logTrack(RecentTrackDTO recentTrackDTO);
  Future<List<int>> getRecentTracksSongIdByDate(String date);
}