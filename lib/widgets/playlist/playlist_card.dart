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
            PageRouteBuilder(
              pageBuilder: (_, _, _) => (
                PlaylistSongsPage(playlistId: playlistId)
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final slide = Tween(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOut));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: animation.drive(slide),
                        child: child,
                      ),
                    );
                  },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        },
        leading: Icon(Icons.library_music),
        title: Text(textLabel),
        tileColor: backgroundColor,
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return EditPlaylistDialog(playlistId: playlistId);
              },
            );
          },
          icon: Icon(Icons.edit),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
