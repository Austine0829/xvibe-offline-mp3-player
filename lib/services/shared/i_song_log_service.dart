import 'package:flutter/foundation.dart';

abstract class ISongLogService extends ChangeNotifier {
  List<int> get getRecenTracksSongId;

  Future<List<int>> getRecentTracksSongIdByDate(String date);
}