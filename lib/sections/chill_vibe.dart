import 'package:flutter/material.dart';
import '../services/labeling_service.dart';
import '../widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_card.dart';

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
          label: LabelingService.generate(LabelType.chill),
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, index) {
              return VerticalCard(songTitle: "My Music Card", songVibe: "Chill");
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8), 
            itemCount: 3
          )
        ),
      ],
    );
  }
}