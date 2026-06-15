import 'dart:ui';
import 'package:hive_ce/hive.dart';

part 'song.g.dart';

@HiveType(typeId: 0)
class Song {

  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;

  @HiveField(2)
  final String vibe;

  @HiveField(3)
  final String path;

  @HiveField(4)
  final bool isFavorite;

  @HiveField(5)
  final Color backgroundColor;

  Song({
    required this.id,
    required this.title,
    required this.vibe,
    required this.path,
    this.isFavorite = false,
    required this.backgroundColor
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "vibe": vibe,
      "path": path,
      "isFavorite": isFavorite ? 1 : 0,
      "backgroundColor": backgroundColor.toARGB32()
    };
  }

  factory Song.toObject(Map<String, dynamic> map) {
    return Song(
      id: map["id"], 
      title: map["title"] as String,
      vibe: map["vibe"] as String, 
      path: map["path"] as String,
      isFavorite: map["isFavorite"] == 1 ? true : false,
      backgroundColor: Color(map["backgroundColor"] as int)
    );
  }

  Song copyWith({required String title, 
                 required String vibe}) {
    return Song(
      id: id, 
      title: title, 
      vibe: vibe, 
      path: path,
      isFavorite: isFavorite,
      backgroundColor: backgroundColor
    );
  }

  Song updateFavorite({required bool isFavorite}) {
    return Song(
      id: id, 
      title: title, 
      vibe: vibe, 
      path: path,
      isFavorite: isFavorite,
      backgroundColor: backgroundColor
    );
  }

  Song updateVibe({required String vibe}) {
    return Song(
      id: id, 
      title: title, 
      vibe: vibe, 
      path: path,
      isFavorite: isFavorite,
      backgroundColor: backgroundColor
    );
  }
}