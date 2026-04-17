import 'package:xvibe_offline_mp3_player/data/contracts/i_playlist_repository.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';

class PlaylistService implements IPlaylistService {
  final IPlaylistRepository _playlistRepository;

  PlaylistService(this._playlistRepository);

  @override
  Future<void> addPlaylist(Playlist playlist) async {
    await _playlistRepository.add(playlist);
  }

  @override
  Future<void> deletePlaylist(String id) async {
    await _playlistRepository.delete(id);
  }

  @override
  Future<List<Playlist>> getPlaylists() async {
    return await _playlistRepository.getAll();
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    return await _playlistRepository.get(id);
  }

  @override
  Future<void> updatePlaylist(String id, Playlist playlist) async {
    await _playlistRepository.update(id, playlist);
  }
}