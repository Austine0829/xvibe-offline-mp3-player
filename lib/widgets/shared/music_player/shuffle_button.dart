import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/music_player_service.dart';

class ShuffleButton extends StatefulWidget {

  const ShuffleButton({super.key});

  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {

  Future<void> shuffle(bool isShuffle) async {
    await MusicPlayerService.enableShuffle(isShuffle);
  }

  void enableShuffle(bool isShuffle) => setState(() {
    shuffle(isShuffle);
  });

  @override
  Widget build(BuildContext context) {
    if (MusicPlayerService.isShuffle) {
      return IconButton(
        onPressed: () => enableShuffle(false),
        icon: Icon(Icons.shuffle, color: Colors.white, size: 30),
      );
    }

    return IconButton(
      onPressed: () => enableShuffle(true),
      icon: Icon(Icons.shuffle, color: Colors.grey, size: 30),
    );
  }
}
