import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_scanning_service.dart';
import 'package:xvibe_offline_mp3_player/utils/media_store.dart';

class MediaStoreMusicScanningService implements IMusicScanningService {

  @override
  Future<List<Song>> scanSongs() async {
    List<Song> songs = [];
    final audioFiles = await MediaStore.queryAudioFiles();

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