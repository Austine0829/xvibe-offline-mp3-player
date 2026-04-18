import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IVibeViewModel {
  List<Song> get getSongs;
  List<Playlist> get getPlaylists;
  String? get errorMessage;
  String? get successMessage;
  bool get isLoading;

  Future<void> play(int index);

  Future<void> update(int id, Song song);
  Future<void> initialize();
  Future<bool> delete(int id);
  Future<void> getAllPlaylist();
  Future<void> addSongToPlaylist(String playlistId, int songId);
}