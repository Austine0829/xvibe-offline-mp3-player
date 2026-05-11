import 'package:flutter/foundation.dart';
import 'package:xvibe_offline_mp3_player/DTO/playlist_song_dto.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';

class PlaylistSongViewModel extends ChangeNotifier implements IPlaylistSongViewModel {
  late final IMusicPlayerService _musicPlayerService;
  late final IPlaylistSongService _playlistSongService;
  late final ISongService _songService;
  late final IPlaylistService _playlistService;

  List<PlaylistSongDTO> _playlistSongs = [];
  List<Song> _songs = []; 
  List<Playlist> _playlists = [];

  String? _errorMessage;
  String? _sucessMessage;
  String _currentPlaylistId = "";
  bool _isLoading = false;

  PlaylistSongViewModel(
    this._musicPlayerService,
    this._playlistSongService,
    this._songService,
    this._playlistService
  );

   @override
  String? get errorMessage => _errorMessage;

  @override
  List<PlaylistSongDTO> get getPlaylistSongs => _playlistSongs;

  @override
  List<Song> get getSongs => _songs;

  @override
  bool get isLoading => _isLoading;

  @override
  List<Playlist> get getPlaylists => _playlists;

  @override
  String? get successMessage => _sucessMessage;
  
  @override
  Future<void> addPlaylistSong(int songId) async {
    _errorMessage = null;

    try {
      final Song song = _songService.getSongSources[songId]!;

      await _playlistSongService.addPlaylistSong(
          PlaylistSong(
            id: UuidGenerator.generate(),
            songId: song.id,
            playlistId: _currentPlaylistId
        )
      );

      _playlistSongs.add(PlaylistSongDTO(
        playlistSongId: UuidGenerator.generate(), 
        songId: songId, 
        title: song.title, 
        vibe: song.vibe, 
        path: song.path, 
        backgroundColor: song.backgroundColor
      ));

      await _musicPlayerService.addAudioInPlaylist(
        _currentPlaylistId, 
        songId
      );

      int foundIndex = _songs
        .indexWhere((song) => song.id == songId);
       if (foundIndex != -1) _songs.removeAt(foundIndex);
    } catch (e) {
      _errorMessage = "Error has occured while adding the song in the playlist";
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> deletePlaylistSong(String playlistSongId) async {
    _errorMessage = null;
    _sucessMessage = null;

    try {
      await _playlistSongService.deletePlaylistSong(playlistSongId);

      int foundIndex = _playlistSongs
        .indexWhere((playlistSong) => playlistSong.playlistSongId == playlistSongId);
      if (foundIndex != -1) { 
        _playlistSongs.removeAt(foundIndex);
        await _musicPlayerService
          .removeAudioAt(_currentPlaylistId, foundIndex);
      }

      _sucessMessage = "Song has been deleted on the playlist";
    } catch (e) {
      _errorMessage = "Error has occured while deleting the song in the playlist";
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> initialize(String playlistId) async {
    _currentPlaylistId = playlistId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _playlistSongs = await _playlistSongService.getPlaylistSongs(_currentPlaylistId);

      final List<int> songsId = _playlistSongs
        .map((playlistSong) => playlistSong.songId)
        .toList();
      _musicPlayerService.setPlaylist(_currentPlaylistId, songsId);

      _songs = _filterPlaylistSong(_playlistSongs, await _songService.getSongs());
      _playlists = _filterPlaylist(_currentPlaylistId, await _playlistService.getPlaylists());
    } catch (e) {
      _errorMessage = "Error has occured while getting the songs in playlist";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> play(int index) async {
    await _musicPlayerService.seekIndex(_currentPlaylistId, index);
  }

  @override
  Future<void> addSongToPlaylist(String playlistId, int songId) async {
    _errorMessage = null;
    _sucessMessage = null;

    try {
      if (await _playlistSongService.playlistSongExist(playlistId, songId)) {
        _sucessMessage = "Song is already existing in this playlist";
        return;
      }

      await _playlistSongService.addPlaylistSong(
        PlaylistSong(
          id: UuidGenerator.generate(),  
          songId: songId,
          playlistId: playlistId
        )
      );

      _sucessMessage = "Song has been added in the playlist";
    } catch (e) {
      _errorMessage = "Error has occured while adding the song to another playlist";
    }
  }

  @override
  Future<void> addSongToCurrentQueue(int songId) async {
    _errorMessage = null;
    _sucessMessage = null;

    try {
      await _musicPlayerService.addAudioToCurrentQueue(
        _songService.getSongSources[songId]!
      );

      _sucessMessage = "Song has been added in the current queue";
    } catch (e) {
      _errorMessage = "Error has occured while adding the song on you current queue";
    } finally {
      notifyListeners();
    }
  }  

  List<Song> _filterPlaylistSong(List<PlaylistSongDTO> playlistSongs, List<Song> songs) {
    List<Song> filteredSongs = [];
    
    for (var song in songs) {
      bool isFound = false;

      for (var playlistSong in playlistSongs) {
        if (song.id == playlistSong.songId) {
          isFound = true;
        }
      }

      if (!isFound) {
        filteredSongs.add(song);
      }
    }

    return filteredSongs;
  }

  List<Playlist> _filterPlaylist(String currentPlaylistId, List<Playlist> playlists) {
    List<Playlist> filteredPlaylists = [];
    
    for (var playlist in playlists) {
      if (currentPlaylistId != playlist.id) {
        filteredPlaylists.add(playlist);
      }
    }

    return filteredPlaylists;
  }
}