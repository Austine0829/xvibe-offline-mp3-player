import 'package:xvibe_offline_mp3_player/data/contracts/i_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class ISongService {
  
  // ignore: unused_field
  late final IRepository _songRepository;

  Future<void> addSong(Song song);
  Future<Song> getSong(int id);
  Future<List<Song>> getSongs({String? vibe});
  Future<void> updateSong(int id, Song song);
  Future<void> deletSong(int id);
}