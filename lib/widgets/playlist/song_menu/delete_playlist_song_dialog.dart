import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';

class DeletePlaylistSongDialog extends StatelessWidget {
  final IPlaylistSongViewModel playlistSongViewModel;
  final String playlistSongId;

  const DeletePlaylistSongDialog({
    super.key,
    required this.playlistSongViewModel,
    required this.playlistSongId
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete this song in the playlist?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("No")),
        TextButton(
          onPressed: () async {
            await playlistSongViewModel
              .deletePlaylistSong(playlistSongId);

            if (!context.mounted) return;

            if (playlistSongViewModel.successMessage != null) {
              ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(playlistSongViewModel.successMessage!))
              );
            }

            if (playlistSongViewModel.errorMessage != null) {
              ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(playlistSongViewModel.errorMessage!))
              );
            }

            Navigator.pop(context);
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}