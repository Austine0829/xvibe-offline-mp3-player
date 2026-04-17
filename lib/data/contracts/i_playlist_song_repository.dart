import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';

abstract class IPlaylistSongRepository {

  Future<void> add(PlaylistSong playlistSong);
  Future<List<PlaylistSongDTO>> getAll(String playlistId);
  Future<void> delete(String id);
  Future<PlaylistSong> getByPlaylistIdAndSongId(String playlistId, int songId);
}