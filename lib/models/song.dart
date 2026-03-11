class Song {
  final int? id;
  final String title;
  final String vibe;
  final String path;
  final bool isFavorite;

  Song({
    this.id,
    required this.title,
    required this.vibe,
    required this.path,
    this.isFavorite = false
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "vibe": vibe,
      "path": path,
      "isFavorite": isFavorite ? 1 : 0
    };
  }

  factory Song.toObject(Map<String, dynamic> map) {
    return Song(
      id: map["id"], 
      title: map["title"] as String,
      vibe: map["vibe"] as String, 
      path: map["path"] as String,
      isFavorite: map["isFavorite"] == 1 ? true : false
    );
  }
}