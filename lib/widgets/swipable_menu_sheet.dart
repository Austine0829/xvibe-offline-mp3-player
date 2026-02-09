import 'package:flutter/material.dart';

import '../utils/app_text_theme.dart';

class SwipableMenuSheet extends StatelessWidget {
  static const double iconSize = 35;
  static const Color iconColor = Colors.white;

  const SwipableMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          children: [
            ListTile(
              leading: Icon(
                Icons.play_circle,
                size: iconSize,
                color: iconColor,
              ),
              title: Text(
                "Play",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.playlist_add_circle,
                size: iconSize,
                color: iconColor,
              ),
              title: Text(
                "Add to Playlist",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.queue_music,
                size: iconSize,
                color: iconColor,
              ),
              title: Text(
                "Add to Queue",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
            ListTile(
              leading: Icon(Icons.warning, size: iconSize, color: iconColor),
              title: Text(
                "Song Information",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
                size: iconSize,
                color: iconColor,
              ),
              title: Text(
                "Set Ringtone",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
            ListTile(
              leading: Icon(Icons.share, size: iconSize, color: iconColor),
              title: Text(
                "Share",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
            ListTile(
              leading: Icon(Icons.delete, size: iconSize, color: iconColor),
              title: Text(
                "Delete",
                style: Theme.of(context).textTheme.listTitleLabel,
              ),
            ),
          ],
        );
      },
    );
  }
}
