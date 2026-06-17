import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';

class TitleSubtitle extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;

  const TitleSubtitle({
    super.key,
    required this.musicPlayerService
  });

  @override
  Widget build(BuildContext context) {
    final IMusicPlayerService musicPlayerService = context
        .watch<MusicPlayerService>();

    if (musicPlayerService.getCurrentQueue().isEmpty) {
      return Column(
        children: [
          Text("Null", style: TextStyle(color: Colors.white, fontSize: 18)),
          Text("Null", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      );
    }

    return StreamBuilder(
      stream: musicPlayerService.playerSequenceStateStream(),
      builder: (context, snapshot) {
        final state = snapshot.data;

        if (state == null || state.currentSource == null) {
          return Column(
            children: [
              Text(
                "Null",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
              Text(
                "Null",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          );
        }

        MediaItem mediaItem = state.currentSource?.tag as MediaItem;

        return Column(
          children: [
            SizedBox(
              height: 25,
              child: mediaItem.title.length > 20 ? Marquee(
                text: mediaItem.title,
                style: TextStyle(color: Colors.white, fontSize: 18),
                velocity: 40.0,
                blankSpace: 40.0,
              ) 
              : Text(
                mediaItem.title,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Text(
              mediaItem.extras?["vibe"] ?? "Null",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
