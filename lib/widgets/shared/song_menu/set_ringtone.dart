import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/utils/media_store.dart';

class SetRingtone extends StatelessWidget {
  final int songId;

  const SetRingtone({
    super.key,
    required this.songId
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Set Ringtone"),
      content: Text(
        "Are you sure you want to set this song as ringtone into your sim 1?",
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("No")),
        TextButton(
          onPressed: () async {
            bool isSet = await MediaStore.setAsRingtone(songId, "No Title");

            if (context.mounted && isSet) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Song has been set as ringtone")),
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
