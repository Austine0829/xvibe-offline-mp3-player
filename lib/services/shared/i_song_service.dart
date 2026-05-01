import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';

abstract class ISongService extends ChangeNotifier {
  
  // ignore: unused_field
  late final ISongRepository _songRepository;

  Map<int, AudioSource> get getAudioSources;

  Map<int, Song> get getSongSources;

  Future<void> addSong(Song song);
  Future<Song> getSong(int songId);
  Future<List<Song>> getSongs({String? vibe});
  Future<void> updateSong(int songId, Song song);
  Future<void> deletSong(int songId);
  Future<List<int>> getSongsId({String? vibe});
  Future<List<int>> getRandomSongsIdWithLimit({int limit = 30});
}