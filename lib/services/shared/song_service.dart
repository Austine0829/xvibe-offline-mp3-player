import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_song_repository.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';

class SongService extends ChangeNotifier implements ISongService {
  late final ISongRepository _songRepository;
  final Map<int, AudioSource> _audioSources = {};
  final Map<int, Song> _songSources = {};

  SongService(this._songRepository);
  
  @override
  Map<int, AudioSource> get getAudioSources => _audioSources;

  @override
  Map<int, Song> get getSongSources => _songSources;

  @override
  Future<void> addSong(Song song) async {
    await _songRepository.add(song);
  }

  @override
  Future<void> deletSong(int songId) async {
    await _songRepository.delete(songId);

    _audioSources.remove(songId);
    _songSources.remove(songId);
  
    notifyListeners();
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
  Future<void> updateSong(int songId, Song song) async {
    await _songRepository.update(songId, song);

    _audioSources[songId] = AudioSource.file(song.path, tag: song);
    _songSources[songId] = song;

    notifyListeners();
  }
  
  @override
  Future<void> initializeAudioSources() async {
    final List<Song> songs = await _songRepository.getAll();

    for (var song in songs) {
      _audioSources[song.id] = AudioSource
        .file(song.path, tag: song);
      _songSources[song.id] = song;
    }
  }

  @override
  Future<List<int>> getSongsId({String? vibe}) async {
    return await _songRepository.getAllId(vibe: vibe);
  }
}