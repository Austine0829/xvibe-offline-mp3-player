class PlaylistSong {
  final String id;
  final String playlistId;
  final int songId;

  PlaylistSong({
    required this.id,
    required this.playlistId,
    required this.songId
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "playlistId": playlistId,
      "songId": songId
    };
  }

  factory PlaylistSong.toObject(Map<String, dynamic> map) {
    return PlaylistSong(
      id: map["id"], 
      playlistId: map["playlistId"] as String,
      songId: map["songId"] 
    );
  }
}