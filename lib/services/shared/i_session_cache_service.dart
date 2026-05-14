abstract class ISessionCacheService {

  Future<void> saveSession({
    required List<int> songsId,
    required int index,
    required int startPositionSeconds,
    required String playlistId
  });

  Map<String, dynamic>? loadSession();
  Future<void> updateStartingPosition(int seconds);
  Future<void> updateIndex(int index);
  Future<void> removeSongAt(int index);
  Future<void> addSongId(int songId);
}