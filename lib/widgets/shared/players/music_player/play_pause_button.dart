import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';

class PlayPauseButton extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;

  const PlayPauseButton({
    super.key,
    required this.musicPlayerService  
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: musicPlayerService.playerStateStream(),
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final playing = playerState?.playing ?? false;

        if (playing) {
          return IconButton(
            onPressed: () async => await musicPlayerService.pause(),
            icon: const Icon(Icons.pause_circle, color: Colors.white, size: 70),
          );
        } else {
          return IconButton(
            onPressed: () async => await musicPlayerService.play(),
            icon: const Icon(Icons.play_circle, color: Colors.white, size: 70),
          );
        }
      },
    );
  }
}

