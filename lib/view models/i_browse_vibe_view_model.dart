import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IBrowseVibeViewModel {
  List<Playlist> get getPlaylists;
  String? get errorMessage;
  String? get successMessage;
  bool get isLoading;
  List<Song> get getSongs;
  List<String> get getVibes;
  List<String> get getVibesPlaylistId;

  Future<void> play(int index);
  Future<void> initialize(String playlistId, String vibe);
  Future<void> addSongToPlaylist(String playlistId, int songId);
  Future<void> addSongToCurrentQueue(int songId);
  Future<void> addSongToCurrentQueuePlay(int songId);
  Future<void> getSongsIdWithTitle(String title);
}