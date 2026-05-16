import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/song_menu/bottom_swipable_playlist_song_menu_sheet.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player_handler.dart';

class FavoriteSongCard extends StatelessWidget {
  final IPlaylistSongViewModel playlistSongViewModel;
  final int songId;
  final String title;
  final String vibe;
  final int indexId;
  final Color backgroundColor;
  
  const FavoriteSongCard({
    super.key,
    required this.playlistSongViewModel,
    required this.songId,
    required this.title,
    required this.vibe,
    required this.indexId,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.black,
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
                color: backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.music_note_rounded),
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
                      songId: songId, 
                      indexId: indexId,
                      deleteCallBack: () async {
                        Navigator.pop(context);

                        String? errorMessage = playlistSongViewModel.errorMessage;
                        if (errorMessage != null) {
                          ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(errorMessage)));
                          return ;
                        }

                        await playlistSongViewModel
                          .removeFavoriteSong(songId);
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
