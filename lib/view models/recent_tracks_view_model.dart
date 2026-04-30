import 'package:flutter/foundation.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/models/playlist_song.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_recent_track_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/utils/date_string.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_recent_tracks_view_model.dart';

class RecentTracksViewModel extends ChangeNotifier implements IRecentTracksViewModel {
  late final IRecentTrackService _recentTrackService;
  late final ISongService _songService;
  late final IPlaylistSongService _playlistSongService;
  late final IMusicPlayerService _musicPlayerService;
  late final IPlaylistService _playlistService;

  late final String _playlistId = Playlistid.recentTrack;
  late List<Playlist> _playlists = [];
  String? _errorMessage;
  bool _isLoading = false;
  String? _successMessage;

  RecentTracksViewModel(
    this._recentTrackService,
    this._songService,
    this._playlistSongService,
    this._musicPlayerService,
    this._playlistService
  ) {
    _recentTrackService.addListener(_onChangeService);
  }

  @override
  List<Playlist> get getPlaylists => _playlists;

  @override
  List<int> get getRecentTracksSongId => _recentTrackService.getRecenTracksSongId;

  @override
  Map<int, Song> get getSongs => _songService.getSongSources;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get successMessage => _successMessage;

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

  @override
  Future<void> play(int index) async {
    _errorMessage = null;

    try {
      await _musicPlayerService.seekIndex(_playlistId, index);
    } catch (e) {
      _errorMessage = "Error has occured while playing the song";
    }
  }
  
  @override
  Future<void> addSongToCurrentQueue(int songId) async {
    _errorMessage = null;
    _successMessage = null;

    try {
      final Song song = _songService.getSongSources[songId]!;

      await _musicPlayerService.addAudioToCurrentQueue(song);

      _successMessage = "Song has been added in the current queue";
    } catch (e) {
      _errorMessage = "Error has occured while adding the song on you current queue";
    } 
  }
  
  @override
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<int> songsId = await _recentTrackService.getRecentTracksSongIdByDate(DateString.now());
      _musicPlayerService.setPlaylist(_playlistId, songsId);
    } catch (e) {
      _errorMessage = "Error has occured while getting songs";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onChangeService() {
    notifyListeners();
  }
}