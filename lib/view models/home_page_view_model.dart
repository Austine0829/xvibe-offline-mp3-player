import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_home_page_view_model.dart';

class HomePageViewModel extends ChangeNotifier implements IHomePageViewModel {
  
  bool _refresh = false;
  
  @override
  void notify() {
    notifyListeners();
    _refresh = true;
  }

  bool refresh() {
    return _refresh;
  }

  void setRefresh(bool refresh) {
    _refresh = refresh;
  }
}