import 'package:xvibe_offline_mp3_player/models/playlist.dart';

abstract class IPlaylistService {
  
  Future<void> addPlaylist(Playlist playlist);
  Future<Playlist> getPlaylist(String id);
  Future<List<Playlist>> getPlaylists();
  Future<void> updatePlaylist(String id, Playlist playlist);
  Future<void> deletePlaylist(String id);
}