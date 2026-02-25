import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/bottom_swipable_song_menu_sheet.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/swipable_music_player.dart';

import '../../utils/app_text_theme.dart';

class HorizontalSongCard extends StatelessWidget {
  final String songTitle;
  final String songVibe;

  const HorizontalSongCard({
    super.key,
    required this.songTitle,
    required this.songVibe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: const Color.fromARGB(255, 83, 83, 83).withValues(alpha: 0.5),
          showDragHandle: true,
          isScrollControlled: true,
          context: context, 
          builder: (context) {
            return SwipableMusicPlayer();
          },
        );
      },
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/music_card_default.jpeg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.horizontalCardTitle,
                  ),
                  Text(
                    songVibe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.cardGenre,
                  ),
                ],
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color.fromARGB(221, 27, 27, 27),
                  showDragHandle: true,
                  builder: (context) {
                    return BottomSwipableSongMenuSheet();
                  },
                );
              },
              icon: Icon(Icons.more_vert),
              color: Colors.white,
            ),
          ],
        ),
      ),
    ) ;
  }
}
