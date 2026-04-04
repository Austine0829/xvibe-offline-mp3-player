import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_view_model.dart';

class PlaylistViewModel extends ChangeNotifier implements IPlaylistViewModel {
  late final IPlaylistService _playlistService;

  List<Playlist> _playlists = [];
  Playlist? _playlist;
  String? _errorMessage;
  bool _isLoading = false;

  PlaylistViewModel(this._playlistService);

   @override
  String? get errorMessage => _errorMessage;

  @override
  List<Playlist> get getPlaylists => _playlists;

  @override
  bool get isLoading => _isLoading;

   @override
  Playlist get getPlaylist => _playlist!;

  @override
  Future<void> add(Playlist playlist) async {
    _errorMessage = null;

    try {
      await _playlistService.addPlaylist(playlist);
      _playlists.add(playlist);
    } catch (e) {
      _errorMessage = "Error has occured while adding playlist";
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<bool> delete(String id) async { 
    _errorMessage = null;

    try {
      await _playlistService.deletePlaylist(id);

      int foundIndex = _playlists.indexWhere((playlist) => playlist.id == id);
      if (foundIndex != -1) _playlists.removeAt(foundIndex);

      return true;

    } catch (e) {
      _errorMessage = "Error has occured while deleting the playlist";
      return false;
    } finally {
      notifyListeners();
    }
  }


  @override
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _playlists = await _playlistService.getPlaylists();
    } catch (e) {
      _errorMessage = "Error has occured while initializing the playlist";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> update(String id, Playlist playlist) async {
    _errorMessage = null;
    
    try {
      await _playlistService.updatePlaylist(id, playlist);

      int foundIndex = _playlists.indexWhere((playlist) => playlist.id == id);
      if (foundIndex != -1) _playlists[foundIndex] = playlist;

    } catch (e) {
      _errorMessage = "Error has occured while updating the playlist";
    } finally {
      notifyListeners();
    }
  }
  
  @override
  Future<void> get(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _playlist = await _playlistService.getPlaylist(id);
    } catch (e) {
      _errorMessage = "Error has occured while getting the playlist";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void sort() {
    _playlists = _playlists.reversed.toList();
    notifyListeners();
  }
} 