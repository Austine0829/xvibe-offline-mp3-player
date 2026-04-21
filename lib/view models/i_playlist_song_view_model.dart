import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IPlaylistSongViewModel {
  List<PlaylistSongDTO> get getPlaylistSongs;
  List<Song> get getSongs;
  List<Playlist> get getPlaylists;
  String? get errorMessage;
  String? get successMessage;
  bool get isLoading;

  Future<void> play(int index);

  Future<void> addPlaylistSong(PlaylistSongDTO playlistSongDTO);
  Future<void> initialize(String playlistId);
  Future<void> deletePlaylistSong(String playlistSongId);
  Future<void> addSongToPlaylist(String playlistId, int songId);
  Future<void> addSongToCurrentQueue(int songId);
}