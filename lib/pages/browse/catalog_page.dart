import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/view%20models/browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/browse/browse_song_card.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/players/music_player/swipable_music_player_handler.dart';

class CatalogPage extends StatefulWidget {
  final String playlistId;
  final String vibe;

  const CatalogPage({
    super.key,
    required this.playlistId,
    required this.vibe 
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<BrowseVibeViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize(widget.playlistId, widget.vibe));
  }

  @override
  Widget build(BuildContext context) {
    final IBrowseVibeViewModel browseVibeViewModel = context.watch<BrowseVibeViewModel>();

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
            itemCount: browseVibeViewModel.getSongs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  BrowseSongCard(
                    browseVibeViewModel: browseVibeViewModel, 
                    songId: browseVibeViewModel.getSongs[index].id, 
                    songTitle: browseVibeViewModel.getSongs[index].title, 
                    songVibe: browseVibeViewModel.getSongs[index].vibe, 
                    indexId: index,
                    backgroundColor: browseVibeViewModel.getSongs[index].backgroundColor,
                    callback: () {
                      browseVibeViewModel.play(index);
                      SwipableMusicPlayerHandler.show(SwipableMusicPlayer(), context);
                    },
                  ),
                  SizedBox(height: 5)
                ],
              );
            }
          ),
        ],
      ) 
    );
  }
}