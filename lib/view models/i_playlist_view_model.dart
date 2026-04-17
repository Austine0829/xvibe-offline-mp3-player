import 'package:xvibe_offline_mp3_player/models/playlist.dart';

abstract class IPlaylistViewModel {
  List<Playlist> get getPlaylists;
  Playlist get getPlaylist;
  String? get errorMessage;
  bool get isLoading;

  Future<void> addPlaylist(Playlist playlist);
  Future<void> updatePlaylist(String id, Playlist playlist);
  Future<void> initialize();
  Future<bool> deletePlaylist(String id);
  void sortPlaylist();
}