import 'package:flutter/foundation.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/constants/vibe.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_browse_vibe_view_model.dart';

class BrowseVibeViewModel extends ChangeNotifier implements IBrowseVibeViewModel {
  late final IMusicPlayerService _musicPlayerService;
  late final IPlaylistSongService _playlistSongService;
  late final ISongService _songService;
  late final IPlaylistService _playlistService;
  
  List<Song> _songs = []; 
  List<Playlist> _playlists = [];

  final List<String> _vibes = [
    Vibe.roadTrip,
    Vibe.energetic,
    Vibe.chill,
    Vibe.acoustic,
    Vibe.chaotic
  ];

  final List<String> _vibesPlaylistId = [
    Playlistid.roadTrip,
    Playlistid.energetic,
    Playlistid.chill,
    Playlistid.acoustic,
    Playlistid.chaotic
  ];

  String _currentPlaylistId = "";
  String? _errorMessage;
  String? _sucessMessage;
  bool _isLoading = false;

  BrowseVibeViewModel(
    this._musicPlayerService,
    this._playlistSongService,
    this._songService,
    this._playlistService
  );
    
  @override
  List<Song> get getSongs => _songs;

  @override
  List<Playlist> get getPlaylists => _playlists;

  @override
  String? get errorMessage => _errorMessage;

   @override
  bool get isLoading => _isLoading;

  @override
  String? get successMessage => _sucessMessage;

  @override
  List<String> get getVibesPlaylistId => _vibesPlaylistId;

  @override
  List<String> get getVibes => _vibes;

  @override
  Future<void> addSongToCurrentQueue(int songId) async {
    _errorMessage = null;
    _sucessMessage = null;

    try {
      final Song song = _songService.getSongSources[songId]!;

      await _musicPlayerService.addAudioToCurrentQueue(song);

      _sucessMessage = "Song has been added in the current queue";
    } catch (e) {
      _errorMessage = "Error has occured while adding the song on you current queue";
    } finally {
      notifyListeners();
    }
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
  Future<void> initialize(String playlistId, String vibe) async {
    _currentPlaylistId = playlistId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _songs = await _songService.getSongs(vibe: vibe);
      _playlists = await _playlistService.getPlaylists();

      List<int> songsId = await _songService.getSongsId(vibe: vibe);
      _musicPlayerService.setPlaylist(_currentPlaylistId, songsId);

    } catch (e) {
      _errorMessage = "Error has occured while getting songs";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> play(int index) async {
    _errorMessage = null;

    try {
      _musicPlayerService.seekIndex(_currentPlaylistId, index);
    } catch (e) {
      _errorMessage = "Error has occured while playing the song";
    } 
  }
  
  @override
  Future<void> addSongToCurrentQueuePlay(int songId) async {
     _errorMessage = null; 
    _sucessMessage = null;

    try {
      final Song song = _songService.getSongSources[songId]!;

      await _musicPlayerService.addAudioToCurrentQueueAndPlay(song);

      _sucessMessage = "Song has been added in the current queue";
    } catch (e) {
      _errorMessage = "Error has occured while adding the song on you current queue";
    }
  }
  
  @override
  Future<void> getSongsIdWithTitle(String title) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<int> songsId = await _songService.getSongsIdWithTitle(title: title);

      _songs.clear();

      for (var songId in songsId) {
        _songs.add(_songService.getSongSources[songId]!);
      }

    } catch (e) {
      _errorMessage = "Error has occured while getting songs";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}