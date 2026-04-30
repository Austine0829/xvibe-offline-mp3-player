import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_all_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/i_recent_tracks_view_model.dart';
import 'package:xvibe_offline_mp3_player/view%20models/recent_tracks_view_model.dart';
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
    final viewModel = context.read<RecentTracksViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
  }

  @override
  Widget build(BuildContext context) {
    final IRecentTracksViewModel recentTracksViewModel = context.watch<RecentTracksViewModel>();

    return Skeletonizer(
      enabled: false,
      child: Column(children: [
        if (recentTracksViewModel.getRecentTracksSongId.isEmpty)
          SizedBox.shrink(),

        if (recentTracksViewModel.getRecentTracksSongId.isNotEmpty) 
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
                      recentTracksViewModel: context.watch<RecentTracksViewModel>()
                    ),
                  ),
                );
              }
            ),
            Column(
              children: [
                ...List.generate(
                  recentTracksViewModel.getRecentTracksSongId.length >= 5
                  ? 5 : recentTracksViewModel.getRecentTracksSongId.length,
                  (index) {
                    final int songId = recentTracksViewModel.getRecentTracksSongId[index];
                    final Song song = recentTracksViewModel.getSongs[songId]!;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: RecentTrackSongCard(
                        recentTracksViewModel: recentTracksViewModel, 
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