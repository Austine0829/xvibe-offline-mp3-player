class PlaylistSongDTO {
  final String playlistSongId;
  final int songId;
  final String title;
  final String vibe;
  final String path;

  PlaylistSongDTO({
    required this.playlistSongId,
    required this.songId,
    required this.title,
    required this.vibe,
    required this.path,
  });

  factory PlaylistSongDTO.toObject(Map<String, dynamic> map) {
    return PlaylistSongDTO(
      playlistSongId: map['playlist_song_id'],
      songId: map["song_id"],
      title: map['title'],
      vibe: map['vibe'],
      path: map['path'],
    );
  }
}