import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/music_player_service.dart';

class TitleSubtitle extends StatelessWidget {
  const TitleSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: MusicPlayerService.playerSequenceStateStream(), 
      builder:(context, snapshot) {
        final state = snapshot.data;
        Song? song;
        
        if (state != null) {
          song = state.currentSource?.tag as Song;
        }

        return Column(
          children: [
            Text(
                song != null ? song.title : "No Title",
                maxLines: 1,
                style: TextStyle(color: Colors.white, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            Text(song != null ? song.vibe : "No Vibe", 
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        );
      },
    );
  }
}