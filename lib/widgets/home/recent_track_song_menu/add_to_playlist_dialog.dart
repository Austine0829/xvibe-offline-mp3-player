import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_song_log_view_model.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final ISongLogViewModel songLogViewModel;
  final int songId;

  const AddToPlaylistDialog({
    super.key,
    required this.songLogViewModel,
    required this.songId
  });

  @override
  State<AddToPlaylistDialog> createState() => _AddToPlaylistDialogState();
}

class _AddToPlaylistDialogState extends State<AddToPlaylistDialog> {
  String? _selectedPlaylist;

  @override
  void initState() {
    super.initState();
    initialize(widget.songLogViewModel);
  }

  void initialize(ISongLogViewModel songLogViewModel) {
    setState(() {
      _selectedPlaylist = songLogViewModel.getPlaylists[0].id;
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
              items: widget.songLogViewModel
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
            await widget.songLogViewModel
              .addSongToPlaylist(_selectedPlaylist!, widget.songId);
            
            if (!context.mounted) return;

            if (widget.songLogViewModel.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.songLogViewModel.successMessage!),
                dismissDirection: DismissDirection.startToEnd)
              );
            }

            if (widget.songLogViewModel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.songLogViewModel.errorMessage!),
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