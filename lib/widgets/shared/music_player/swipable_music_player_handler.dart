import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/swipable_music_player.dart';

class SwipableMusicPlayerHandler {
  static Future<void> show(
    SwipableMusicPlayer musicPlayer,
    BuildContext context,
  ) {
    return showModalBottomSheet(
      backgroundColor: const Color.fromARGB(
        255,
        83,
        83,
        83,
      ).withValues(alpha: 0.5),
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return musicPlayer;
      },
    );
  }
}
