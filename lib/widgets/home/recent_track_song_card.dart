import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_song_log_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/recent_track_song_menu/bottom_swipable_song_menu_sheet.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player_handler.dart';
import '../../utils/app_text_theme.dart';

class RecentTrackSongCard extends StatelessWidget {
  final ISongLogViewModel songLogViewModel;
  final int songId;
  final String songTitle;
  final String songVibe;
  final int indexId;

  const RecentTrackSongCard({
    super.key,
    required this.songLogViewModel,
    required this.songId,
    required this.songTitle,
    required this.songVibe,
    required this.indexId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        songLogViewModel.play(indexId);
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
                      songLogViewModel: songLogViewModel, 
                      songId: songId, 
                      indexId: indexId
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
