import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class IVibeViewModel {
  List<Song> get getSongs;
  String? get errorMessage;
  bool get isLoading;

  Future<void> play(int index);

  Future<void> update(int id, Song song);
  Future<void> initialize();
  Future<bool> delete(int id);
}