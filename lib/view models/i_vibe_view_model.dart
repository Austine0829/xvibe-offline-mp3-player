import 'package:xvibe_offline_mp3_player/DTO/song_dto.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IVibeViewModel {
  Map<int, Song> get getSongs;
  List<Playlist> get getPlaylists;
  String? get errorMessage;
  String? get successMessage;
  bool get isLoading;
  List<SongDTO> get getSongsDTO; 

  Future<void> play(int index);

  Future<void> updateSong(int songId, Song song);
  Future<void> initialize();
  Future<void> deleteSong(int songId);
  Future<void> getAllPlaylist();
  Future<void> addSongToPlaylist(String playlistId, int songId);
}