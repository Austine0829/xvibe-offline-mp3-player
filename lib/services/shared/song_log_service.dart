import 'package:flutter/foundation.dart';
import 'package:xvibe_offline_mp3_player/DTO/song_log_dto.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_song_log_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song_log.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_log_service.dart';
import 'package:xvibe_offline_mp3_player/utils/date_string.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';

class SongLogService extends ChangeNotifier implements ISongLogService {
  late final ISongLogRepository _songLogRepository;
  late final IMusicPlayerService _musicPlayerService;

  List<int> _recentSongsId = [];
  List<int> _topListenSongsId = [];

  SongLogService(
    this._songLogRepository, 
    this._musicPlayerService) {
    _initRecenTracks();
    _initBackgroundJobSongLogger();
  }

  @override
  List<int> get getRecentSongsId => _recentSongsId;

  @override
  List<int> get getTopListenSongsId => _topListenSongsId;

  @override
  Future<List<int>> getTopListenSongsIdWithLimit({int limit = 25}) {
    return _songLogRepository.getTopListenSongsIdWithLimit(limit: limit);
  }

  @override
  Future<List<int>> getRecentSongsIdByDate(String date) async {
    return await _songLogRepository.getSongsId(date: date);
  }

  Future<void> _initRecenTracks() async {
    _recentSongsId = await _songLogRepository.getSongsId(date: DateString.now());
    _topListenSongsId = await _songLogRepository.getTopListenSongsIdWithLimit(limit: 30);
  }

  Future<void> _logTrack(SongLogDTO songLogDTO) async {
   
    await _songLogRepository.add(
      SongLog(
        id: UuidGenerator.generate(), 
        songId: songLogDTO.songId, 
        date: songLogDTO.date
      )
    );

    _recentSongsId.add(songLogDTO.songId);

    await _musicPlayerService.addAudioInPlaylist(Playlistid.recentTrack, songLogDTO.songId);

    notifyListeners();
  }

  int _lastLoggedSongId = -1;

  void _initBackgroundJobSongLogger() {
    _musicPlayerService.positionStream().listen((position) {
      final duration = _musicPlayerService.currentSongDuration();

      if (duration == null || duration.inSeconds == 0) return;
      if (duration.inSeconds > position.inSeconds ) return;

      final int songId = _musicPlayerService.getCurrentPlayingSongId();

      if (songId == -1) return;
      if (songId == _lastLoggedSongId) return;

      _lastLoggedSongId = songId;

      _logTrack(SongLogDTO(
        songId: songId,
        date: DateString.now(),
      ));
    });
  }
}