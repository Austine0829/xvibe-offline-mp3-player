import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/constants/vibe.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';
class EditDialog extends StatefulWidget {
  final IVibeViewModel vibeViewModel;
  final int songId;

  const EditDialog({
    super.key,
    required this.vibeViewModel,
    required this.songId
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();

  late final ISongService _songService;
  bool isInitialize = false;
  bool isLoading = true;
  Song? song;
  String? _selectedVibe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isInitialize) {
      _songService = context.read<SongService>();
      initialize(widget.songId);
      isInitialize = true;
    }
  }

  Future<void> initialize(int id) async {
    song = await _songService.getSong(id);
    setState(() {
      _title.text = song!.title;
      _selectedVibe = song!.vibe;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(
        "Edit",
        style: TextStyle(fontSize: 20)
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _title,
              decoration: InputDecoration(
                label: Text("Title",),
                border: OutlineInputBorder()
              ),
              validator: (title) {
                if (title == null || title.isEmpty) return "Please, put a title";

                return null;
              },
            ),
            SizedBox(height: 10,),
            DropdownButtonFormField<String>(
              initialValue: _selectedVibe,
              decoration: InputDecoration(
                label: Text("Vibe"),
                border: OutlineInputBorder()
              ),
              items: [
                Vibe.acoustic, 
                Vibe.chaotic, 
                Vibe.chill, 
                Vibe.energetic, 
                Vibe.roadTrip]
                .map((vibe) => DropdownMenuItem(
                  value: vibe,
                  child: Text(vibe)
                )
              ).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVibe = value;
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
            final isValid = _formKey.currentState!.validate();
            final Song updatedSong = song!
                                    .copyWith(title: _title.text, vibe: _selectedVibe!);

            if (isValid) {
              await widget
                .vibeViewModel
                .update(widget.songId, updatedSong);
            } 

            if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
          },
          child: Text("Update"),
        ),
      ],
    );
  }
}