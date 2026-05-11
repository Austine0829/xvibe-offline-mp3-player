import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/DTO/listen_dto.dart';
import 'package:xvibe_offline_mp3_player/DTO/vibe_percentage_dto.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_log_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_analytics_view_model.dart';

class AnalyticsViewModel extends ChangeNotifier implements IAnalyticsViewModel {
  late final ISongService _songService;
  late final IPlaylistService _playlistService;
  late final ISongLogService _songLogService;

  List<VibePercentageDTO> _vibesPercentages = [];
  List<ListenDTO> _listens = [];

  String _listenCount = "";
  String _playlistCount = "";
  String _songCount = ""; 
  String? _errorMessage;
  bool _isLoading = false;

  AnalyticsViewModel(
    this._songService,
    this._playlistService,
    this._songLogService
  );
  
  @override
  String get getListenCount => _listenCount;

  @override
  String get getPlaylistCount => _playlistCount;

  @override
  String get getSongCount => _songCount;

  @override
  String? get errorMessage => _errorMessage;
  
  @override
  bool get isLoading => _isLoading;

  @override
  List<VibePercentageDTO> get getVibesPercentages => _vibesPercentages;

  @override
  List<ListenDTO> get getListens => _listens;

  @override
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
  
    try {
      _listenCount = await _songLogService.getListenCount();
      _playlistCount = await _playlistService.getPlaylistCount();
      _songCount = await _songService.getSongsCount(); 

      _vibesPercentages = await _songService.getVibesPercentages();   
      _listens = await _songLogService.getRecentListensWithWindow(window: 7);

    } catch (e) {
      _errorMessage = "Error has occured while getting the data for analytics";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}