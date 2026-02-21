import 'dart:math';

enum LabelType {
  energetic,
  chill,
  roadTrip,
  chaotic,
  acoustic
}

class LabelingService {
  static final _random = Random();

  static const Map<LabelType, List<String>> _labels = {
    LabelType.energetic: [
      "Energetic Vibes",
      "Music to fuel your fire",
      "High-energy hits to lift you up",
      "Get pumped with every beat",
      "Tracks that spark unstoppable energy",
    ],
    LabelType.chill: [
      "Chill Vibes",
      "Relax and let the music breathe",
      "Easy tunes for lazy afternoons",
      "Chill out and just breathe",
      "Smooth beats to unwind",
    ],
    LabelType.roadTrip: [
      "Road Trip Vibes",
      "The perfect soundtrack for highways",
      "Pack your playlist, hit the road",
      "Tracks for sunsets and long drives",
      "Turn the wheels and feel alive",
    ],
    LabelType.chaotic: [
      "Chaotic Vibes",
      "Frantic beats to fuel your energy",
      "Disorder never sounded so good",
      "Music that shakes up your day",
      "Tunes that break all the rules"
    ],
    LabelType.acoustic: [
      "Acoustic Vibes",
      "Acoustic sounds for late-night thoughts",
      "Stripped-down tunes for you",
      "When all you need is simple sound",
      "Pure music with nothing to hide"
    ]
  };

  static String generate(LabelType type) {
    final list = _labels[type]!;
    return list[_random.nextInt(list.length)];
  }
}
