class SongLog {
  final String id;
  final int songId;
  final String date;
  final String weekDay;

  SongLog({
    required this.id,
    required this.songId,
    required this.date,
    required this.weekDay
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "songId": songId,
      "date": date,
    };
  }

  factory SongLog.toObject(Map<String, dynamic> map) {
    return SongLog(
      id: map["id"], 
      songId: map["songId"],
      date: map["data"] as String,
      weekDay: map["weekDay"] as String
    );
  }
}