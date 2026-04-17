import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/song_menu/bottom_swipable_playlist_song_menu_sheet.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/music_player/swipable_music_player_handler.dart';

class PlaylistSongCard extends StatelessWidget {
  final IPlaylistSongViewModel playlistSongViewModel;
  final String playlistSongId;
  final int songId;
  final String title;
  final String vibe;
  final int indexId;
  
  const PlaylistSongCard({
    super.key,
    required this.playlistSongViewModel,
    required this.playlistSongId,
    required this.songId,
    required this.title,
    required this.vibe,
    required this.indexId
  });

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
      onTap: () {
        playlistSongViewModel.play(indexId);
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color.fromARGB(221, 27, 27, 27),
                  showDragHandle: true,
                  builder: (context) {
                    return BottomSwipablePlaylistSongMenuSheet(
                      playlistSongViewModel: playlistSongViewModel,
                      playlistSongId: playlistSongId,
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
