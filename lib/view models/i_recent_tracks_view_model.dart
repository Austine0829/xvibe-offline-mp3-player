import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IRecentTracksViewModel {
  Map<int, Song> get getSongs;
  List<Playlist> get getPlaylists;
  String? get errorMessage;
  String? get successMessage;
  bool get isLoading;
  List<int> get getRecentTracksSongId; 

  Future<void> play(int index);

  Future<void> getAllPlaylist();
  Future<void> addSongToPlaylist(String playlistId, int songId);
  Future<void> addSongToCurrentQueue(int songId);
  Future<void> initialize();
}