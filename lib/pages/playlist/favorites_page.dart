import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/playlist_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/playlist/favorite_song_card.dart';

class FavoritesPage extends StatefulWidget {

  const FavoritesPage({
    super.key, 
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  @override
  void initState() {
     super.initState();
    final viewModel = context.read<PlaylistSongViewModel>();
    Future.microtask(() async => 
      await viewModel.initializeFavoriteSongs());
  }

  @override
  Widget build(BuildContext context) {
    final IPlaylistSongViewModel playlistSongViewModel = context.watch<PlaylistSongViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            itemCount: playlistSongViewModel.getFavoriteSongs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  FavoriteSongCard(
                    playlistSongViewModel: playlistSongViewModel,
                    songId: playlistSongViewModel.getFavoriteSongs[index].id,
                    title: playlistSongViewModel.getFavoriteSongs[index].title, 
                    vibe: playlistSongViewModel.getFavoriteSongs[index].vibe, 
                    indexId: index,
                    backgroundColor: playlistSongViewModel.getFavoriteSongs[index].backgroundColor
                  ),
                  SizedBox(height: 5,)
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}