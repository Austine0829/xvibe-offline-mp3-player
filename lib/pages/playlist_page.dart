import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/utils/random_color_picker.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist_card.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Playlist", style: Theme.of(context).textTheme.pageLabel),
        backgroundColor: Colors.black,
      ),
      body: ListView.separated(
        itemBuilder: (_, index) {
          return PlaylistCard(
            textLabel: "My Playlist ${index + 1}",
            backgroundColor: RandomColorPicker.generate(),
          );
        },
        separatorBuilder: (_, _) => SizedBox(height: 5),
        itemCount: 10,
      ),
    );
  }
}
