import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final IVibeViewModel vibeViewModel;
  final int songId;

  const AddToPlaylistDialog({
    super.key,
    required this.vibeViewModel,
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
    initialize(widget.vibeViewModel);
  }

  void initialize(IVibeViewModel vibeViewModel) {
    setState(() {
      _selectedPlaylist = vibeViewModel.getPlaylists[0].id;
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
              items: widget.vibeViewModel
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
            await widget.vibeViewModel
              .addSongToPlaylist(_selectedPlaylist!, widget.songId);
            
            if (!context.mounted) return;

            if (widget.vibeViewModel.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.vibeViewModel.successMessage!),
                dismissDirection: DismissDirection.startToEnd)
              );
            }

            if (widget.vibeViewModel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.vibeViewModel.errorMessage!),
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