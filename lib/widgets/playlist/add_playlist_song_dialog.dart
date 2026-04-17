import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/add_playlist_song_card.dart';

class AddPlaylistSongDialog extends StatelessWidget {
  final IPlaylistSongViewModel playlistSongViewModel;

  const AddPlaylistSongDialog({
    super.key,
    required this.playlistSongViewModel
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        initialChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            controller: scrollController,
            itemCount: playlistSongViewModel.getSongs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  AddPlaylistSongCard(
                    playlistSongViewModel: playlistSongViewModel,
                    songId: playlistSongViewModel.getSongs[index].id, 
                    title: playlistSongViewModel.getSongs[index].title, 
                    vibe: playlistSongViewModel.getSongs[index].vibe,
                    path: playlistSongViewModel.getSongs[index].path,
                  ),
                  SizedBox(height: 5,)
                ],
              );
            }
          );
        },
      ),
    );
  }
}
