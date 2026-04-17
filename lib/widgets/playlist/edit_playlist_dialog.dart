import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/i_playlist_service.dart';
import 'package:xvibe_offline_mp3_player/services/playlist/playlist_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_view_model.dart';

class EditPlaylistDialog extends StatefulWidget {
  final String playlistId;

  const EditPlaylistDialog({
    super.key,
    required this.playlistId,
  });

  @override
  State<EditPlaylistDialog> createState() => _EditPlaylistDialogState();
}

class _EditPlaylistDialogState extends State<EditPlaylistDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();

  late final IPlaylistService _playlistService;
  bool isInitialize = false;
  Playlist? _playlist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialize) {
      _playlistService = context.read<PlaylistService>();
      initialize(widget.playlistId);
      isInitialize = true;
    }
  }

  Future<void> initialize(String id) async {
    _playlist = await _playlistService.getPlaylist(id);
    setState(() {
      _name.text = _playlist!.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final IPlaylistViewModel playlistViewModel = context.watch<PlaylistViewModel>();

    return AlertDialog(
      title: Text(
        "Edit Playlist",
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
              final updatedPlaylist = _playlist!.copyWith(name: _name.text);
              await playlistViewModel.updatePlaylist(widget.playlistId, updatedPlaylist);
            }
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}