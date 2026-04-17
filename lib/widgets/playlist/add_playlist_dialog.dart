import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/utils/random_color_picker.dart';
import 'package:xvibe_offline_mp3_player/utils/uuid_generator.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_view_model.dart';

class AddPlaylistDialog extends StatefulWidget {
  final IPlaylistViewModel playlistViewModel;

  const AddPlaylistDialog({
    super.key,
    required this.playlistViewModel,
  });

  @override
  State<AddPlaylistDialog> createState() => _AddPlaylistDialogState();
}

class _AddPlaylistDialogState extends State<AddPlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Add Playlist",
        style: TextStyle(fontSize: 20)
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                label: Text("Name",),
                border: OutlineInputBorder()
              ),
              validator: (name) {
                if (name == null || name.isEmpty) return "Please, put a name";

                return null;
              },
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
            final isValid = _formKey.currentState!.validate();

            if (isValid) {
              Navigator.pop(context);
              await widget.playlistViewModel.addPlaylist(
                Playlist(
                  id: UuidGenerator.generate(),
                  name: _name.text, 
                  backgroundColor: RandomColorPicker.generate()
                )
              );
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}