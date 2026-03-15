import 'package:flutter/services.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_scanning_service.dart';

class MediaStoreMusicScanningService implements IMusicScanningService {
  static const MethodChannel _channel =
      MethodChannel("com.example.mediastore");

  Future<List<Map<String, dynamic>>> _queryAudioFiles() async {
    final result = await _channel.invokeMethod("queryAudio");

    final List list = result;

    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<List<Song>> scanSongs() async {
    List<Song> songs = [];
    final audioFiles = await _queryAudioFiles();

    for (var audioFile in audioFiles) {
      songs.add(
        Song(
          id: audioFile["id"], 
          title: audioFile["title"], 
          vibe: "Chill", 
          path: audioFile["path"])
      );
    }

      return songs;
  }
}