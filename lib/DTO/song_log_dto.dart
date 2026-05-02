class SongLogDTO {
  final int songId;
  final String date;

  SongLogDTO({
    required this.songId,
    required this.date
  });

  factory SongLogDTO.toObject(Map<String, dynamic> map) {
    return SongLogDTO(
      songId: map["songId"],
      date: map["date"] as String
    );
  }
}