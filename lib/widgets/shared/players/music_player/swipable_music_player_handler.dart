import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';

class SwipableMusicPlayerHandler {
  static Future<void> show(
    SwipableMusicPlayer musicPlayer,
    BuildContext context,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.black,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return musicPlayer;
      },
    );
  }
}
