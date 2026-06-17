import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:xvibe_offline_mp3_player/DTO/vibe_count_dto.dart';
import 'package:xvibe_offline_mp3_player/DTO/vibe_percentage_dto.dart';
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
  Future<List<int>> getSongsId({String? vibe}) async {
    return await _songRepository.getAllId(vibe: vibe);
  }

  @override
  Future<List<int>> getRandomSongsIdWithLimit({int limit = 30}) async {
    return await _songRepository.getRandomIdWithLimit(limit);
  }

  @override
  Future<List<int>> getSongsIdWithTitle({String title = ""}) async {
    return await _songRepository.getIdWithTitle(title);
  }

  @override
  Future<void> initializeAudioSources() async {
    final List<Song> songs = await _songRepository.getAll();

    for (var song in songs) {
      _audioSources[song.id] = AudioSource
        .file(
          song.path, 
          tag: MediaItem(
              id: song.id.toString(), 
              title: song.title,
              album: "Album",
              artist: "Artist",
              extras: {
                "backgroundColor": song.backgroundColor.toARGB32(),
                "vibe": song.vibe
              }
            )
          );
      _songSources[song.id] = song;
    }
  }
  
  @override
  Future<String> getSongsCount() async {
    return await _songRepository.getCount();
  }

  @override
  Future<List<VibePercentageDTO>> getVibesPercentages() async {
    final String songsCount = await _songRepository.getCount();  
    final List<VibeCountDTO> vibesCount = await _songRepository.getVibesCount();
    List<VibePercentageDTO> vibesPercentagesDTO = [];

    for (var vibeCount in vibesCount) {
      const int oneHundred = 100;

      final vibePercentageDTO = VibePercentageDTO(
        vibe: vibeCount.vibe, 
        percentage: (vibeCount.count / int.parse(songsCount) * oneHundred)
      );

      vibesPercentagesDTO.add(vibePercentageDTO);
    }

    return vibesPercentagesDTO;
  }
  
  @override
  Future<void> updateFavorite(int songId, bool isFavorite) async {
    final Song song = _songSources[songId]!;

    final Song updatedSong = song.updateFavorite(isFavorite: isFavorite);

    await _songRepository.update(songId, updatedSong);

    _audioSources[songId] = AudioSource.file(updatedSong.path, tag: updatedSong);
    _songSources[songId] = updatedSong;

    notifyListeners();
  }
  
  @override
  Future<List<Song>> getFavoriteSongs() async {
    return await _songRepository.getFavoriteSongs();
  }
}