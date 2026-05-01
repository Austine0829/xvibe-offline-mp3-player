import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/road_trip_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import 'package:xvibe_offline_mp3_player/widgets/shared/no_songs_found.dart';
import '../../../widgets/home/vibe_vertical_song_card.dart';

class RoadTripSection extends StatefulWidget {
  const RoadTripSection({super.key});

  @override
  State<RoadTripSection> createState() => _RoadTripSectionState();
}

class _RoadTripSectionState extends State<RoadTripSection> {
  
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<RoadTripVibeViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
  }

   @override
  Widget build(BuildContext context) {
    final RoadTripVibeViewModel roadTripVibeViewModel = context.watch<RoadTripVibeViewModel>();

    return Skeletonizer(
      enabled: roadTripVibeViewModel.isLoading,
      child: Column(
        children: [
          if (roadTripVibeViewModel.getSongsId.isEmpty)
            NoSongsFound(),
          
          if (roadTripVibeViewModel.getSongsId.isNotEmpty)
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalTextAndTextButton(
                textLabel: roadTripVibeViewModel.generateLabel(),
                textButtonLabel: LabelName.showMore,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowMorePage(
                        vibeViewModel: (context) => context.watch<RoadTripVibeViewModel>()
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
                    final int songId = roadTripVibeViewModel.getSongsId[index];
                    final Song? song = roadTripVibeViewModel.getSongs[songId];
                    
                    if (song == null) return SizedBox.shrink();

                    return VibeVerticalSongCard(
                      vibeViewModel: roadTripVibeViewModel,
                      songTitle: song.title,
                      songVibe: song.vibe,
                      indexId: index,
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemCount: roadTripVibeViewModel.getSongsId.length >= 10 ? 10 : roadTripVibeViewModel.getSongsId.length,
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}