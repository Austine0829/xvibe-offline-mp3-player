import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import 'package:xvibe_offline_mp3_player/services/home/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/home/horizontal_text_and_text_button.dart';
import '../../widgets/home/vertical_song_card.dart';

class EnergeticSection extends StatefulWidget {
  const EnergeticSection({super.key});

  @override
  State<EnergeticSection> createState() => _EnergeticSectionState();
}

class _EnergeticSectionState extends State<EnergeticSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: LabelingService.generate(LabelType.energetic),
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
                songVibe: "Energetic",
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
