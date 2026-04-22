import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';

class TitleSubtitle extends StatelessWidget {
  final IMusicPlayerService musicPlayerService;

  const TitleSubtitle({
    super.key,
    required this.musicPlayerService
  });

  @override
  Widget build(BuildContext context) {
    final IMusicPlayerService musicPlayerService = context
        .watch<MusicPlayerService>();

    if (musicPlayerService.getCurrentQueue().isEmpty) {
      return Column(
        children: [
          Text(
            "No Title",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "No Vibe", 
            style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      );
    }

    return StreamBuilder(
      stream: musicPlayerService.playerSequenceStateStream(), 
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