import 'package:flutter/foundation.dart';
import 'package:xvibe_offline_mp3_player/DTO/recent_track_dto.dart';
import 'package:xvibe_offline_mp3_player/constants/playlist_id.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_recent_track_repository.dart';
import 'package:xvibe_offline_mp3_player/models/recent_track.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_recent_track_service.dart';
import 'package:xvibe_offline_mp3_player/utils/date_string.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';

class RecentTrackService extends ChangeNotifier implements IRecentTrackService {
  late final IRecentTrackRepository _recentTrackRepository;
  late final IMusicPlayerService _musicPlayerService;

  List<int> _recentTracksSongId = [];

  RecentTrackService(
    this._recentTrackRepository, 
    this._musicPlayerService) {
    _initRecenTracks();
  }

  @override
  List<int> get getRecenTracksSongId => _recentTracksSongId;

  @override
  Future<void> logTrack(RecentTrackDTO recentTrackDTO) async {
   
    if (_isExist(recentTrackDTO.songId)) return;

    await _recentTrackRepository.add(
      RecentTrack(
        id: UuidGenerator.generate(), 
        songId: recentTrackDTO.songId, 
        date: recentTrackDTO.date
      )
    );

    _recentTracksSongId.add(recentTrackDTO.songId);

    await _musicPlayerService.addAudioInPlaylist(Playlistid.recentTrack, recentTrackDTO.songId);

    notifyListeners();
  }
  
  Future<void> _initRecenTracks() async {
    _recentTracksSongId = await _recentTrackRepository.getSongsId(date: DateString.now());
  }

  @override
  Future<List<int>> getRecentTracksSongIdByDate(String date) async {
    return await _recentTrackRepository.getSongsId(date: date);
  }

  bool _isExist(int songId) {
    final int recentTrackSongId = _recentTracksSongId
      .firstWhere((recentTrackSongId) => recentTrackSongId == songId, orElse: () => -1);

    if (recentTrackSongId != -1) return true;

    return false;
  }
}