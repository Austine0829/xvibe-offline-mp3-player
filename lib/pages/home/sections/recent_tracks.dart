import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_all_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/recent_log_songs_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/recent_track_song_card.dart';

class RecentTracksSection extends StatefulWidget {
  const RecentTracksSection({super.key});

  @override
  State<RecentTracksSection> createState() => _RecentTracksSectionState();
}

class _RecentTracksSectionState extends State<RecentTracksSection> {

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<RecentLogSongsViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
  }

  @override
  Widget build(BuildContext context) {
    final RecentLogSongsViewModel recentLogSongsViewModel = context.watch<RecentLogSongsViewModel>();

    return Skeletonizer(
      enabled: false,
      child: Column(children: [
        if (recentLogSongsViewModel.getRecentTracksSongId.isEmpty)
          SizedBox.shrink(),

        if (recentLogSongsViewModel.getRecentTracksSongId.isNotEmpty) 
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalTextAndTextButton(
              textLabel: "Today's Recent Tracks",
              textButtonLabel: LabelName.showAll,
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowAllPage(
                      songLogViewModel: context.watch<RecentLogSongsViewModel>()
                    ),
                  ),
                );
              }
            ),
            Column(
              children: [
                ...List.generate(
                  recentLogSongsViewModel.getRecentTracksSongId.length >= 5
                  ? 5 : recentLogSongsViewModel.getRecentTracksSongId.length,
                  (index) {
                    final int songId = recentLogSongsViewModel.getRecentTracksSongId[index];
                    final Song? song = recentLogSongsViewModel.getSongs[songId];

                    if (song == null) return SizedBox.shrink();

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: RecentTrackSongCard(
                        songLogViewModel: recentLogSongsViewModel, 
                        songId: song.id, 
                        songTitle: song.title, 
                        songVibe: song.vibe, 
                        indexId: index
                      )
                    );
                  }
                ),
              ],
            )
          ],
        )
      ])
    );
  }
}