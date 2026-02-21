import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/horizontal_song_card.dart';

class BrowseSearchSongListView extends StatefulWidget {
  const BrowseSearchSongListView({super.key});

  @override
  State<BrowseSearchSongListView> createState() =>
      _BrowseSearchSongListViewState();
}

class _BrowseSearchSongListViewState extends State<BrowseSearchSongListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ...List.generate(10, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: HorizontalSongCard(
                songTitle: "Random",
                songVibe: "Random",
              ),
            );
          }),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
