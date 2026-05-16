import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_song_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/song_service.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';

class AddToFavorite extends StatelessWidget {
  final int songId;
  final double iconSize;
  final Color iconColor;
  final Color activeIconColor;

  const AddToFavorite({
    super.key,
    required this.songId,
    this.iconSize = 30,
    this.iconColor = Colors.white,
    this.activeIconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final ISongService songService = context.watch<SongService>();

    if (songService.getSongSources[songId]!.isFavorite) {
      return ListTile(
        onTap: () {
          songService.updateFavorite(songId, false);
        },
        leading: Icon(Icons.favorite, size: iconSize, color: activeIconColor),
        title: Text(
          "Remove to Favorite",
          style: Theme.of(context).textTheme.listTitleLabel,
        ),
      );
    }

    return ListTile(
      onTap: () {
        songService.updateFavorite(songId, true);
      },
      leading: Icon(Icons.favorite, size: iconSize, color: iconColor),
      title: Text(
        "Add to Favorite",
        style: Theme.of(context).textTheme.listTitleLabel,
      ),
    );
  }
}
