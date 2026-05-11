import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player_handler.dart';

import '../../utils/app_text_theme.dart';

class VibeVerticalSongCard extends StatelessWidget {
  final IVibeViewModel vibeViewModel;
  final String songTitle;
  final String songVibe;
  final int indexId;
  final Color backgroundColor;

  const VibeVerticalSongCard({
    super.key,
    required this.vibeViewModel,
    required this.songTitle,
    required this.songVibe,
    required this.indexId,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
      onTap: () {
        vibeViewModel.play(indexId);
        SwipableMusicPlayerHandler.show(SwipableMusicPlayer(), context);
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.music_note_rounded, size: 80),
            ),
            SizedBox(height: 10),
            Text(
              songVibe,
              maxLines: 1,
              style: Theme.of(context).textTheme.cardGenre,
            ),
            Text(
              songTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.verticalCardTitle,
            ),
          ],
        ),
      ),
    );
  }
}
