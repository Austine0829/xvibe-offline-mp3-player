import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/bottom_swipable_song_menu_sheet.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/swipable_music_player_handler.dart';
import '../../utils/app_text_theme.dart';

class HorizontalSongCard extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;
  final String songTitle;
  final String songVibe;
  final String playlistId;
  final int indexId;

  const HorizontalSongCard({
    super.key,
    required this.musicPlayerService,
    required this.songTitle,
    required this.songVibe,
    required this.playlistId,
    required this.indexId,
  });

  Future<void> play(String id, int index) async =>
      await musicPlayerService.seekIndex(id, index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        play(playlistId, indexId);
        SwipableMusicPlayerHandler.show(SwipableMusicPlayer(), context);
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
              child:  Padding(
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
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color.fromARGB(221, 27, 27, 27),
                  showDragHandle: true,
                  builder: (context) {
                    return BottomSwipableSongMenuSheet(
                      playCallBack: () {
                        play(playlistId, indexId);
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
