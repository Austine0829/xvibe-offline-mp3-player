import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/DTO/listen_dto.dart';

abstract class ISongLogService extends ChangeNotifier {
  List<int> get getRecentSongsId;
  List<int> get getTopListenSongsId;

  Future<List<int>> getRecentSongsIdByDate(String date);
  Future<List<int>> getTopListenSongsIdWithLimit({int limit = 25});
  Future<String> getListenCount();
  Future<List<ListenDTO>> getRecentListensWithWindow({int window = 0});
}