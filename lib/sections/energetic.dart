import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_card.dart';

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
          label: LabelingService.generate(LabelType.energetic),
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, index) {
              return VerticalCard(songTitle: "My Music Card", songVibe: "Energetic");
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8), 
            itemCount: 3
          )
        ),
      ],
    );
  }
}