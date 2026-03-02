import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/horizontal_song_card.dart';

class SongsPage extends StatefulWidget {
  final String pageLabel;
  final String playlistId;
  final List<Song> songs;

  const SongsPage({
    super.key, 
    required this.pageLabel,
    required this.songs,
    required this.playlistId
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: widget.songs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  HorizontalSongCard(
                    songTitle: widget.songs[index].title, 
                    songVibe: widget.songs[index].vibe, 
                    playlistId: widget.playlistId, 
                    indexId: index
                  ),
                  SizedBox(height: 5)
                ],
              );
            }
          ),
        ],
      ) 
    );
  }
}