import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/pages/playlist/favorites_page.dart';
import 'package:xvibe_offline_mp3_player/services/shared/i_music_player_service.dart';
import 'package:xvibe_offline_mp3_player/services/shared/music_player_service.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/add_playlist_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/playlist_card.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<PlaylistViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
  }

  @override
  Widget build(BuildContext context) {
    final IPlaylistViewModel playlistViewModel = context.watch<PlaylistViewModel>();
    final IMusicPlayerService musicPlayerService = context.watch<MusicPlayerService>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Playlist", style: Theme.of(context).textTheme.pageLabel),
            IconButton(
              onPressed: () {
                 showDialog(
                  context: context, 
                  builder: (context) {
                    return AddPlaylistDialog(
                      playlistViewModel: playlistViewModel,
                    );
                  }
                );
              }, 
              icon: Icon(Icons.add_rounded, color: Colors.white, size: 30,)
            )
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent",
                    style: Theme.of(context).textTheme.sectionLabel,
                  ),
                  IconButton(
                    onPressed: () {
                      playlistViewModel.sortPlaylist();
                    },
                    icon: Icon(Icons.sort, color: Colors.white),
                  ),
                ],
              ),
            ),
            Skeletonizer(
              enabled: playlistViewModel.isLoading,
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, _, _) => (
                              FavoritesPage()
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
                      leading: Icon(Icons.favorite),
                      title: Text("Favorites"),
                      tileColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ...List.generate(
                    playlistViewModel.getPlaylists.length,
                    (index) {
                      return Dismissible(
                        key: Key(playlistViewModel.getPlaylists[index].id), 
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context, 
                            builder: (context) => AlertDialog(
                              title: Text("Delete"),
                              content: Text("Are you sure you want to delete this playlist?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false), 
                                  child: Text("No")
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true), 
                                  child: Text("Yes")
                                )
                              ],
                            )
                          );
                        },
                        onDismissed: (direction) async {
                          bool isDelete = await playlistViewModel
                            .deletePlaylist(playlistViewModel.getPlaylists[index].id);
                        
                          if (isDelete && context.mounted) {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Playlist has been deleted")));
                          }
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: PlaylistCard(
                          playlistId: playlistViewModel.getPlaylists[index].id,
                          textLabel: playlistViewModel.getPlaylists[index].name,
                          backgroundColor: playlistViewModel.getPlaylists[index].backgroundColor,
                        ),
                      );
                    }
                  ),
                   StreamBuilder(
                    stream: musicPlayerService.playerSequenceStateStream(), 
                    builder: (context, snapshot) {
                      var deviceHeight = MediaQuery.of(context).size.height;
                      final state = snapshot.data;
                      int? index;

                      if (state != null) {
                        index = state.currentIndex;
                      }

                      return SizedBox(height: index != null ? 
                        deviceHeight * 0.25: 
                        deviceHeight * 0.14
                      );
                    }
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
