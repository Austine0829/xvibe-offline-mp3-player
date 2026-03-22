import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/horizontal_song_card.dart';

class ShowMorePage extends StatelessWidget {
  final IVibeViewModel vibeViewModel;

  const ShowMorePage({
    super.key, 
    required this.vibeViewModel
  });

  @override
  Widget build(BuildContext context) {
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
            itemCount: vibeViewModel.getSongs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  HorizontalSongCard(
                    vibeViewModel: vibeViewModel,
                    songId: vibeViewModel.getSongs[index].id,
                    songTitle: vibeViewModel.getSongs[index].title, 
                    songVibe: vibeViewModel.getSongs[index].vibe, 
                    indexId: index
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