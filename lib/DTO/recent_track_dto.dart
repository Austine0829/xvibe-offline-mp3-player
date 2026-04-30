class RecentTrackDTO {
  final int songId;
  final String date;

  RecentTrackDTO({
    required this.songId,
    required this.date
  });

  factory RecentTrackDTO.toObject(Map<String, dynamic> map) {
    return RecentTrackDTO(
      songId: map["songId"],
      date: map["date"] as String
    );
  }
}