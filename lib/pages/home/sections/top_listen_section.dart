import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_all_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/top_listen_log_song_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/recent_track_song_card.dart';

class TopListenSection extends StatefulWidget {
  const TopListenSection({super.key});

  @override
  State<TopListenSection> createState() => _TopListenSectionState();
}

class _TopListenSectionState extends State<TopListenSection> {

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<TopListenLogSongViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
  }

  @override
  Widget build(BuildContext context) {
    final TopListenLogSongViewModel topListenLogSongViewModel = context.watch<TopListenLogSongViewModel>();

    return Skeletonizer(
      enabled: false,
      child: Column(children: [
        if (topListenLogSongViewModel.getLogSongsId.isEmpty)
          SizedBox.shrink(),

        if (topListenLogSongViewModel.getLogSongsId.isNotEmpty) 
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalTextAndTextButton(
              textLabel: "Top Listen Songs",
              textButtonLabel: LabelName.showAll,
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowAllPage(
                      songLogViewModel: context.watch<TopListenLogSongViewModel>()
                    ),
                  ),
                );
              }
            ),
            Column(
              children: [
                ...List.generate(
                  topListenLogSongViewModel.getLogSongsId.length >= 5
                  ? 5 : topListenLogSongViewModel.getLogSongsId.length,
                  (index) {
                    final int songId = topListenLogSongViewModel.getLogSongsId[index];
                    final Song? song = topListenLogSongViewModel.getSongs[songId];

                    if (song == null) return SizedBox.shrink();

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: RecentTrackSongCard(
                        songLogViewModel: topListenLogSongViewModel, 
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