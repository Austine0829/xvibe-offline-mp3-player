class ListenDTO {
  final String date;
  final String weekDay;
  final int count;

  ListenDTO({
    required this.date,
    required this.weekDay,
    required this.count
  });

  factory ListenDTO.toObject(Map<String, dynamic> map) {
    return ListenDTO(
      date: map["date"] as String, 
      weekDay: map["weekDay"] as String, 
      count: map["count"]
    );
  }
}