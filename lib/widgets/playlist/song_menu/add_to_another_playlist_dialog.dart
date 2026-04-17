import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';

class AddToAnotherPlaylistDialog extends StatefulWidget {
  final IPlaylistSongViewModel playlistSongViewModel;
  final int songId;

  const AddToAnotherPlaylistDialog({
    super.key,
    required this.playlistSongViewModel,
    required this.songId
  });

  @override
  State<AddToAnotherPlaylistDialog> createState() => _AddToAnotherPlaylistDialogState();
}

class _AddToAnotherPlaylistDialogState extends State<AddToAnotherPlaylistDialog> {
  String? _selectedPlaylist;

  @override
  void initState() {
    super.initState();
    initialize(widget.playlistSongViewModel);
  }

  void initialize(IPlaylistSongViewModel playlistSongViewModel) {
    setState(() {
      _selectedPlaylist = playlistSongViewModel.getPlaylists[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(
        "Add to Playlist",
        style: TextStyle(fontSize: 20)
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedPlaylist,
              decoration: InputDecoration(
                label: Text("Playlist"),
                border: OutlineInputBorder()
              ),
              items: widget.playlistSongViewModel
                .getPlaylists
                .map((playlist) => 
                  DropdownMenuItem(
                    value: playlist.id, 
                    child: Text(playlist.name)
                  )
                ).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPlaylist = value;
                });
              } 
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Close"),
        ), 
        TextButton(
          onPressed: () async {
            await widget.playlistSongViewModel
              .addSongToPlaylist(_selectedPlaylist!, widget.songId);
            
            if (!context.mounted) return;
            if (widget.playlistSongViewModel.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.playlistSongViewModel.successMessage!),
                dismissDirection: DismissDirection.startToEnd)
              );
            }
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}