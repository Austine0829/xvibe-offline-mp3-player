import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/DTO/song_dto.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';

class MusicPlayerService extends ChangeNotifier implements IMusicPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final ISongService _songService;

  final Map<String, List<SongDTO>> _playlistsSongsDTO = {};
  List<Song>? _currentQueueSongs = [];
  
  String _currentPlaylistId = "";

  MusicPlayerService(this._songService);

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
      _currentQueueSongs = _getQueueSongs(_playlistsSongsDTO[_currentPlaylistId]!);
      await setAudioSource(playlistId);
    }

    /*
      user is still currently in the same queue of a playlist but he/she deleted some of the 
      songs in queue but then he/she decides to play again a song inside the playlist page. This one
      will get triggered to reset the current state of the queue similar to the state of the playlist
      itself.
    */
    if (_currentPlaylistId == playlistId 
        && !_isSimilar(_currentQueueSongs!, _playlistsSongsDTO[_currentPlaylistId]!)) {
        _currentQueueSongs = _getQueueSongs(_playlistsSongsDTO[_currentPlaylistId]!);
        await setAudioSource(playlistId);
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
  void setPlaylist(String playlistId, List<SongDTO> playlist) {
    _playlistsSongsDTO[playlistId] = playlist;
  }

  @override
  Future<void> setAudioSource(String playlistId) async {
    if (!_playlistsSongsDTO.containsKey(playlistId)) throw Exception("You are using a key that doesn't exist");

    List<AudioSource> audioSources = [];

    for (var playlistSongsDTO in _playlistsSongsDTO[playlistId]!) {
      audioSources.add(_songService.getAudioSources[playlistSongsDTO.id]!);
    }

    await _player.setAudioSources(
      audioSources,
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
    
    _playlistsSongsDTO[playlistId]!.removeAt(index);

    if (_currentPlaylistId != playlistId) return;
      _currentQueueSongs!.removeAt(index);
      await _player.removeAudioSourceAt(index);
  }

  @override
  Future<void> addAudioInPlaylist(String playlistId, SongDTO songDTO) async {
    if (playlistId.isEmpty) throw Exception("Playlist id is set empty!");

    final AudioSource audioSource = _songService.getAudioSources[songDTO.id]!;
    _playlistsSongsDTO[playlistId]!.add(songDTO);
  
    if (_currentPlaylistId != playlistId) return;
      _currentQueueSongs!.add(_songService.getSongSources[songDTO.id]!);
      await _player.addAudioSource(audioSource);
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
  }
  
  @override
  List<Song> getCurrentQueue() {
    if (_currentQueueSongs == null) return [];

    return _currentQueueSongs!;
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

  List<Song> _getQueueSongs(List<SongDTO> playlistSongsDTO) {
    List<Song> temporarySongs = [];
    
    for (var playlistSongDTO in playlistSongsDTO) {
      final Song song = _songService.getSongSources[playlistSongDTO.id]!;
      temporarySongs.add(song);
    }

    return temporarySongs;
  }

  bool _isSimilar(List<Song> songsOne, List<SongDTO> songsTwo) {
    if (songsOne.length != songsTwo.length) return false;

    final songsIdSetOne = songsOne.map((song) => song.id).toSet();
    final songsIdSetTwo = songsTwo.map((song) => song.id).toSet();

    return songsIdSetOne.containsAll(songsIdSetTwo);
  }
}
