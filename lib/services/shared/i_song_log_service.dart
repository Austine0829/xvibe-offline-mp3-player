import 'package:flutter/foundation.dart';

abstract class ISongLogService extends ChangeNotifier {
  List<int> get getRecentTracksSongId;
  List<int> get getTopListenTracksSongId;

  Future<List<int>> getRecentTracksSongIdByDate(String date);
}