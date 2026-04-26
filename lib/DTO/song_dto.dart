class SongDTO {
  int id;

  SongDTO({
    required this.id
  });

  factory SongDTO.toObject(Map<String, dynamic> map) {
    return SongDTO(
      id: map['id']
    );
  }
}