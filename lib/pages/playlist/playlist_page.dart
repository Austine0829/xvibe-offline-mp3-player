import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Playlist", style: Theme.of(context).textTheme.pageLabel),
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
                ],
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
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
        child: Icon(Icons.add, size: 30, color: Colors.black,),
      ),
    );
  }
}
