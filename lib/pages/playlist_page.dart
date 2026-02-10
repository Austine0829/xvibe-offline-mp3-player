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
  List<String> data = [
    "Zero Vibe",
    "Mulawin",
    "Dancing in the Rain",
    "May Lupa Pa",
    "Baragbagan",
    "Songs That Makes you Smile",
    "Crying",
    "Effin Soul",
    "DM Me When you Get Home Vibe",
    "Road Trips",
    "Cignature",
  ];

  void reverseList() {
    setState(() {
      data = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Playlist", style: Theme.of(context).textTheme.pageLabel),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent",
                    style: Theme.of(context).textTheme.sectionLabel,
                  ),
                  IconButton(
                    onPressed: () {
                      reverseList();
                    },
                    icon: Icon(Icons.sort, color: Colors.white),
                  ),
                ],
              ),
            ),
            ...List.generate(
              data.length,
              (index) => PlaylistCard(
                textLabel: data[index],
                backgroundColor: RandomColorPicker.generate(),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
