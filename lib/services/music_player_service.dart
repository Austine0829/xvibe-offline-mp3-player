import 'package:just_audio/just_audio.dart';

// TODO: Turn the service into non-static when you start managing dependencies using provider

class MusicPlayerService {
  static final AudioPlayer _player = AudioPlayer();
  static final Map<String, List<AudioSource>> _playlist = {};
  static String currentPlaylistId = "";

  static LoopMode currentLoopMode = LoopMode.off;
  static bool isShuffle = false;

  static Future<void> play() async {
    await _player.play();
  }

  static Future<void> pause() async {
    await _player.pause();
  }

  static Future<void> seekIndex(String playlistId, int index) async {
    if (currentPlaylistId != playlistId) {
      await setAudioSource(playlistId);
    }

    await _player.seek(Duration(), index: index);
    await play();
  }

  static Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
    currentLoopMode = mode;
  }

  static Future<void> enableShuffle(bool boolean) async {
    await _player.setShuffleModeEnabled(boolean);
    isShuffle = boolean;
  }

  static void setPlaylist(String playlistId, List<AudioSource> playlist) {
    if (_playlist.containsKey(playlistId)) return;
    
    _playlist[playlistId] = playlist;
  }

  static Future<void> setAudioSource(String playlistId) async {
    if (!_playlist.containsKey(playlistId)) throw Exception("You are using a key that doesn't exist");

    await _player.setAudioSources(
      _playlist[playlistId]!,
      initialIndex: 0,
      initialPosition: Duration.zero,
      shuffleOrder: DefaultShuffleOrder()
    );
  }

  static Stream<PlayerState> playerStateStream() {
    return _player.playerStateStream;
  }

  static Stream<Duration> positionStream() {
    return _player.positionStream;
  }

  static Stream<SequenceState> playerSequenceStateStream() {
    return _player.sequenceStateStream;
  }

  static Duration? currentSongDuration() {
    return _player.duration;
  }

  static Future<void> seekTo(Duration duration) async {
    await _player.seek(duration);
  }

  static Future<void> seekNext() async {
    await _player.seekToNext();
  }

   static Future<void> seekPrevious() async {
    await _player.seekToPrevious();
  }

}
