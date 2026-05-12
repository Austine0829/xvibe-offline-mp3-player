import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';

class Favorite extends StatelessWidget {
  final int songId;

  const Favorite({
    super.key, 
    required this.songId
  });

  @override
  Widget build(BuildContext context) {
    final ISongService songService = context.watch<SongService>();

    if (songService
        .getSongSources[songId]!
        .isFavorite) {
      return IconButton(
        onPressed: () async => 
          await songService.updateFavorite(songId, false),
        icon: Icon(Icons.favorite),
        color: Colors.red,
        iconSize: 35,
      );
    }

    return IconButton(
      onPressed: () async => await 
        songService.updateFavorite(songId, true),
      icon: Icon(Icons.favorite),
      color: Colors.white,
      iconSize: 35,
    );
  }
}
