import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import '../services/labeling_service.dart';
import '../widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_song_card.dart';

class AcousticSection extends StatefulWidget {
  const AcousticSection({super.key});

  @override
  State<AcousticSection> createState() => _AcousticSection();
}

class _AcousticSection extends State<AcousticSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: LabelingService.generate(LabelType.acoustic),
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
                songVibe: "Acoustic",
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
