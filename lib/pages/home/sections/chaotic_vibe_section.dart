import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/chaotic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import '../../../widgets/home/vibe_vertical_song_card.dart';

class ChaoticVibeSection extends StatefulWidget {
  const ChaoticVibeSection({super.key});

  @override
  State<ChaoticVibeSection> createState() => _ChaoticVibeSectionState();
}

class _ChaoticVibeSectionState extends State<ChaoticVibeSection> {
  late final String _label;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ChaoticVibeViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
    _label = viewModel.generateLabel();
  }

   @override
  Widget build(BuildContext context) {
    final ChaoticVibeViewModel chaoticVibeViewModel = context.watch<ChaoticVibeViewModel>();

    if (chaoticVibeViewModel.getSongsId.isEmpty && !chaoticVibeViewModel.isLoading) {
      return SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: chaoticVibeViewModel.isLoading,
      child: Column(
        children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HorizontalTextAndTextButton(
                textLabel: _label,
                textButtonLabel: LabelName.showMore,
                callback: () {
                    Navigator.push(
                    context, 
                    PageRouteBuilder(
                      pageBuilder: (_, _, _) => ShowMorePage(
                        vibeViewModel: (context) => context.watch<ChaoticVibeViewModel>(),
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                       final slide = Tween(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeOut));

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: animation.drive(slide),
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 800)
                    )
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
                    final int songId = chaoticVibeViewModel.getSongsId[index];
                    final Song? song = chaoticVibeViewModel.getSongs[songId];

                    if (song == null) return SizedBox.shrink();

                    return VibeVerticalSongCard(
                      vibeViewModel: chaoticVibeViewModel,
                      songTitle: song.title,
                      songVibe: song.vibe,
                      indexId: index,
                      backgroundColor: song.backgroundColor,
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemCount: chaoticVibeViewModel.getSongsId.length >= 10 ? 10 : chaoticVibeViewModel.getSongsId.length,
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}