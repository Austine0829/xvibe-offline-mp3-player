import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import '../services/labeling_service.dart';
import '../widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_card.dart';

class ChaoticSection extends StatefulWidget {
  const ChaoticSection({super.key});

  @override
  State<ChaoticSection> createState() => _ChaoticSectionState();
}

class _ChaoticSectionState extends State<ChaoticSection> {

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: LabelingService.generate(LabelType.chaotic),
          textButtonLabel: LabelName.showMore,
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, index) {
              return VerticalCard(songTitle: "My Music Card", songVibe: "Chaotic");
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8), 
            itemCount: 3
          )
        ),
      ],
    );
  }
}