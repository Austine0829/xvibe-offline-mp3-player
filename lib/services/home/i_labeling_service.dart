import 'dart:math';

import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';

abstract class ILabelingService {
  // ignore: unused_field
  late final Random _random;
  late final Map<LabelType, List<String>> labels;
  
  String generate(LabelType type);
}