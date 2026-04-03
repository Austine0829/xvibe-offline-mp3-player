import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/constants/vibe.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/home/i_labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/utils/media_store.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';

class RoadTripVibeViewModel extends ChangeNotifier implements IVibeViewModel  {  
  late final IMusicPlayerService _musicPlayerService;
  late final ISongService _songService;
  late final ILabelingService _labelingService;

  late final String _playlistId = Playlistid.chill;
  late List<Song> _songs = [];
  String? _errorMessage;
  bool _isLoading = false;

  RoadTripVibeViewModel(
    this._songService, 
    this._musicPlayerService,
    this._labelingService
  );

  @override
  List<Song> get getSongs => _songs;
  
  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get isLoading => _isLoading;

  String generateLabel() => _labelingService.generate(LabelType.chill);

  @override
  Future<void> play(int index) async {
    _musicPlayerService.seekIndex(_playlistId, index);
  }

  @override
  Future<bool> delete(int id) async {
    final bool isDeleted = await MediaStore.deleteSong(id);

    if (!isDeleted) {
      return false;
    }

    await _songService.deletSong(id);

    int foundIndex = _songs.indexWhere((song) => song.id == id);

     if (foundIndex != -1) {
      _songs.removeAt(foundIndex);
    }

    notifyListeners();

    return true;
  }

  @override
  Future<void> update(int id, Song song) async {
    await _songService.updateSong(id, song);
    int foundIndex = _songs.indexWhere((song) => song.id == id);

    if (foundIndex != -1) {
      _songs[foundIndex] = song;
    }

    notifyListeners();
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
}