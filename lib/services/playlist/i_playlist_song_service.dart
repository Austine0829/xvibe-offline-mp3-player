import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';

abstract class IPlaylistSongService {
  
  Future<void> addPlaylistSong(PlaylistSong playlistSong);
  Future<List<PlaylistSongDTO>> getPlaylistSongs(String playlistId);
  Future<void> deletePlaylistSong(String id);
  Future<bool> playlistSongExist(String playlistId, int songId);
}