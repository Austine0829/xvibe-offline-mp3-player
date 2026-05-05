import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/view%20models/browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/browse/browse_song_card.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player_handler.dart';

class BrowseSearchSongListView extends StatelessWidget {
  const BrowseSearchSongListView({super.key});

  @override
  Widget build(BuildContext context) {
    final IBrowseVibeViewModel browseVibeViewModel = context
        .watch<BrowseVibeViewModel>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          SizedBox(
            height: 0.8 * MediaQuery.of(context).size.height,
            width: double.infinity,
            child: ListView.builder(
              itemCount: browseVibeViewModel.getSongs.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: BrowseSongCard(
                    browseVibeViewModel: browseVibeViewModel,
                    songId: browseVibeViewModel.getSongs[index].id,
                    songTitle: browseVibeViewModel.getSongs[index].title,
                    songVibe: browseVibeViewModel.getSongs[index].vibe,
                    indexId: index,
                    callback: () {
                      final int songId = browseVibeViewModel.getSongs[index].id;
                      browseVibeViewModel.addSongToCurrentQueuePlay(songId);
                      SwipableMusicPlayerHandler.show(SwipableMusicPlayer(), context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
