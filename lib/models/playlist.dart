import 'package:skeletonizer/skeletonizer.dart';

class Playlist {
  final String id;
  final String name;
  final Color backgroundColor;

  Playlist({
    required this.id,
    required this.name,
    required this.backgroundColor
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "backgroundColor": backgroundColor.toARGB32()
    };
  }

  factory Playlist.toObject(Map<String, dynamic> map) {
    return Playlist(
      id: map["id"], 
      name: map["name"] as String,
      backgroundColor: Color(map["backgroundColor"] as int) 
    );
  }

  Playlist copyWith({required String name}) {
    return Playlist(
      id: id, 
      name: name,
      backgroundColor: backgroundColor
    );
  }
}