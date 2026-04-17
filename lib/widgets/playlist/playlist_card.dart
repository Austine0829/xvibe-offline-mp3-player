import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/pages/playlist/playlist_songs_page.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/edit_playlist_dialog.dart';

class PlaylistCard extends StatelessWidget {
  final String textLabel;
  final String playlistId;
  final Color backgroundColor;
  
  const PlaylistCard({
    super.key,
    required this.textLabel,
    required this.playlistId,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (_) => PlaylistSongsPage(playlistId: playlistId)
            )
          );
        },
        leading: Icon(Icons.library_music),
        title: Text(textLabel),
        tileColor: backgroundColor,
        trailing: IconButton(onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return EditPlaylistDialog(playlistId: playlistId);
            }                                                                                                                                     
          );
        }, icon: Icon(Icons.edit)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
