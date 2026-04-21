import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';

class MusicPlayerService extends ChangeNotifier implements IMusicPlayerService {
  final AudioPlayer _player = AudioPlayer();

  final Map<String, List<AudioSource>> _playlist = {};
  List<AudioSource>? _currentQueueSongs = [];
  
  String _currentPlaylistId = "";

  @override
  LoopMode currentLoopMode = LoopMode.off;
  
  @override
  bool isShuffle = false;

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
      _currentQueueSongs = _copyPlaylist(_playlist[_currentPlaylistId]!);
      await setAudioSource(playlistId);
    }

    /*
      user is still currently in the same queue of a playlist but he/she deleted some of the 
      songs in queue but then he/she decides to play again a song inside the playlist page. This one
      will get triggered to reset the current state of the queue similar to the state of the playlist
      itself.
    */
    if (_currentPlaylistId == playlistId 
        && !_isSimilar(_currentQueueSongs!, _playlist[_currentPlaylistId]!)) {
        _currentQueueSongs = _copyPlaylist(_playlist[_currentPlaylistId]!);
        await setAudioSource(playlistId);
    }

    await _player.seek(Duration(), index: index);
    await play();
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
  void setPlaylist(String playlistId, List<AudioSource> playlist) {
    _playlist[playlistId] = playlist;
  }

  @override
  Future<void> setAudioSource(String playlistId) async {
    if (!_playlist.containsKey(playlistId)) throw Exception("You are using a key that doesn't exist");

    await _player.setAudioSources(
      _playlist[playlistId]!,
      initialIndex: 0,
      initialPosition: Duration.zero,
      shuffleOrder: DefaultShuffleOrder()
    );
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
    
    _playlist[playlistId]!.removeAt(index);

    if (_currentPlaylistId != playlistId) return;
      await _player.removeAudioSourceAt(index);
  }

  @override
  Future<void> addAudioInPlaylist(String playlistId, Song song) async {
    if (playlistId.isEmpty) throw Exception("Playlist id is set empty!");

    final AudioSource audioSource = AudioSource.file(song.path, tag: song);
    _playlist[playlistId]!.add(audioSource);
    _player.addAudioSource(audioSource);
  }
  
  @override
  Future<void> addAudioToCurrentQueue(Song song) async {
    int foundIndex = _currentQueueSongs!
      .indexWhere((audioSource) => (audioSource as IndexedAudioSource).tag.id == song.id);

    if (foundIndex != -1) {
      _currentQueueSongs!.removeAt(foundIndex);
      await _player.removeAudioSourceAt(foundIndex);
    }

    final audioSource = AudioSource.file(song.path, tag: song);
    _currentQueueSongs!.add(audioSource);
    await _player.addAudioSource(audioSource);
  }
  
  @override
  List<Song> getCurrentQueue() {
    if (_currentQueueSongs == null) return [];
    
    List<Song> songs = _currentQueueSongs!
    .map((audioSource) {
      final song = (audioSource as IndexedAudioSource).tag as Song;
      return Song(
        id: song.id,
        title: song.title,
        vibe: song.vibe,
        path: song.path,
      );
    }).toList();

    return songs;
  }
  
  @override
  Future<void> removeCurrentQueueSongAt(int index) async {
    if (index <= -1) throw Exception("Set index is invalid");

    _currentQueueSongs!.removeAt(index);
    _player.removeAudioSourceAt(index);

    notifyListeners();
  }
  
  @override
  Future<void> seekIndexInCurrentQueue(int index) async{
    await _player.seek(Duration(), index: index);
    await play();
  }

  List<AudioSource> _copyPlaylist(List<AudioSource> audioSources) {
    List<AudioSource> temporayAudioSources = [];
    
    for (var audioSource in audioSources) {
      temporayAudioSources.add(audioSource);
    }

    return temporayAudioSources;
  }

  bool _isSimilar(List<AudioSource> audioSourcesOne, List<AudioSource> audioSourcesTwo) {
    if (audioSourcesOne.length != audioSourcesTwo.length) return false;

    final songsIdSetOne = audioSourcesOne.map((audioSource) => (audioSource as IndexedAudioSource).tag.id).toSet();
    final songsIdSetTwo = audioSourcesTwo.map((audioSource) => (audioSource as IndexedAudioSource).tag.id).toSet();

    return songsIdSetOne.containsAll(songsIdSetTwo);
  }
}
