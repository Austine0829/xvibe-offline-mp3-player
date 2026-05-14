import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:xvibe_offline_mp3_player/constants/hive_keys.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_session_cache_service.dart';

class SessionCacheService implements ISessionCacheService {
  final Box _box = Hive.box(HiveKeys.queueCache);

  @override
  Map<String, dynamic>? loadSession() {
    if (!_box.containsKey(HiveKeys.songsIdKey)) return null;

    return {
      HiveKeys.songsIdKey: (_box.get(HiveKeys.songsIdKey, defaultValue: [])),
      HiveKeys.songIndexKey: _box.get(HiveKeys.songIndexKey, defaultValue: 0),
      HiveKeys.songSecondsPositionKey: _box.get(HiveKeys.songSecondsPositionKey, defaultValue: 0),
      HiveKeys.playlistIdKey: _box.get(HiveKeys.playlistIdKey, defaultValue: ""),
    };
  }

  @override
  Future<void> saveSession({
    required List<int> songsId, 
    required int index, 
    required int startPositionSeconds, 
    required String playlistId
  }) async {
    await _box.putAll({
        HiveKeys.songsIdKey: songsId,
        HiveKeys.songIndexKey: index,
        HiveKeys.songSecondsPositionKey: startPositionSeconds,
        HiveKeys.playlistIdKey: playlistId 
      },
    );
  }
  
  @override
  Future<void> updateStartingPosition(int start) async {
    await _box.put(HiveKeys.songSecondsPositionKey, start);
  }
  
  @override
  Future<void> updateIndex(int index) async {
    await _box.put(HiveKeys.songIndexKey, index);
  }
  
  @override
  Future<void> removeSongAt(int index) async {
     List<int> songsId = List.from(_box.get(HiveKeys.songsIdKey) ?? []);
    
    songsId.removeAt(index);
    await _box.put(HiveKeys.songsIdKey, songsId);
  }
  
  @override
  Future<void> addSongId(int songId) async {
    List<int> songsId = List.from(_box.get(HiveKeys.songsIdKey) ?? []);
    
    songsId.add(songId);
    await _box.put(HiveKeys.songsIdKey, songsId);
  }
}