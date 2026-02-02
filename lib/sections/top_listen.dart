import 'package:flutter/material.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/widgets/horizontal_card.dart';

class TopListenSection extends StatefulWidget {
  const TopListenSection({super.key});

  @override
  State<TopListenSection> createState() => _TopListenSection();
}

class _TopListenSection extends State<TopListenSection> {

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Top Listen", style: Theme.of(context).textTheme.sectionLabel),
            TextButton(
              onPressed: () {

            }, 
              child: Text("Show All", style: TextStyle(color: Colors.white54))
            )
          ],
        ),
        ...List.generate(3, (index) => 
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: HorizontalCard(songTitle: "Music Card", songVibe: "Road Trip")
          )
        )
      ],
    );
  }
}