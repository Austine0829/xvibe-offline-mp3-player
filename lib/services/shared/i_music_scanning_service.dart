import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IMusicScanningService {
  Future<List<Song>> scanSongs();
}