import 'package:flutter/foundation.dart';

abstract class IRecentTrackService extends ChangeNotifier {
  List<int> get getRecenTracksSongId;

  Future<List<int>> getRecentTracksSongIdByDate(String date);
}