import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_recent_tracks_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/recent_track_song_card.dart';

class ShowAllPage extends StatelessWidget {
  final IRecentTracksViewModel recentTracksViewModel;

  const ShowAllPage({
    super.key, 
    required this.recentTracksViewModel,
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
            itemCount: recentTracksViewModel.getRecentTracksSongId.length,
            itemBuilder: (_, index) {
              final int songId = recentTracksViewModel.getRecentTracksSongId[index];
              final Song song = recentTracksViewModel.getSongs[songId]!;

              return Column(
                children: [
                  RecentTrackSongCard(
                    recentTracksViewModel: recentTracksViewModel,
                    songId: song.id,
                    songTitle: song.title, 
                    songVibe: song.vibe, 
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