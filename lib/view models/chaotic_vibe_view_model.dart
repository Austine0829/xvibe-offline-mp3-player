import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/constants/vibe.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/home/i_labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/utils/media_store.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_home_page_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';

class ChaoticVibeViewModel extends ChangeNotifier implements IVibeViewModel  {  
  late final IMusicPlayerService _musicPlayerService;
  late final ISongService _songService;
  late final ILabelingService _labelingService;
  late final IPlaylistService _playlistService;
  late final IPlaylistSongService _playlistSongService;
  late final IHomePageViewModel _homePageViewModel;

  late final String _playlistId = Playlistid.chaotic;
  late List<Playlist> _playlists = [];
  late List<int> _songsId = [];
  String? _errorMessage;
  bool _isLoading = false;
  String? _successMessage;

  ChaoticVibeViewModel(
    this._songService, 
    this._musicPlayerService,
    this._labelingService,
    this._playlistService,
    this._playlistSongService,
    this._homePageViewModel
  ) {
    _songService.addListener(_onChangeService);
  }
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get isLoading => _isLoading;

  @override
  List<Playlist> get getPlaylists => _playlists;

  @override
  String? get successMessage => _successMessage;

  @override
  List<int> get getSongsId => _songsId;

  @override
  Map<int, Song> get getSongs => _songService.getSongSources;

  String generateLabel() => _labelingService.generate(LabelType.chaotic);

  @override
  Future<void> play(int index) async {
    _errorMessage = null;

    try {
      _musicPlayerService.seekIndex(_playlistId, index);
    } catch (e) {
      _errorMessage = "Error has occured while playing the song";
    } 
  }

  @override
  Future<void> deleteSong(int songId) async {
    _errorMessage = null;
    _successMessage = null;

    try {
      final bool isDeleted = await MediaStore.deleteSong(songId);

      if (!isDeleted) {
        _errorMessage = "Error has occured while deleting the song in your file system";
        return;  
      }

      await _songService.deletSong(songId);

      int foundIndex = _songsId.indexWhere((songID) => songID == songId);
      if (foundIndex != -1) await _musicPlayerService.removeAudioAt(_playlistId, foundIndex);

      _successMessage = "Song has been deleted";
    } catch (e) {
      _errorMessage = "Error has occured while deleting the song";
    } finally {
      _homePageViewModel.notify();
    }
  }

  @override
  Future<void> updateSong(int songId, Song song) async {
    _errorMessage = null;
    _successMessage = null;

    try {
      await _songService.updateSong(songId, song);

      if (song.vibe == Vibe.chaotic) return;

      int foundIndex = _songsId.indexWhere((songID) => songID == songId);
      if (foundIndex != -1) _songsId.removeAt(foundIndex);

      _successMessage = "Song has been updated";
    } catch (e) {
      _errorMessage = "Error has occured while updating the song";
    } finally {
      _homePageViewModel.notify();
    }
  }
  
  @override
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _songsId = await _songService.getSongsId(vibe: Vibe.chaotic);
      _musicPlayerService.setPlaylist(_playlistId, _songsId);
    } catch (e) {
      _errorMessage = "Error has occured while getting songs";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  @override
  Future<void> addSongToPlaylist(String playlistId, int songId) async {
    _errorMessage = null;

    try {
      if (await _playlistSongService
          .playlistSongExist(playlistId, songId)) {
        _successMessage = "Song is already existing in this playlist";
        return ;
      }

      await _playlistSongService.addPlaylistSong(
        PlaylistSong(
          id: UuidGenerator.generate(), 
          playlistId: playlistId, 
          songId: songId
        )
      );

      _successMessage = "Song has been added in the playlist";
    } catch (e) {
      _errorMessage = "Error has occured while adding the song in the playlist";
    } finally {
      notifyListeners();
    }
  }
  
  @override
  Future<void> getAllPlaylist() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _playlists = await _playlistService.getPlaylists();
    } catch (e) {
      _errorMessage = "Error has occured while getting playlists";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onChangeService() {
    notifyListeners();
  }
}