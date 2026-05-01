import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/mix_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/no_songs_found.dart';
import '../../../widgets/home/vibe_vertical_song_card.dart';

class MixVibeSection extends StatefulWidget {
  const MixVibeSection({super.key});

  @override
  State<MixVibeSection> createState() => _MixVibeSectionState();
}

class _MixVibeSectionState extends State<MixVibeSection> {

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<MixVibeViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
  }

   @override
  Widget build(BuildContext context) {
    final MixVibeViewModel mixVibeViewModel = context.watch<MixVibeViewModel>();

    return Skeletonizer(
      enabled: mixVibeViewModel.isLoading,
      child: Column(
        children: [
          if (mixVibeViewModel.getSongsId.isEmpty)
            NoSongsFound(),
          
          if (mixVibeViewModel.getSongsId.isNotEmpty)
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalTextAndTextButton(
                textLabel: "Mix For You",
                textButtonLabel: LabelName.showMore,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowMorePage(
                        vibeViewModel: (context) => context.watch<MixVibeViewModel>()
                      ),
                    ),
                  );
                },
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: double.infinity,
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final int songId = mixVibeViewModel.getSongsId[index];
                    final Song song = mixVibeViewModel.getSongs[songId]!;

                    return VibeVerticalSongCard(
                      vibeViewModel: mixVibeViewModel,
                      songTitle: song.title,
                      songVibe: song.vibe,
                      indexId: index,
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemCount: mixVibeViewModel.getSongsId.length >= 10 ? 10 : mixVibeViewModel.getSongsId.length,
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}