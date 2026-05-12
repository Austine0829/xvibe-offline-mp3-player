import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/models/song.dart';
import 'package:xvibe_offline_mp3_player/pages/home/show_more_page.dart';
import 'package:xvibe_offline_mp3_player/view%20models/energetic_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import '../../../widgets/home/vibe_vertical_song_card.dart';

class EnergeticSection extends StatefulWidget {
  const EnergeticSection({super.key});

  @override
  State<EnergeticSection> createState() => _EnergeticSectionState();
}

class _EnergeticSectionState extends State<EnergeticSection> {
  late final String _label;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<EnergeticVibeViewModel>();
    Future.microtask(() async => 
      await viewModel.initialize());
    _label = viewModel.generateLabel();
  }

   @override
  Widget build(BuildContext context) {
    final EnergeticVibeViewModel energeticVibeViewModel = context.watch<EnergeticVibeViewModel>();

    if (energeticVibeViewModel.getSongsId.isEmpty && !energeticVibeViewModel.isLoading) {
      return SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: energeticVibeViewModel.isLoading,
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
                        vibeViewModel: (context) => context.watch<EnergeticVibeViewModel>(),
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
                    final int songId = energeticVibeViewModel.getSongsId[index];
                    final Song song = energeticVibeViewModel.getSongs[songId]!;

                    return VibeVerticalSongCard(
                      vibeViewModel: energeticVibeViewModel,
                      songTitle: song.title,
                      songVibe: song.vibe,
                      indexId: index,
                      backgroundColor: song.backgroundColor,
                    );
                  },
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemCount: energeticVibeViewModel.getSongsId.length >= 10 ? 10 : energeticVibeViewModel.getSongsId.length,
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}