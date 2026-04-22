import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';

class RepeatButton extends StatefulWidget {
  final IMusicPlayerService musicPlayerService;

  const RepeatButton({
    super.key,
    required this.musicPlayerService
  });

  @override
  State<RepeatButton> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<RepeatButton> {

  Future<void> repeat(LoopMode mode) async {
    await widget.musicPlayerService.setLoopMode(mode);
  }

  void repeatMode(LoopMode mode) => setState(() {
    repeat(mode);
  });

  @override
  Widget build(BuildContext context) {
    switch (widget.musicPlayerService.currentLoopMode) {
      case LoopMode.off:
        return IconButton(
          onPressed: () => repeatMode(LoopMode.one),
          icon: Icon(Icons.repeat, color: Colors.grey, size: 30),
        );
      case LoopMode.one:
        return IconButton(
          onPressed: () => repeatMode(LoopMode.all),
          icon: Icon(Icons.repeat_one, color: Colors.white, size: 30),
        );

      case LoopMode.all:
        return IconButton(
          onPressed: () => repeatMode(LoopMode.off),
          icon: Icon(Icons.repeat, color: Colors.white, size: 30),
        );
    }
  }
}
