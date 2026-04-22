import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';

class CurrentQueueSongCard extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;
  final int songId;
  final String title;
  final String vibe;
  final String path;
  final int indexId;

  const CurrentQueueSongCard({
    super.key,
    required this.musicPlayerService,
    required this.songId,
    required this.title,
    required this.vibe,
    required this.path,
    required this.indexId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        musicPlayerService.seekIndexInCurrentQueue(indexId);
        Navigator.pop(context);
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.horizontalCardTitle,
                    ),
                    Text(
                      vibe,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.cardGenre,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () async => await musicPlayerService.removeCurrentQueueSongAt(indexId),
              icon: Icon(Icons.remove_circle_rounded, size: 30),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
