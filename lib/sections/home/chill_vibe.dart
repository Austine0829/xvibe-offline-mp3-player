import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import '../services/labeling_service.dart';
import '../widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_song_card.dart';

class ChillVibeSection extends StatefulWidget {
  const ChillVibeSection({super.key});

  @override
  State<ChillVibeSection> createState() => _ChillVibeSection();
}

class _ChillVibeSection extends State<ChillVibeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: LabelingService.generate(LabelType.chill),
          textButtonLabel: LabelName.showMore,
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return VerticalSongCard(
                songTitle: "My Music Card",
                songVibe: "Chill",
              );
            },
            separatorBuilder: (_, _) => SizedBox(width: 8),
            itemCount: 3,
          ),
        ),
      ],
    );
  }
}
