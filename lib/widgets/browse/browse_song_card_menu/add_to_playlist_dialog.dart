import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_browse_vibe_view_model.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final IBrowseVibeViewModel browseVibeViewModel;
  final int songId;

  const AddToPlaylistDialog({
    super.key,
    required this.browseVibeViewModel,
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
    initialize(widget.browseVibeViewModel);
  }

  void initialize(IBrowseVibeViewModel browseVibeViewModel) {
    setState(() {
      _selectedPlaylist = browseVibeViewModel.getPlaylists[0].id;
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
              items: widget.browseVibeViewModel
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
            await widget.browseVibeViewModel
              .addSongToPlaylist(_selectedPlaylist!, widget.songId);
            
            if (!context.mounted) return;

            if (widget.browseVibeViewModel.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.browseVibeViewModel.successMessage!),
                dismissDirection: DismissDirection.startToEnd)
              );
            }

            if (widget.browseVibeViewModel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.browseVibeViewModel.errorMessage!),
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