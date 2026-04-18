import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';

class DeleteDialog extends StatelessWidget {
  final IVibeViewModel vibeViewModel;
  final int songId;

  const DeleteDialog({
    super.key, 
    required this.vibeViewModel,
    required this.songId
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete this song?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("No")),
        TextButton(
          onPressed: () async {
            if (await vibeViewModel.delete(songId) && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Song has been successfully deleted")),
              );
              Navigator.pop(context);
            } 
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}
