import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/horizontal_song_card.dart';

class ShowMorePage extends StatelessWidget {
  final IVibeViewModel Function(BuildContext context) vibeViewModel;

  const ShowMorePage({
    super.key, 
    required this.vibeViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = vibeViewModel(context);

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
            itemCount: viewModel.getSongs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  HorizontalSongCard(
                    vibeViewModel: viewModel,
                    songId: viewModel.getSongs[index].id,
                    songTitle: viewModel.getSongs[index].title, 
                    songVibe: viewModel.getSongs[index].vibe, 
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