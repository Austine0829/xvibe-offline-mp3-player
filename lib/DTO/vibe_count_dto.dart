class VibeCountDTO {
  final String vibe;
  final int count;

  VibeCountDTO({
    required this.vibe,
    required this.count
  });

   factory VibeCountDTO.toObject(Map<String, dynamic> map) {
    return VibeCountDTO(
      vibe: map["vibe"],
      count: map["count"]
    );
  }
}