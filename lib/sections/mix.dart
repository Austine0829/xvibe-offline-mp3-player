import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/constants/label_name.dart';
import '../widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_card.dart';

class MixSection extends StatefulWidget {
  const MixSection({super.key});

  @override
  State<MixSection> createState() => _MixSection();
}

class _MixSection extends State<MixSection> {

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalTextAndTextButton(
          textLabel: "Mix For You",
          textButtonLabel: LabelName.showMore,
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, index) {
              return VerticalCard(songTitle: "My Music Card", songVibe: "Mix");
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8), 
            itemCount: 3
          )
        ),
      ],
    );
  }
}