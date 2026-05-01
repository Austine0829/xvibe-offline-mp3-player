import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chill_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/no_songs_found.dart';
import '../../../widgets/home/vibe_vertical_song_card.dart';

class ChillVibeSection extends StatefulWidget {
  const ChillVibeSection({super.key});

  @override
  State<ChillVibeSection> createState() => _ChillVibeSectionState();
}

class _ChillVibeSectionState extends State<ChillVibeSection> {
  late final String _label;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ChillVibeViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
    _label = viewModel.generateLabel();
  }

   @override
  Widget build(BuildContext context) {
    final ChillVibeViewModel chillVibeViewModel = context.watch<ChillVibeViewModel>();

    return Skeletonizer(
      enabled: chillVibeViewModel.isLoading,
      child: Column(
        children: [
          if (chillVibeViewModel.getSongsId.isEmpty)
            NoSongsFound(),
          
          if (chillVibeViewModel.getSongsId.isNotEmpty)
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalTextAndTextButton(
                textLabel: _label,
                textButtonLabel: LabelName.showMore,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowMorePage(
                        vibeViewModel: (context) => context.watch<ChillVibeViewModel>()
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
                    final int songId = chillVibeViewModel.getSongsId[index];
                    final Song song = chillVibeViewModel.getSongs[songId]!;

                    return VibeVerticalSongCard(
                      vibeViewModel: chillVibeViewModel,
                      songTitle: song.title,
                      songVibe: song.vibe,
                      indexId: index,
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemCount: chillVibeViewModel.getSongsId.length >= 10 ? 10 : chillVibeViewModel.getSongsId.length,
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}