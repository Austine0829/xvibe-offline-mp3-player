import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';

class DeleteSongDialog extends StatelessWidget {
  final IVibeViewModel vibeViewModel;
  final int songId;

  const DeleteSongDialog({
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
            await vibeViewModel.deleteSong(songId);

            if (!context.mounted) return;

            final String? successMessage = vibeViewModel.successMessage;
            if (successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(successMessage)),
              );
            }

            final String? errorMessage = vibeViewModel.errorMessage;
            if (errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
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
