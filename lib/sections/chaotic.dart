import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
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
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Chaotic Vibes", style: Theme.of(context).textTheme.sectionLabel),
            TextButton(
              onPressed: () {

            }, 
              child: Text("Show More", style: TextStyle(color: Colors.white54))
            )
          ],
        ),
        SizedBox(
          height: 215,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder:(_, index) {
              return VerticalCard(songTitle: "My Music Card", songVibe: "Road Trip");
            }, 
            separatorBuilder: (_, _) => SizedBox(width: 8), 
            itemCount: 3
          )
        ),
      ],
    );
  }
}