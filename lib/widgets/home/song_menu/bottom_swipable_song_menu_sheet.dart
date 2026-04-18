import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/song_menu/delete_song_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/song_menu/edit_song_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/set_ringtone.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/share.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/song_information.dart';
import '../../../utils/app_text_theme.dart';

// TODO: Implement playlist function after implementing playlist page functionalities

class BottomSwipableSongMenuSheet extends StatelessWidget {
  static const double iconSize = 35;
  static const Color iconColor = Colors.white;
  
  final IVibeViewModel vibeViewModel;
  final int songId;
  final int indexId;

  const BottomSwipableSongMenuSheet({
    super.key,
    required this.vibeViewModel,
    required this.songId,
    required this.indexId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DraggableScrollableSheet(
        initialChildSize: 1,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            children: [
              ListTile(
                onTap: () {
                  vibeViewModel.play(indexId);
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
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return EditSongDialog(
                        vibeViewModel: vibeViewModel, 
                        songId: songId
                      );
                    }
                  );
                },
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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (context) {
                      return SongInformation(
                        songId: songId
                      );
                    },
                  );
                },
                leading: Icon(Icons.warning, size: iconSize, color: iconColor),
                title: Text(
                  "Song Information",
                  style: Theme.of(context).textTheme.listTitleLabel,
                ),
              ),
              ListTile(     
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return SetRingtone(
                        songId: songId
                      );
                    }
                  );
                },     
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
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => Share(songId: songId)
                    )
                  );
                },
                leading: Icon(Icons.share, size: iconSize, color: iconColor),
                title: Text(
                  "Share",
                  style: Theme.of(context).textTheme.listTitleLabel,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return DeleteSongDialog(
                        vibeViewModel: vibeViewModel,
                        songId: songId
                      );
                    }
                  );
                },
                leading: Icon(Icons.delete, size: iconSize, color: iconColor),
                title: Text(
                  "Delete",
                  style: Theme.of(context).textTheme.listTitleLabel,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
