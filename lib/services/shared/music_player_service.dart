import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/constants/hive_keys.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_session_cache_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';

// NOTE: queue and playlist management is also implemented here for simplicity.
// Might not refactor it on future because i'm lazy to do so.

class MusicPlayerService extends ChangeNotifier implements IMusicPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final ISongService _songService;
  final ISessionCacheService _sessionCacheService;

  final Map<String, List<int>> _playlistsSongsId = {};
  List<Song>? _currentQueueSongs = [];
  
  String _currentPlaylistId = "";

  bool _isLoading = false;

  MusicPlayerService(
    this._songService, 
    this._sessionCacheService) {
      _initPreviousSession();
      _initBackgroundJobSessionCaching();
    }

  @override
  LoopMode currentLoopMode = LoopMode.all;
  
  @override
  bool isShuffle = false;

  @override
  bool get isLoading => _isLoading;

  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> seekIndex(String playlistId, int index) async {
    if (_currentPlaylistId != playlistId) {
      _currentPlaylistId = playlistId;

      _initSongSourcesAndSaveSessionThenPlay(playlistId, index);
      return;
    }

    /*
      user is still currently in the same queue of a playlist but he/she deleted some of the 
      songs in queue but then he/she decides to play again a song inside the playlist page. This one
      will get triggered to reset the current state of the queue similar to the state of the playlist
      itself.
    */
    if (_currentPlaylistId == playlistId 
        && !_isSimilar(_currentQueueSongs!, _playlistsSongsId[_currentPlaylistId]!)) {
        _initSongSourcesAndSaveSessionThenPlay(playlistId, index);
      return;
    }

    await _player.seek(Duration(), index: index);
    await play();

    notifyListeners();
  }

  @override
  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
    currentLoopMode = mode;
  }

  @override
  Future<void> enableShuffle(bool boolean) async {
    await _player.setShuffleModeEnabled(boolean);
    isShuffle = boolean;
  }

  @override
  void setPlaylist(String playlistId, List<int> songsId) {
    _playlistsSongsId[playlistId] = songsId;
  }

  @override
  Stream<PlayerState> playerStateStream() {
    return _player.playerStateStream;
  }

  @override
  Stream<Duration> positionStream() {
    return _player.positionStream;
  }

  @override
  Stream<SequenceState> playerSequenceStateStream() {
    return _player.sequenceStateStream;
  }

  @override
  Duration? currentSongDuration() {
    return _player.duration;
  }

  @override
  Future<void> seekTo(Duration duration) async {
    await _player.seek(duration);
  }

  @override
  Future<void> seekNext() async {
    await _player.seekToNext();
  }

  @override
  Future<void> seekPrevious() async {
    await _player.seekToPrevious();
  }

  @override
  Future<void> removeAudioAt(String playlistId, int index) async {
    if (playlistId.isEmpty) throw Exception("Playlist id is set emtpy!");
    
    _playlistsSongsId[playlistId]!.removeAt(index);

    if (_currentPlaylistId != playlistId) return;

    _currentQueueSongs!.removeAt(index);
    await _player.removeAudioSourceAt(index);
    _sessionCacheService.removeSongAt(index);
  }

  @override
  Future<void> addAudioInPlaylist(String playlistId, int songId) async {
    if (playlistId.isEmpty) throw Exception("Playlist id is set empty!");

    final AudioSource audioSource = _songService.getAudioSources[songId]!;
    _playlistsSongsId[playlistId]!.add(songId);
  
    if (_currentPlaylistId != playlistId) return;

    _currentQueueSongs!.add(_songService.getSongSources[songId]!);
     await _player.addAudioSource(audioSource);
     _sessionCacheService.addSongId(songId);
  }
  
  @override
  Future<void> addAudioToCurrentQueue(Song song) async {
    int foundIndex = _currentQueueSongs!
      .indexWhere((queueSong) => queueSong.id == song.id);

    if (foundIndex != -1) {
      _currentQueueSongs!.removeAt(foundIndex);
      await _player.removeAudioSourceAt(foundIndex);
    }

    _currentQueueSongs!.add(song);
    final audioSource = AudioSource.file(song.path, tag: song);    
    await _player.addAudioSource(audioSource);
    await _sessionCacheService.addSongId(song.id);

    if (_currentPlaylistId.isNotEmpty) return;
    _player.play();
  }
  
  @override
  List<Song> getCurrentQueue() {
    if (_currentQueueSongs == null) return [];

    return _currentQueueSongs!;
  }
  
  @override
  Future<void> removeCurrentQueueSongAt(int index) async {
    if (index <= -1) throw Exception("Set index is invalid");

    _isLoading = true;
    notifyListeners();

    try {
      _currentQueueSongs!.removeAt(index);
      await _player.removeAudioSourceAt(index);
      await _sessionCacheService.removeSongAt(index);
    } catch (e) {
      debugPrint("Music Player Error: ${e.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  @override
  Future<void> seekIndexInCurrentQueue(int index) async{
    await _player.seek(Duration(), index: index);
    await play();
  }

  List<Song> _getQueueSongs(List<int> songsId) {
    List<Song> temporarySongs = [];
    
    for (var songId in songsId) {
      final Song song = _songService.getSongSources[songId]!;
      temporarySongs.add(song);
    }

    return temporarySongs;
  }
  
  @override
  int getCurrentPlayingSongId() {
    final int? songId = _player.sequenceState.currentSource?.tag.id;

    if (songId == null) return -1;

    return songId;
  }
  
  @override
  Future<void> addAudioToCurrentQueueAndPlay(Song song) async {
    int foundIndex = _currentQueueSongs!
      .indexWhere((queueSong) => queueSong.id == song.id);

    if (foundIndex != -1) {
      _currentQueueSongs!.removeAt(foundIndex);
      await _player.removeAudioSourceAt(foundIndex);
    }

    _currentQueueSongs!.add(song);
    final audioSource = AudioSource.file(song.path, tag: song);    
    await _player.addAudioSource(audioSource);

    await _player.play();
    await _player.seek(Duration(), index: _currentQueueSongs!.length - 1);
  }

  Future<void> _setAudioSource(String playlistId, int initialIndex) async {
    if (!_playlistsSongsId.containsKey(playlistId)) throw Exception("You are using a key that doesn't exist");

    List<AudioSource> audioSources = [];

    for (var songId in _playlistsSongsId[playlistId]!) {
      audioSources.add(_songService.getAudioSources[songId]!);
    }

    await _player.setAudioSources(
      audioSources,
      initialIndex: initialIndex,
      shuffleOrder: DefaultShuffleOrder()
    );
  }

  bool _isSimilar(List<Song> songs, List<int> songsId) {
    if (songs.length != songsId.length) return false;

    final songsIdSetOne = songs.map((song) => song.id).toSet();
    final songsIdSetTwo = songsId.map((songId) => songId).toSet();

    return songsIdSetOne.containsAll(songsIdSetTwo);
  }

  void _initPreviousSession() async {
    final dynamic previousSession = _sessionCacheService.loadSession();

    if (previousSession == null) return;

    _currentPlaylistId = previousSession[HiveKeys.playlistIdKey];

    final List<int> previousSessionSongsId = previousSession[HiveKeys.songsIdKey];

    _playlistsSongsId[_currentPlaylistId] = previousSessionSongsId;
    _currentQueueSongs = _getQueueSongs(previousSessionSongsId);

    final initialIndex = previousSession[HiveKeys.songIndexKey];

    await _setAudioSource(_currentPlaylistId, initialIndex);
    await _player.seek(
      Duration(seconds: previousSession[HiveKeys.songSecondsPositionKey]), 
      index: initialIndex
    );
  }

  void _initBackgroundJobSessionCaching() {
    _player.positionStream.listen((position) async {
        await _sessionCacheService
          .updateStartingPosition(position.inSeconds);
      }
    );

    _player.sequenceStateStream.listen((data) async {
        int? currentIndex = data.currentIndex;

        if (currentIndex == null) return;

        await _sessionCacheService.updateIndex(currentIndex);
      }
    );
  }

  Future<void> _initSongSourcesAndSaveSessionThenPlay(
    String playlistId, int index) async {
      _currentQueueSongs = _getQueueSongs(_playlistsSongsId[_currentPlaylistId]!);
      await _setAudioSource(playlistId, index);
      await _sessionCacheService.saveSession(
        songsId: _playlistsSongsId[playlistId]!, 
        index: index, 
        startPositionSeconds: 0, 
        playlistId: playlistId
      );

      await play();

      notifyListeners();
  }
}
