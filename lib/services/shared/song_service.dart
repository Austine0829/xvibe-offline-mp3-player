import 'package:xvibe_offline_mp3_player/data/contracts/i_song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';

class SongService implements ISongService {
  late final ISongRepository _songRepository;

  SongService(this._songRepository);
  
  @override
  Future<void> addSong(Song song) async {
    await _songRepository.add(song);
  }

  @override
  Future<void> deletSong(int id) async {
    await _songRepository.delete(id);
  }

  @override
  Future<Song> getSong(int id) async {
    Song song = await _songRepository.get(id);

    return song;
  }

  @override
  Future<List<Song>> getSongs({String? vibe}) async {
    return await _songRepository.getAll(vibe: vibe);
  }

  @override
  Future<void> updateSong(int id, Song song) async {
    await _songRepository.update(id, song);
  }

}