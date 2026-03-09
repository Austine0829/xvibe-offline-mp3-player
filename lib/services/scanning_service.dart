import 'dart:io';

class ScanningService {

  static Future<List<File>> scanMp3Songs(List<String> pathList) async {
    List<String> paths = pathList;
    
    List<File> songs = [];

    for (var path in paths) {
      final Directory dir = Directory(path);

      if (!dir.existsSync()) continue;

      await for (var file in dir.list(recursive: true)) {
          if (file is File && file.path.endsWith(".mp3")) {
            songs.add(file);
          }
      }
    }

    return songs;
  }
}