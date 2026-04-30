class RecentTrack {
  final String id;
  final int songId;
  final String date;

  RecentTrack({
    required this.id,
    required this.songId,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "songId": songId,
      "date": date,
    };
  }

  factory RecentTrack.toObject(Map<String, dynamic> map) {
    return RecentTrack(
      id: map["id"], 
      songId: map["songId"],
      date: map["data"] as String
    );
  }
}