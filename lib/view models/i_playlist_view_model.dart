import 'package:xvibe_offline_mp3_player/models/playlist.dart';

abstract class IPlaylistViewModel {
  List<Playlist> get getPlaylists;
  Playlist get getPlaylist;
  String? get errorMessage;
  bool get isLoading;

  Future<void> add(Playlist playlist);
  Future<void> update(String id, Playlist playlist);
  Future<void> get(String id);
  Future<void> initialize();
  Future<bool> delete(String id);
  void sort();
}