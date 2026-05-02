import 'package:flutter/foundation.dart';

abstract class ISongLogService extends ChangeNotifier {
  List<int> get getRecentSongsId;
  List<int> get getTopListenSongsId;

  Future<List<int>> getRecentSongsIdByDate(String date);
  Future<List<int>> getTopListenSongsIdWithLimit({int limit = 25});
}