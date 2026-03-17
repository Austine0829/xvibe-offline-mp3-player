import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utils/app_text_theme.dart';

class BottomSwipableSongMenuSheet extends StatelessWidget {
  static const double iconSize = 35;
  static const Color iconColor = Colors.white;
  final VoidCallback playCallBack;

  const BottomSwipableSongMenuSheet({
    super.key,
    required this.playCallBack
  });

  void play() {
    playCallBack();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          children: [
            ListTile(
              onTap: () {
                play();
                Navigator.pop(context);
              },
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
                Icons.edit_rounded,
                size: iconSize,
                color: iconColor,
              ),
              title: Text(
                "Edit",
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
