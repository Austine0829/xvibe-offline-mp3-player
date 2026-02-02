import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/services/labeling_service.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
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
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:  Text(
                LabelingService.generate(LabelType.energetic), 
                style: Theme.of(context).textTheme.sectionLabel
              )
            ),
            TextButton(
              onPressed: () {

            }, 
              child: Text("Show More", style: TextStyle(color: Colors.white54))
            )
          ],
        ),
        SizedBox(height: 10),
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