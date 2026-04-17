import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';

class MusicPlayerService implements IMusicPlayerService {
  final AudioPlayer _player = AudioPlayer();

  final Map<String, List<AudioSource>> _playlist = {};
  
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
}
