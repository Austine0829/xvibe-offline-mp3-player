import 'package:just_audio/just_audio.dart';

abstract class IMusicPlayerService {
  // ignore: unused_field
  late final AudioPlayer _player;

  // ignore: unused_field
  final Map<String, List<AudioSource>> _playlist = {};
  late String currentPlaylistId;

  late LoopMode currentLoopMode;
  late bool isShuffle;

  Future<void> play();
  Future<void> pause();
  Future<void> seekIndex(String playlistId, int index);
  Future<void> setLoopMode(LoopMode mode);
  Future<void> enableShuffle(bool boolean);
  void setPlaylist(String playlistId, List<AudioSource> playlist);
  Future<void> setAudioSource(String playlistId);
  Stream<PlayerState> playerStateStream();
  Stream<Duration> positionStream();
  Stream<SequenceState> playerSequenceStateStream();
  Duration? currentSongDuration();
  Future<void> seekTo(Duration duration);
  Future<void> seekNext();
  Future<void> seekPrevious();
}