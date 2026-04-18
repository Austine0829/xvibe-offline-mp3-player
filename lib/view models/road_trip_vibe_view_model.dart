import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';

class RoadTripVibeViewModel extends ChangeNotifier implements IVibeViewModel  {  
  late final IMusicPlayerService _musicPlayerService;
  late final ISongService _songService;
  late final ILabelingService _labelingService;
  late final IPlaylistService _playlistService;
  late final IPlaylistSongService _playlistSongService;

  late final String _playlistId = Playlistid.chill;
  late List<Song> _songs = [];
  late List<Playlist> _playlists = [];
  String? _errorMessage;
  bool _isLoading = false;
  String? _successMessage;

  RoadTripVibeViewModel(
    this._songService, 
    this._musicPlayerService,
    this._labelingService,
    this._playlistService,
    this._playlistSongService
  );

  @override
  List<Song> get getSongs => _songs;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get isLoading => _isLoading;

  @override
  List<Playlist> get getPlaylists => _playlists;

  @override
  String? get successMessage => _successMessage;

  String generateLabel() => _labelingService.generate(LabelType.chill);

  @override
  Future<void> play(int index) async {
    _errorMessage = null;

    try {
      _musicPlayerService.seekIndex(_playlistId, index);
    } catch (e) {
      _errorMessage = "Error has occured while playing the song";
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> deleteSong(int songId) async {
    _errorMessage = null;
    _successMessage = null;

    try {
      final bool isDeleted = await MediaStore.deleteSong(songId);

      if (!isDeleted) {
        _errorMessage = "Error has occured while deleting the song";
        return;  
      }

      await _songService.deletSong(songId);

      int foundIndex = _songs.indexWhere((song) => song.id == songId);
      if (foundIndex != -1) {
        _songs.removeAt(foundIndex);
        await _musicPlayerService.removeAudioAt(_playlistId, foundIndex);
      }

      _successMessage = "Song has been deleted";
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> updateSong(int songId, Song song) async {
    _errorMessage = null;
    _successMessage = null;

    try {
      await _songService.updateSong(songId, song);
      
      int foundIndex = _songs.indexWhere((song) => song.id == songId);
      if (foundIndex != -1) _songs[foundIndex] = song;

      _successMessage = "Song has been updated";
    } catch (e) {
      _errorMessage = "Error has occured while updating the song";
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
      _songs = await _songService.getSongs(vibe: Vibe.chill);
      final List<AudioSource> playlist = _songs.map((song) => 
      AudioSource.file(song.path, tag: song)).toList();

      _musicPlayerService.setPlaylist(_playlistId, playlist);
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
}