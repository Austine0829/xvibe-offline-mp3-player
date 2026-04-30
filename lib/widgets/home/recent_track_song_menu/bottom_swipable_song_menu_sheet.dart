import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_recent_tracks_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/recent_track_song_menu/add_to_playlist_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/set_ringtone.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/share.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/song_information.dart';
import '../../../utils/app_text_theme.dart';

class BottomSwipableSongMenuSheet extends StatelessWidget {
  static const double iconSize = 35;
  static const Color iconColor = Colors.white;
  
  final IRecentTracksViewModel recentTracksViewModel;
  final int songId;
  final int indexId;

  const BottomSwipableSongMenuSheet({
    super.key,
    required this.recentTracksViewModel,
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
                  recentTracksViewModel.play(indexId);
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
                onTap: () async {
                  Navigator.pop(context);
                  await recentTracksViewModel.getAllPlaylist();
                  if (!context.mounted) return;

                  if (recentTracksViewModel.errorMessage != null) {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(recentTracksViewModel.errorMessage!)));
                    return ;
                  }

                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AddToPlaylistDialog(
                        recentTracksViewModel: recentTracksViewModel, 
                        songId: songId
                      );
                    }
                  );
                },
                leading: Icon(
                  Icons.playlist_add_circle,
                  size: iconSize,
                  color: iconColor,
                ),
                title: Text(
                  "Add to Playlist",
                  style: Theme.of(context).textTheme.listTitleLabel,
                ),
              ), ListTile(
                onTap: () async {
                  await recentTracksViewModel
                    .addSongToCurrentQueue(songId);

                  if (!context.mounted) return;


                  final String? successMessage = recentTracksViewModel.successMessage;
                  if (successMessage != null) {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(successMessage)));
                  }

                  final String? errorMessage = recentTracksViewModel.errorMessage;
                  if (errorMessage != null) {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(errorMessage)));
                  }

                  Navigator.pop(context);
                },
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
            ],
          );
        },
      ),
    );
  }
}
