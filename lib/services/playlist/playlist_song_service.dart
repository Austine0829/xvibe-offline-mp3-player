import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_playlist_song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_song_service.dart';

class PlaylistSongService implements IPlaylistSongService {
  final IPlaylistSongRepository _playlistSongRepository;

  PlaylistSongService(this._playlistSongRepository);

  @override
  Future<void> addPlaylistSong(PlaylistSong playlistSong) async {
    await _playlistSongRepository.add(playlistSong);
  }

  @override
  Future<void> deletePlaylistSong(String id) async {
    await _playlistSongRepository.delete(id);
  }

  @override
  Future<List<PlaylistSongDTO>> getPlaylistSongs(String playlistId) async {
    return await _playlistSongRepository.getAll(playlistId);
  }
  
  @override
  Future<bool> playlistSongExist(String playlistId, int songId) async {
    PlaylistSong playlistSong = await _playlistSongRepository
      .getByPlaylistIdAndSongId(playlistId, songId);

    if (playlistSong.playlistId == playlistId && playlistSong.songId == songId) return true;

    return false;
  }

}