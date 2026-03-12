import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/horizontal_song_card.dart';

class ShowMorePage extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;
  final String playlistId;
  final List<Song> songs;

  const ShowMorePage({
    super.key, 
    required this.musicPlayerService,
    required this.songs,
    required this.playlistId
  });

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
            itemCount: songs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  HorizontalSongCard(
                    musicPlayerService: musicPlayerService,
                    songTitle: songs[index].title, 
                    songVibe: songs[index].vibe, 
                    playlistId: playlistId, 
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