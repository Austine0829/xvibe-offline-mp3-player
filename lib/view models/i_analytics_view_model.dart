import 'package:xvibe_offline_mp3_player/DTO/listen_dto.dart';
import 'package:xvibe_offline_mp3_player/DTO/vibe_percentage_dto.dart';

abstract class IAnalyticsViewModel {
  String get getSongCount;
  String get getPlaylistCount;
  String get getListenCount; 
  String? get errorMessage;
  List<VibePercentageDTO> get getVibesPercentages;
  bool get isLoading;
  List<ListenDTO> get getListens;

  Future<void> initialize();
}