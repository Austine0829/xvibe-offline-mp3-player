import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_recent_tracks_view_model.dart';

class AddToPlaylistDialog extends StatefulWidget {
  final IRecentTracksViewModel recentTracksViewModel;
  final int songId;

  const AddToPlaylistDialog({
    super.key,
    required this.recentTracksViewModel,
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
    initialize(widget.recentTracksViewModel);
  }

  void initialize(IRecentTracksViewModel recentTracksViewModel) {
    setState(() {
      _selectedPlaylist = recentTracksViewModel.getPlaylists[0].id;
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
              items: widget.recentTracksViewModel
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
            await widget.recentTracksViewModel
              .addSongToPlaylist(_selectedPlaylist!, widget.songId);
            
            if (!context.mounted) return;

            if (widget.recentTracksViewModel.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.recentTracksViewModel.successMessage!),
                dismissDirection: DismissDirection.startToEnd)
              );
            }

            if (widget.recentTracksViewModel.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.recentTracksViewModel.errorMessage!),
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