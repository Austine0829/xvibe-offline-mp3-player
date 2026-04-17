import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/add_playlist_song_dialog.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/playlist_song_card.dart';

class PlaylistSongsPage extends StatefulWidget {
  final String playlistId;

  const PlaylistSongsPage({
    super.key, 
    required this.playlistId
  });

  @override
  State<PlaylistSongsPage> createState() => _PlaylistSongsPageState();
}

class _PlaylistSongsPageState extends State<PlaylistSongsPage> {

  @override
  void initState() {
     super.initState();
    final viewModel = context.read<PlaylistSongViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize(widget.playlistId));
  }

  @override
  Widget build(BuildContext context) {
    final IPlaylistSongViewModel playlistSongViewModel = context.watch<PlaylistSongViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: playlistSongViewModel.getPlaylistSongs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  PlaylistSongCard(
                    playlistSongViewModel: playlistSongViewModel,
                    playlistSongId: playlistSongViewModel.getPlaylistSongs[index].playlistSongId,
                    songId: playlistSongViewModel.getPlaylistSongs[index].songId,
                    title:playlistSongViewModel.getPlaylistSongs[index].title, 
                    vibe: playlistSongViewModel.getPlaylistSongs[index].vibe, 
                    indexId: index
                  ),
                  SizedBox(height: 5,)
                ],
              );
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
           showModalBottomSheet(
            context: context,
            backgroundColor: const Color.fromARGB(221, 27, 27, 27),
            showDragHandle: true,
            builder: (context) {
              return AddPlaylistSongDialog(
                playlistSongViewModel: context.watch<PlaylistSongViewModel>(),
              );
            },
          );
        },
        child: Icon(Icons.add, size: 30, color: Colors.black,),
      ),
    );
  }
}