import 'package:flutter/material.dart';
import '../services/labeling_service.dart';
import '../widgets/horizontal_text_and_text_button.dart';
import '../widgets/vertical_card.dart';

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
          label: LabelingService.generate(LabelType.acoustic),
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, index) {
              return VerticalCard(songTitle: "My Music Card", songVibe: "Acoustic");
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8), 
            itemCount: 3
          )
        ),
      ],
    );
  }
}